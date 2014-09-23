addpath(genpath('./'))

global screenNum screenPTR

screenNum = 0;
mode = 'PG';

%Initialize stimulus parameter structures
configurePstate(mode)
configureMstate
configureLstate


% Open PTB Screen
[screenPTR, windowRect] = Screen('OpenWindow', screenNum);

makeSyncTexture

%Make the buffer and play
switch mode
      case 'PG'
            makeGratingTexture
            playgrating
      case 'CM'
            makeRandomDots
            playRandomDots
      case 'LM'
            playgrating_lumSquare            
end
            

sca;
clear all;
