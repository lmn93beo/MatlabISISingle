function playgrating_lumSquare

global Mstate screenPTR screenNum  

global TDim bTDim %Created in makeGratingTexture

global Stxtr %Created in makeSyncTexture

Pstruct = getParamStruct;
ifi = Screen('GetFlipInterval',screenPTR);

screenRes = Screen('Resolution',screenNum);
[screenXmm, screenYmm] = Screen('DisplaySize',screenNum);

pixpercmX = screenRes.width/screenXmm * 10;
pixpercmY = screenRes.height/screenYmm * 10;

syncWX = round(pixpercmX*Mstate.syncSize);
syncWY = round(pixpercmY*Mstate.syncSize);

white = WhiteIndex(screenPTR); % pixel value for white
black = BlackIndex(screenPTR); % pixel value for black
gray = (white+black)/2;

if strcmp(Pstruct.altazimuth,'none')
    
    %The following assumes the screen is curved
    xcm = 2*pi*Mstate.screenDist*(Pstruct.x_size)/360;  %stimulus width in cm
    xN = round(xcm*pixpercmX);  %stimulus width in pixels
    ycm = 2*pi*Mstate.screenDist*(Pstruct.y_size)/360;   %stimulus height in cm
    yN = round(ycm*pixpercmY);  %stimulus height in pixels
    x_poscm = 2*pi*Mstate.screenDist*Pstruct.x_pos/360;   %stimulus height in cm
    x_posN = round(x_poscm*pixpercmX);  %stimulus height in pixels
    y_poscm = 2*pi*Mstate.screenDist*Pstruct.y_pos/360;   %stimulus height in cm
    y_posN = round(y_poscm*pixpercmY);  %stimulus height in pixels
    
    bxcm = 2*pi*Mstate.screenDist*(Pstruct.bg_x_size+Pstruct.square_amp)/360;  %background width in cm
    bxN = round(bxcm*pixpercmX);  %background width in pixels
    bycm = 2*pi*Mstate.screenDist*(Pstruct.bg_y_size+Pstruct.square_amp)/360;   %background height in cm
    byN = round(bycm*pixpercmY);  %background height in pixels
    
    bx_poscm = 2*pi*Mstate.screenDist*Pstruct.bg_x_pos/360;   %background height in cm
    bx_posN = round(bx_poscm*pixpercmX);  %background height in pixels
    by_poscm = 2*pi*Mstate.screenDist*Pstruct.bg_y_pos/360;   %background height in cm
    by_posN = round(by_poscm*pixpercmY);  %background height in pixels
    
    ampcm = 2*pi*Mstate.screenDist*Pstruct.square_amp/360; %amplitude in cm
    amp = round(ampcm*pixpercmX); %amplitude in pixels
    
else
    
    xN = 2*Mstate.screenDist*tan(Pstruct.x_size/2*pi/180);  %grating width in cm
    xN = round(xN*pixpercmX);  %grating width in pixels
    yN = 2*Mstate.screenDist*tan(Pstruct.y_size/2*pi/180);  %grating height in cm
    yN = round(yN*pixpercmY);  %grating height in pixels
    x_poscm = 2*pi*Mstate.screenDist*tan(Pstruct.x_pos/2*pi/180);   %stimulus height in cm
    x_posN = round(x_poscm*pixpercmX);  %stimulus height in pixels
    y_poscm = 2*pi*Mstate.screenDist*tan(Pstruct.y_pos/2*pi/180);   %stimulus height in cm
    y_posN = round(y_poscm*pixpercmY);  %stimulus height in pixels
    
    bxcm = 2*Mstate.screenDist*tan(Pstruct.bg_x_size/2*pi/180);  %grating width in cm
    bxN = round(bxcm*pixpercmX);  %grating width in pixels
    bycm = 2*Mstate.screenDist*tan(Pstruct.bg_y_size/2*pi/180);  %grating height in cm
    byN = round(bycm*pixpercmY);  %grating height in pixels
    bx_poscm = 2*pi*Mstate.screenDist*tan(Pstruct.bg_x_pos/2*pi/180);   %background height in cm
    bx_posN = round(bx_poscm*pixpercmX);  %background height in pixels
    by_poscm = 2*pi*Mstate.screenDist*tan(Pstruct.bg_y_pos/2*pi/180);   %background height in cm
    by_posN = round(by_poscm*pixpercmY);  %background height in pixels
    
    ampcm = 2*pi*Mstate.screenDist*tan(Pstruct.square_amp/2*pi/180); %amplitude in cm
    amp = round(ampcm*pixpercmX); %amplitude in pixels
    
end

%Note: I used to truncate these things to the screen size, but it is not
%needed.  It also messes things up.
%Define the coordinates of the small rectangle
xran = [x_posN-floor(xN/2)+1  x_posN+ceil(xN/2)];
yran = [y_posN-floor(yN/2)+1  y_posN+ceil(yN/2)];

bxran = [bx_posN-floor(bxN/2)+1  bx_posN+ceil(bxN/2)];
byran = [by_posN-floor(byN/2)+1  by_posN+ceil(byN/2)];


Npreframes = ceil(Pstruct.predelay*screenRes.hz);
Npostframes = ceil(Pstruct.postdelay*screenRes.hz);
cycles = Pstruct.stim_time/(Pstruct.t_period/screenRes.hz);
Nlast = round(TDim(3)*(cycles-floor(cycles)));  %number of frames on last cycle

nDisp = TDim(3)*ones(1,floor(cycles));  %vector of the number of frames for N-1 cycles
if Nlast >= 2 %Need one for sync start, and one for stop
    nDisp = [nDisp Nlast];  %subtract one because of last sync pulse 
elseif Nlast == 1  %This is an annoying circumstance because I need one frame for sync start
                    %and one for sync stop.  I just get rid of it as a hack.
    cycles = cycles - 1;
end
%%%%
%SyncLoc = [0 screenRes.height-syncWY syncWX-1 screenRes.height-1]';
SyncLoc = [0 0 syncWX-1 syncWY-1]';
SyncPiece = [0 0 syncWX-1 syncWY-1]';
StimLoc = [xran(1) yran(1) xran(2) yran(2)]';
height = yran(2)-yran(1);
StimPiece = [0 0 TDim(2)-1 TDim(1)-1]';
bStimPiece = [0 0 bTDim(2)-1 bTDim(1)-1]';
bStimLoc = [bxran(1) byran(1) bxran(2) byran(2)]';
%%%%

Screen(screenPTR, 'FillRect', Pstruct.background)

%Wake up the daq:
%DaqDOut(daq, 0, 0); %I do this at the beginning because it improves timing on the first call to daq below

   

%%%Play predelay %%%%
Screen('DrawTexture', screenPTR, Stxtr(1),SyncPiece,SyncLoc);
Screen(screenPTR, 'Flip');
% if loopTrial ~= -1  %if you hit "run", send pulse
%     digWord = 7;  %Make 1st,2nd,3rd bits high
%     DaqDOut(daq, 0, digWord);
% end
for i = 2:Npreframes
    Screen('DrawTexture', screenPTR, Stxtr(2),SyncPiece,SyncLoc);
    vbl=Screen(screenPTR, 'Flip');
end


freq = Pstruct.square_freq;
time = 0;

switch Pstruct.position
    case -1
        verticalshift = height/2;
    case 0
        verticalshift = 0;
    case 1
        verticalshift = -height/2;
end

%% Play stimulus
for j = 1:ceil(cycles)
%     Screen('DrawTextures', screenPTR, [Btxtr(1) Gtxtr(1) Stxtr(1)],[bStimPiece StimPiece SyncPiece],[bStimLoc StimLoc SyncLoc]);
%     vbl=Screen(screenPTR, 'Flip');
%     time = time +ifi;
    %digWord = bitxor(digWord,4);  %toggle only the 3rd bit on each grating cycle
    %DaqDOut(daq,0,digWord);  
    for i=1:nDisp(j)
        Screen('FillRect',screenPTR,Pstruct.luminance_back);
        Screen('DrawTextures', screenPTR, Stxtr(2), SyncPiece, SyncLoc);
        
        Screen('FillRect',screenPTR,Pstruct.luminance_square,(StimLoc+[amp*sin(2*pi*freq*time) verticalshift amp*sin(2*pi*freq*time) verticalshift]'));
        if Pstruct.showdot
            Screen('DrawDots', screenPTR, [x_posN y_posN],5,[255 0 0],[],2);
        end
        
        vbl=Screen(screenPTR, 'Flip',vbl+0.5*ifi);
        time = time+ifi;
    end
end



Screen('DrawTextures', screenPTR, Stxtr(1),SyncPiece,SyncLoc);
Screen(screenPTR, 'Flip');  %Show sync on last frame of stimulus
%digWord = bitxor(digWord,4);  %toggle only the 3rd bit on each grating cycle
%DaqDOut(daq, 0, digWord); 


%%%Play postdelay %%%%
for i = 1:Npostframes-1
    Screen('DrawTexture', screenPTR, Stxtr(2),SyncPiece,SyncLoc);
    Screen(screenPTR, 'Flip');
end
Screen('DrawTexture', screenPTR, Stxtr(1),SyncPiece,SyncLoc);
Screen(screenPTR, 'Flip');
% if loopTrial ~= -1 %if you hit "run", send pulse
%     digWord = bitxor(digWord,7); %toggle all 3 bits (1st/2nd bits go low, 3rd bit is flipped)
%     DaqDOut(daq, 0,digWord);
%     DaqDOut(daq, 0, 0);  %Make sure 3rd bit finishes low
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('DrawTexture', screenPTR, Stxtr(2),SyncPiece,SyncLoc);  
Screen(screenPTR, 'Flip');



