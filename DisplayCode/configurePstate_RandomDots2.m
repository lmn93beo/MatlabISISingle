function configurePstate_RandomDots2
%periodic random dot

global Pstate

Pstate = struct; %clear it

Pstate.type = 'CM';

Pstate.param{1} = {'predelay'  'float'      2       0                'sec'};
Pstate.param{2} = {'postdelay'  'float'     2       0                'sec'};
Pstate.param{3} = {'stim_time'  'float'     5       0                'sec'};

Pstate.param{4} = {'x_pos'       'int'      30       0                'deg'};
Pstate.param{5} = {'y_pos'       'int'      30       0                'deg'};
Pstate.param{6} = {'x_size'      'float'      3       1                'deg'};
Pstate.param{7} = {'y_size'      'float'      3       1                'deg'};
Pstate.param{8} = {'mask_type'   'string'   'none'       0                'none, disc'};
Pstate.param{9} = {'mask_radius' 'float'      6       1                'deg'};

Pstate.param{10} = {'ori'      'int'     0       1                'deg'};

Pstate.param{11} = {'dotDensity'      'float'      100       1                'dots/(deg^2 s)'};
Pstate.param{12} = {'sizeDots'      'float'     0.2       1                'deg'};
Pstate.param{13} = {'speedDots'      'float'     5       1                'deg/s'};
Pstate.param{14} = {'dotLifetime'      'int'     0       1                'frames, 0 inf'};
Pstate.param{15} = {'dotCoherence'      'int'     100       1                '%'};
Pstate.param{16} = {'dotType'      'int'     0       1                'sq, circ'};
   
Pstate.param{17} = {'background'      'int'   128       0                ''};
Pstate.param{18} = {'redgun' 'int'   255       0             ''};
Pstate.param{19} = {'greengun' 'int'   255       0             ''};
Pstate.param{20} = {'bluegun' 'int'   255       0             ''};
Pstate.param{21} = {'contrast'    'float'     100       0                '%'};

Pstate.param{22} = {'bg_x_pos'       'int'      30       0                'deg'};
Pstate.param{23} = {'bg_y_pos'       'int'      30       0                'deg'};
Pstate.param{24} = {'bg_x_size'      'float'      20       1                'deg'};
Pstate.param{25} = {'bg_y_size'      'float'      20       1                'deg'};
Pstate.param{26} = {'bg_ori'      'int'     0       1                'deg'};
Pstate.param{27} = {'bg_dotDensity'      'float'      100       1                'dots/(deg^2 s)'};
Pstate.param{28} = {'bg_sizeDots'      'float'     0.2       1                'deg'};
Pstate.param{29} = {'bg_speedDots'      'float'     5       1                'deg/s'};
Pstate.param{30} = {'bg_dotLifetime'      'int'     0       1                'frames, 0 inf'};
Pstate.param{31} = {'bg_dotCoherence'      'int'     100       1                '%'};

Pstate.param{32} = {'square_amplitude'      'float'     1.5       1                'deg'};
Pstate.param{33} = {'square_frequency'      'float'     1       1                'Hz'};
Pstate.param{34} = {'showdot'      'int'   1       0                ''};
Pstate.param{35} = {'position'      'int'     0       0                ''};


