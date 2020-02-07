%% Orbit Visualization using plotOrbGeneric
% C: 13SEP19

clear; close all; clc;

%% Kernals Initialization
% CSPICE MICE integration 
cspice_kclear;
nf009 = [pwd,filesep,fullfile('src','SPKs','naif0009.tls')];
de438 = [pwd,filesep,fullfile('src','SPKs','de438.bsp')];
cspice_furnsh({de438,nf009})

%% <Orbit Visualization from SPK Data> 
% Body Information
de43 = num2str(cspice_spkobj(de438,1000));

% Date Time of Visualization
et = cspice_str2et( {'Jun 20, 1900', 'Dec 1, 2100'} );
nopts = 10000;
times = (0:nopts-1) * ( et(2) - et(1) )/nopts + et(1);

% Central Body
[ctr_bdy] = mice_bodc2n(0);

% ECLIPJ2000 <-- references the EMO2000 Frame 
pb1 = mice_spkpos('399', times, 'J2000', 'NONE', ctr_bdy.name );
pb3 = mice_spkpos('1', times, 'J2000', 'NONE', ctr_bdy.name );
pb4 = mice_spkpos('2', times, 'J2000', 'NONE', ctr_bdy.name );
pb5 = mice_spkpos('4', times, 'J2000', 'NONE', ctr_bdy.name );
pb6 = mice_spkpos('5', times, 'J2000', 'NONE', ctr_bdy.name );
pb7 = mice_spkpos('6', times, 'J2000', 'NONE', ctr_bdy.name );
pb8 = mice_spkpos('7', times, 'J2000', 'NONE', ctr_bdy.name );
pb9 = mice_spkpos('8', times, 'J2000', 'NONE', ctr_bdy.name );
pb10 = mice_spkpos('9', times, 'J2000', 'NONE', ctr_bdy.name );
p1 = [pb1.pos]';
p3 = [pb3.pos]';
p4 = [pb4.pos]';
p5 = [pb5.pos]';
p6 = [pb6.pos]';
p7 = [pb7.pos]';
p8 = [pb8.pos]';
p9 = [pb9.pos]';
p10 = [pb10.pos]';

% Plotting
plotOrbGeneric(1,'Earth (399)',p1,'Mercury (1)',p3, ...
    'Venus (2)', p4,'Mars (4)', p5,'Jupiter (5)', p6,'Saturn (6)', p7, ...
    'Uranus (7)', p8,'Neptune (8)', p9,'Pluto (9)', p10)
