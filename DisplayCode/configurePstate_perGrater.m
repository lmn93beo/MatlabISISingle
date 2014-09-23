function configurePstate_perGrater

%Ian Nauhaus

%periodic grater

global Pstate

Pstate = struct; %clear it

Pstate.type = 'PG';

Pstate.param{1} = {'predelay'  'float'      2       0                'sec'};
Pstate.param{2} = {'postdelay'  'float'     2       0                'sec'};
Pstate.param{3} = {'stim_time'  'float'     5       0                'sec'};
Pstate.param{4} = {'ori2'         'int'        90       0                'deg'};
Pstate.param{5} = {'separable'   'int'     0       0                'bit'};
Pstate.param{6} = {'st_profile'  'string'   'sin'       0                ''};



Pstate.param{7} = {'x_pos'       'float'      30.0       0                'deg'};
Pstate.param{8} = {'y_pos'       'float'      30.0       0                'deg'};
Pstate.param{9} = {'x_size'      'float'      3       1                'deg'};
Pstate.param{10} = {'y_size'      'float'      3       1                'deg'};
Pstate.param{11} = {'ori'         'int'        0       0                'deg'};
Pstate.param{12} = {'s_freq'      'float'      1      -1                 'cyc/deg'};
Pstate.param{13} = {'t_period'    'int'       20       0                'frames'};
Pstate.param{14} = {'bg_x_size'      'float'      20       1                'deg'};
Pstate.param{15} = {'bg_y_size'      'float'      20       1                'deg'};
Pstate.param{16} = {'bg_ori'      'int'      0       0                'deg'};
Pstate.param{17} = {'bg_x_zoom'      'int'   1       0                ''};
Pstate.param{18} = {'bg_y_zoom'      'int'   1       0                ''};
Pstate.param{19} = {'bg_s_freq'      'float'      1      -1                 'cyc/deg'};
Pstate.param{20} = {'bg_x_pos'       'float'      30.0       0                'deg'};
Pstate.param{21} = {'bg_y_pos'       'float'      30.0       0                'deg'};




Pstate.param{22} = {'st_phase'         'float'        180       0                'deg'};
Pstate.param{23} = {'mask_type'   'string'   'none'       0                ''};
Pstate.param{24} = {'s_profile'   'string'   'sin'       0                ''};
Pstate.param{25} = {'s_duty'      'float'   0.5       0                ''};
Pstate.param{26} = {'s_phase'      'float'   0.0       0                'deg'};
Pstate.param{27} = {'t_profile'   'string'   'sin'       0                ''};
Pstate.param{28} = {'t_duty'      'float'   0.5       0                ''};
Pstate.param{29} = {'background'      'int'   128       0                ''};
Pstate.param{30} = {'t_phase'      'float'   0.0       0                'deg'};

Pstate.param{31} = {'y_zoom'      'int'   1       0                ''};

Pstate.param{32} = {'altazimuth'   'string'   'none'       0                ''};
Pstate.param{33} = {'tilt_alt'   'int'   0       0                'deg'};
Pstate.param{34} = {'tilt_az'   'int'   0      0                'deg'};
Pstate.param{35} = {'dx_perpbis'   'float'   0       0                'cm'};


Pstate.param{36} = {'redgain' 'float'   1       0             ''};
Pstate.param{37} = {'greengain' 'float'   1       0             ''};
Pstate.param{38} = {'bluegain' 'float'   1       0             ''};
Pstate.param{39} = {'redbase' 'float'   .5       0             ''};
Pstate.param{40} = {'greenbase' 'float'   .5       0             ''};
Pstate.param{41} = {'bluebase' 'float'   .5       0             ''};
Pstate.param{42} = {'colormod'    'int'   1       0                ''};

Pstate.param{43} = {'mouse_bit'    'int'   0       0                ''};

Pstate.param{44} = {'eye_bit'    'int'   1       0                ''};
Pstate.param{45} = {'Leye_bit'    'int'   1       0                ''};
Pstate.param{46} = {'Reye_bit'    'int'   1       0                ''};

%Plaid variables

Pstate.param{47} = {'dy_perpbis'   'float'   0      0                'cm'};


Pstate.param{48} = {'contrast'    'float'     100       0                '%'};

Pstate.param{49} = {'x_zoom'      'int'   1       0                ''};

Pstate.param{50} = {'square_amp'      'float'   1.5       0                'deg'};
Pstate.param{51} = {'square_freq'      'float'   1       0                'Hz'};
Pstate.param{52} = {'showdot'      'int'   1       0                ''};
Pstate.param{53} = {'position'   'int'   0       0                ''};







% Pstate.param{56} = {'light_bit'    'int'       0       0                ''};
% Pstate.param{57} = {'light_type'    'int'       0       0                ''};
% 
% Pstate.param{58} = {'digout'    'int'       0       0                ''};