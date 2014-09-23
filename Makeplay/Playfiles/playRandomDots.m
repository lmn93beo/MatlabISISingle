function playRandomDots

global Mstate screenPTR screenNum loopTrial

global daq  %Created in makeAngleTexture

global Stxtr %Created in makeSyncTexture

global FDotFrame BDotFrame %created in makeRandomDots

%Wake up the daq:
% DaqDOut(daq, 0, 0); %I do this at the beginning because it improves timing on the call to daq below


Pstruct = getParamStruct;

screenRes = Screen('Resolution',screenNum);
[screenXmm, screenYmm] = Screen('DisplaySize',screenNum);

pixpercmX = screenRes.width/screenXmm * 10;
pixpercmY = screenRes.height/screenYmm * 10;

syncWX = round(pixpercmX*Mstate.syncSize);
syncWY = round(pixpercmY*Mstate.syncSize);

%in all of the code, we treat the screen as if it is round. this means that
%a stimulus of size x deg ends up having a size in cm of 2pi/360*x deg*monitor
%distance (this is simply the formula for the length of an arc); then
%transform from cm to pixels

sizeDotsCm=Pstruct.sizeDots*2*pi/360*Mstate.screenDist;
sizeDotsPx=round(sizeDotsCm*pixpercmX);

bsizeDotsCm=Pstruct.bg_sizeDots*2*pi/360*Mstate.screenDist;
bsizeDotsPx=round(bsizeDotsCm*pixpercmX);

freq = Pstruct.square_frequency;



xcm = 2*pi*Mstate.screenDist*(Pstruct.x_size)/360;  %stimulus width in cm
xN = round(xcm*pixpercmX);  %stimulus width in pixels
ycm = 2*pi*Mstate.screenDist*(Pstruct.y_size)/360;   %stimulus height in cm
yN = round(ycm*pixpercmY);  %stimulus height in pixels

x_poscm = 2*pi*Mstate.screenDist*Pstruct.x_pos/360;   %stimulus pos x in cm
x_posN = round(x_poscm*pixpercmX);  %stimulus pos x in pixels
y_poscm = 2*pi*Mstate.screenDist*Pstruct.y_pos/360;   %stimulus pos y in cm
y_posN = round(y_poscm*pixpercmY);  %stimulus pos y in pixels

bx_poscm = 2*pi*Mstate.screenDist*Pstruct.bg_x_pos/360;   %stimulus pos x in cm
bx_posN = round(bx_poscm*pixpercmX);  %stimulus pos x in pixels
by_poscm = 2*pi*Mstate.screenDist*Pstruct.bg_y_pos/360;   %stimulus pos y in cm
by_posN = round(by_poscm*pixpercmY);  %stimulus pos y in pixels

axcm = 2*pi*Mstate.screenDist*(Pstruct.bg_x_size)/360;  %aperture width in cm
axN = round(axcm*pixpercmX);  %aperture width in pixels
aycm = 2*pi*Mstate.screenDist*(Pstruct.bg_y_size)/360;   %aperture height in cm
ayN = round(aycm*pixpercmY);  %aperture height in pixels

ampcm = 2*pi*Mstate.screenDist*Pstruct.square_amplitude/360; %amplitude in cm
amp = round(ampcm*pixpercmX); %amplitude in pixels

xran = [x_posN-floor(xN/2)+1  x_posN+ceil(xN/2)];
yran = [y_posN-floor(yN/2)+1  y_posN+ceil(yN/2)];
height = yran(2) - yran(1);

StimLoc = [xran(1) yran(1) xran(2) yran(2)]';

switch Pstruct.position
    case -1
        verticalshift = height/2;
    case 0
        verticalshift = 0;
    case 1
        verticalshift = -height/2;
end

%%%%%%%%%%%%%%%%%%


Npreframes = ceil(Pstruct.predelay*screenRes.hz);
Nstimframes = ceil(Pstruct.stim_time*screenRes.hz);
Npostframes = ceil(Pstruct.postdelay*screenRes.hz);


%%%%%%%%%%%%%%%

SyncLoc = [0 0 syncWX-1 syncWY-1]';
SyncPiece = [0 0 syncWX-1 syncWY-1]';

%%%%%%%%%%%%%%%

Screen(screenPTR, 'FillRect', Pstruct.background)
ifi = Screen('GetFlipInterval',screenPTR);

if Pstruct.contrast==0
    r=Pstruct.background;
    g=Pstruct.background;
    b=Pstruct.background;
else
    r=Pstruct.redgun;
    g=Pstruct.greengun;
    b=Pstruct.bluegun;
end

%%%Play predelay %%%%

% if loopTrial ~= -1
%     digWord = 1;  %Make 1st bit high
%     DaqDOut(daq, 0, digWord);
% end
for i = 1:Npreframes
    Screen('DrawDots', screenPTR, BDotFrame{1}, sizeDotsPx, [r g b],...
        [bx_posN by_posN],Pstruct.dotType);
    Screen('FillRect',screenPTR,Pstruct.background,(StimLoc+[0 verticalshift 0 verticalshift]'));
    Screen('DrawDots', screenPTR, FDotFrame{1}, sizeDotsPx, [r g b],...
        [x_posN y_posN+verticalshift],Pstruct.dotType);
    if Pstruct.showdot
        Screen('DrawDots', screenPTR, [x_posN y_posN], sizeDotsPx, [255 0 0],...
            [],Pstruct.dotType);
    end
    
    Screen ('FillRect',screenPTR,Pstruct.background,[0 0 bx_posN-axN/2 screenRes.height]);
    Screen ('FillRect',screenPTR,Pstruct.background,[0 0 screenRes.width by_posN-ayN/2]);
    Screen ('FillRect',screenPTR,Pstruct.background,[bx_posN+axN/2 0 screenRes.width screenRes.height]);
    Screen ('FillRect',screenPTR,Pstruct.background,[0 by_posN+ayN/2 screenRes.width screenRes.height]);
    Screen('DrawTexture', screenPTR, Stxtr(2),SyncPiece,SyncLoc);
    vbl=Screen(screenPTR, 'Flip');
end


%%%%%Play whats in the buffer (the stimulus)%%%%%%%%%%


% if loopTrial ~= -1
%     digWord = 3;  %toggle 2nd bit to signal stim on
%     DaqDOut(daq, 0, digWord);
% end
time = 0;
original_squareDots = FDotFrame{1};
original_backDots = BDotFrame{1};

for i = 1:Nstimframes
    
    
    [numrow, numcol] = size(FDotFrame{1});
    [numrowb, numcolb] = size(BDotFrame{1});
    
    currentSquareDots = original_squareDots + repmat([amp*sin(2*pi*freq*time); 0],[1 numcol]);
    currentBackDots = original_backDots - repmat([amp*sin(2*pi*freq*time); 0],[1 numcolb]);
    Screen('DrawDots', screenPTR, currentBackDots, sizeDotsPx, [r g b],...
        [bx_posN by_posN],Pstruct.dotType);
    Screen('FillRect',screenPTR,Pstruct.background,(StimLoc+[amp*sin(2*pi*freq*time) verticalshift amp*sin(2*pi*freq*time) verticalshift]'));
    Screen('DrawDots', screenPTR, currentSquareDots, sizeDotsPx, [r g b],...
        [x_posN y_posN+verticalshift],Pstruct.dotType);
    if Pstruct.showdot
        Screen('DrawDots', screenPTR, [x_posN y_posN], sizeDotsPx, [255 0 0],...
            [],Pstruct.dotType);
    end
    Screen ('FillRect',screenPTR,Pstruct.background,[0 0 bx_posN-axN/2 screenRes.height]);
    Screen ('FillRect',screenPTR,Pstruct.background,[0 0 screenRes.width by_posN-ayN/2]);
    Screen ('FillRect',screenPTR,Pstruct.background,[bx_posN+axN/2 0 screenRes.width screenRes.height]);
    Screen ('FillRect',screenPTR,Pstruct.background,[0 by_posN+ayN/2 screenRes.width screenRes.height]);
    
    Screen('DrawTextures', screenPTR,Stxtr(1),SyncPiece,SyncLoc);
    vbl = Screen(screenPTR, 'Flip',vbl+0.5*ifi);
    time = time + ifi;
end
% if loopTrial ~= -1
%     digWord = 1;  %toggle 2nd bit to signal stim off
%     DaqDOut(daq, 0, digWord);
% end

%%%Play postdelay %%%%
for i = 1:Npostframes-1
    Screen('DrawDots', screenPTR, currentBackDots, sizeDotsPx, [r g b],...
        [bx_posN by_posN],Pstruct.dotType);
    Screen('FillRect',screenPTR,Pstruct.background,(StimLoc+[amp*sin(2*pi*freq*time) verticalshift amp*sin(2*pi*freq*time) verticalshift]'));
    Screen('DrawDots', screenPTR, currentSquareDots, sizeDotsPx, [r g b],...
        [x_posN y_posN+verticalshift],Pstruct.dotType);
    if Pstruct.showdot
        Screen('DrawDots', screenPTR, [x_posN y_posN], sizeDotsPx, [255 0 0],...
            [],Pstruct.dotType);
    end
    Screen ('FillRect',screenPTR,Pstruct.background,[0 0 bx_posN-axN/2 screenRes.height]);
    Screen ('FillRect',screenPTR,Pstruct.background,[0 0 screenRes.width by_posN-ayN/2]);
    Screen ('FillRect',screenPTR,Pstruct.background,[bx_posN+axN/2 0 screenRes.width screenRes.height]);
    Screen ('FillRect',screenPTR,Pstruct.background,[0 by_posN+ayN/2 screenRes.width screenRes.height]);
    Screen('DrawTextures', screenPTR,Stxtr(1),SyncPiece,SyncLoc);
    Screen(screenPTR, 'Flip');
end

if loopTrial ~= -1
    %digWord = bitxor(digWord,7); %toggle all 3 bits (1st/2nd bits go low, 3rd bit is flipped)
    %DaqDOut(daq, 0,digWord);  
%     DaqDOut(daq, 0, 0);  %Make sure 3rd bit finishes low
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('DrawTexture', screenPTR, Stxtr(2),SyncPiece,SyncLoc);  
Screen(screenPTR, 'Flip');

