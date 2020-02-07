%% 2 Body Propagator and Custom Plotting Integration P.O.C. Code
% C: 31DEC19
clear; close all; clc; format long g;

%% Kernals Initialization
% CSPICE MICE integration 
cspice_kclear;
nf009 = [pwd,filesep,fullfile('src','SPKs','naif0009.tls')];
de438 = [pwd,filesep,fullfile('src','SPKs','de438.bsp')];
cspice_furnsh({de438,nf009})

%% Inputs
% Sun-centered Propagator Values
re = 695700;
mu = 132712.4018E+06;

depbdy = '3';
[ctr_bdy] = mice_bodc2n(0);
et1 = cspice_str2et( {'Jun 06, 2034'} );
depbdyS = mice_spkezr(depbdy, et1, 'J2000', 'NONE', ctr_bdy.name);

x = depbdyS.state(1,1);
y = depbdyS.state(2,1);
z = depbdyS.state(3,1);
vx = depbdyS.state(4,1);
vy = depbdyS.state(5,1);
vz = depbdyS.state(6,1);
xp = [x; y; z; vx; vy; vz];
xsc = [x; y; z; vx+0.10819729E+02;  vy+-0.12899500E+01;  vz+-0.11320477E+01];

% Integration Time [to,tf] in seconds
ti = 0;
tf = 2*365*86400;

% Integration Options
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8) ;

%% Integrate EOMs
state = tbp(xp,tf);
state2 = tbp(xsc,tf);

%% Plotting Using plotOrbGeneric Function
plotOrbGeneric('Visuals Test', 'Earth', state(:,1:3), 'Spacecraft', state2(:,1:3))
