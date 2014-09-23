function playgrating

global Mstate screenPTR screenNum loopTrial

global Gtxtr TDim Btxtr B bTDim daq  %Created in makeGratingTexture

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
Pstate.background = (white+black)/2;



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
    
    bxcm = 2*pi*Mstate.screenDist*(Pstruct.bg_x_size+2*Pstruct.square_amp)/360;  %background width in cm
    bxN = round(bxcm*pixpercmX);  %background width in pixels
    bycm = 2*pi*Mstate.screenDist*(Pstruct.bg_y_size+2*Pstruct.square_amp)/360;   %background height in cm
    byN = round(bycm*pixpercmY);  %background height in pixels
    
    axcm = 2*pi*Mstate.screenDist*(Pstruct.bg_x_size)/360;  %aperture width in cm
    axN = round(axcm*pixpercmX);  %aperture width in pixels
    aycm = 2*pi*Mstate.screenDist*(Pstruct.bg_y_size)/360;   %aperture height in cm
    ayN = round(aycm*pixpercmY);  %aperture height in pixels
    
    
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


cycles = Pstruct.stim_time/(Pstruct.t_period/screenRes.hz);
Nlast = round(TDim(3)*(cycles-floor(cycles)));  %number of frames on last cycle

nDisp = TDim(3)*ones(1,floor(cycles));  %vector of the number of frames for N-1 cycles
if Nlast >= 2 %Need one for sync start, and one for stop
    nDisp = [nDisp Nlast];  %subtract one because of last sync pulse 
elseif Nlast == 1  %This is an annoying circumstance because I need one frame for sync start
                    %and one for sync stop.  I just get rid of it as a hack.
    cycles = cycles - 1;
end

nDisp(end) = nDisp(end)-1; %subtract one because of last sync pulse


Npreframes = ceil(Pstruct.predelay*screenRes.hz);
Npostframes = ceil(Pstruct.postdelay*screenRes.hz);

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

switch Pstruct.position
    case 1
        verticalshift = -height/2;
    case 0
        verticalshift = 0;
    case -1
        verticalshift = height/2;
end 

Screen(screenPTR, 'FillRect', Pstruct.background)

 

%%%Play predelay %%%%
Screen('DrawTexture', screenPTR, Stxtr(1),[],SyncLoc);
Screen(screenPTR, 'Flip');

for i = 2:Npreframes
    Screen('DrawTexture', screenPTR, Stxtr(2),[],SyncLoc);
    vbl=Screen(screenPTR, 'Flip');
end

freq = Pstruct.square_freq;
time = 0;
%%%%%Play whats in the buffer (the stimulus)%%%%%%%%%%
for j = 1:ceil(cycles)
 
    for i=1:nDisp(j)
        
        Screen('DrawTextures', screenPTR, [Btxtr(1) Gtxtr(1)],[bStimPiece StimPiece],...
            [(bStimLoc-[amp*sin(2*pi*freq*time) 0 amp*sin(2*pi*freq*time) 0]') (StimLoc+[amp*sin(2*pi*freq*time) verticalshift amp*sin(2*pi*freq*time) verticalshift]')]);
        if Pstruct.showdot
            Screen('DrawDots', screenPTR, [x_posN y_posN],5,[255 0 0],[],2);
        end
        Screen ('FillRect',screenPTR,Pstate.background,[0 0 bx_posN-axN/2 screenRes.height]);
        Screen ('FillRect',screenPTR,Pstate.background,[0 0 screenRes.width by_posN-ayN/2]);
        Screen ('FillRect',screenPTR,Pstate.background,[bx_posN+axN/2 0 screenRes.width screenRes.height]);
        Screen ('FillRect',screenPTR,Pstate.background,[0 by_posN+ayN/2 screenRes.width screenRes.height]);
        Screen ('DrawTextures', screenPTR, Stxtr(2), SyncPiece,SyncLoc);
        
        vbl=Screen(screenPTR, 'Flip',vbl+0.5*ifi);
        time = time+ifi;
    end
end


Screen('DrawTextures', screenPTR, [Gtxtr(nDisp(j)+1) Stxtr(1)],[StimPiece SyncPiece],[StimLoc SyncLoc]);
Screen(screenPTR, 'Flip');  %Show sync on last frame of stimulus


%%%Play postdelay %%%%
for i = 1:Npostframes-1
    Screen('DrawTexture', screenPTR, Stxtr(2),SyncPiece,SyncLoc);
    Screen(screenPTR, 'Flip');
end
Screen('DrawTexture', screenPTR, Stxtr(1),SyncPiece,SyncLoc);
Screen(screenPTR, 'Flip');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('DrawTexture', screenPTR, Stxtr(2),SyncPiece,SyncLoc);  
Screen(screenPTR, 'Flip');

sca;


