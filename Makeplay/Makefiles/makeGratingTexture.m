function makeGratingTexture

%make one cycle of the grating

global Gtxtr TDim  Btxtr bTDim %'playgrating' will use these (Background = Btxtr; Grating = Gtxtr)

%Screen('Close');  %First clean up: Get rid of all textures/offscreen windows

P = getParamStruct;

[Gtxtr, TDim] = makeBuffer_periodic(P.x_size,P.y_size,P.x_zoom,P.y_zoom,P.ori,P.s_freq,P.t_period,P.altazimuth);

[Btxtr, bTDim] = makeBuffer_periodic(P.bg_x_size+2*P.square_amp,P.bg_y_size+2*P.square_amp,P.bg_x_zoom,P.bg_y_zoom,P.bg_ori,P.bg_s_freq,P.t_period,P.altazimuth);