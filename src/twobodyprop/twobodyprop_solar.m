%% 2 Body Propagator Sun
% C: 23DEC19
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

%% Plotting/Visuals
figure(1)
[a, b, c] = sphere;
cbState = [0 0 0 re];
cbColor = [0,0,0]; 
cbOBJ = mesh(a*cbState(1,4),b*cbState(1,4),c*cbState(1,4),'facecolor', 'c');
colormap(cbColor);
hold on
plot3(state(:,1),state(:,2),state(:,3),'linewidth',2)
plot3(state2(:,1),state2(:,2),state2(:,3),'linewidth',2)
hold off
xlabel('x (km)')
ylabel('y (km)')
zlabel('z (km)')
axis equal
grid on
