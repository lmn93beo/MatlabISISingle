function makeRandomDots
%this function generates random dots a la Britten et al, 1993
%on every frame, pixels are randomly assigned to be noise or signal pixels;
%the noise pixels are randomly relocated, the signal pixels follow the
%preset orientation; wrap around is handled by placing the pixel that run
%out on the opposite side (see longer explanation below); wrap around is 
%tested after the dots have been assigned their new locations; dots can have
%limited lifetime


global BDotFrame FDotFrame; %BDotFrame for background, FDotFrame for foreground

Pstruct = getParamStruct;

FDotFrame = makeBufferRandomDots(Pstruct.x_size,Pstruct.y_size,Pstruct.ori,...
    Pstruct.dotDensity,Pstruct.speedDots,Pstruct.dotLifetime,Pstruct.dotCoherence);
BDotFrame = makeBufferRandomDots(Pstruct.bg_x_size+2*Pstruct.square_amplitude,Pstruct.bg_y_size,Pstruct.bg_ori,...
    Pstruct.bg_dotDensity,Pstruct.bg_speedDots,Pstruct.bg_dotLifetime,Pstruct.bg_dotCoherence);

end
    
