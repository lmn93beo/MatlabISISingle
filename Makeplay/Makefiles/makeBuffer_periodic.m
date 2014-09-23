function [stimuliStruct, TDimStruct] = makeBuffer_periodic(x_size,y_size,x_zoom,y_zoom,ori,s_freq,t_period,altazimuth)

%Returns a buffer containing one cycle of the grating.

global Mstate screenPTR screenNum %movieBlock 
global Stxtr

stimuliStruct = []; TDimStruct = [];  %reset

%Preliminary calculations of screen parameters
P = getParamStruct;

screenRes = Screen('Resolution',screenNum);

[screenXmm, screenYmm] = Screen('DisplaySize',screenNum);

pixpercmX = screenRes.width/screenXmm*10;
pixpercmY = screenRes.height/screenYmm*10;


if strcmp(altazimuth,'none')
    
    %The following assumes the screen is curved
    xcm = 2*pi*Mstate.screenDist*x_size/360;  %stimulus width in cm
    xN = round(xcm*pixpercmX);  %stimulus width in pixels
    ycm = 2*pi*Mstate.screenDist*y_size/360;   %stimulus height in cm
    yN = round(ycm*pixpercmY);  %stimulus height in pixels
          
    
else
    
    %The following assumes a projection of spherical coordinates onto the
    %flat screen
    xN = 2*Mstate.screenDist*tan(x_size/2*pi/180);  %grating width in cm
    xN = round(xN*pixpercmX);  %grating width in pixels
    yN = 2*Mstate.screenDist*tan(y_size/2*pi/180);  %grating height in cm
    yN = round(yN*pixpercmY);  %grating height in pixels
    
end

xN = round(xN/x_zoom);  %Downsample for the zoom
yN = round(yN/y_zoom);

%create the mask
xdom = linspace(-x_size/2,x_size/2,xN);
ydom = linspace(-y_size/2,y_size/2,yN);
[xdom, ydom] = meshgrid(xdom,ydom);
r = sqrt(xdom.^2 + ydom.^2);

%Positions with 1's define the mask
if strcmp(P.mask_type,'disc')
    mask = zeros(size(r));
    id = find(r<=P.mask_radius);
    mask(id) = 1;
elseif strcmp(P.mask_type,'gauss')
    mask = exp((-r.^2)/(2*P.mask_radius^2));
else
    mask = [];
end
mask = single(mask);
%%%%%%%%%

%%%%%%
%%%%%%BETA VERSION
[sdom, tdom, x_ecc, y_ecc] = makeGraterDomain_beta(xN,yN,ori,s_freq,t_period,altazimuth,x_size,y_size);%orig

%Original code


for i = 1:length(tdom)

    Im = makePerGratFrame_insep(sdom,tdom,i,1);

    ImRGB = ImtoRGB(Im,P.colormod,P,mask);

    stimuliStruct(i) = Screen(screenPTR, 'MakeTexture', ImRGB);

end
    
TDimStruct = size(ImRGB(:,:,1));
TDimStruct(3) = length(stimuliStruct);



%Make S texture
% white = WhiteIndex(screenPTR); % pixel value for white
% black = BlackIndex(screenPTR); % pixel value for black
% 
% syncWX = round(pixpercmX*Mstate.syncSize);
% syncWY = round(pixpercmY*Mstate.syncSize);
% 
% Stxtr(1) = Screen(screenPTR, 'MakeTexture', white*ones(syncWY,syncWX)); % "hi"
% Stxtr(2) = Screen(screenPTR, 'MakeTexture', black*ones(syncWY,syncWX)); % "low"

end