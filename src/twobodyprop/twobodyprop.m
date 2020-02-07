%% 2 Body Propagator
% C: 23DEC19

clear; close all; clc; format long g;

%% Constants
% Near Earth Prop
re = 6378;
global mu
mu = 398600;
alt = 5000;
r = alt + re;
vi = sqrt(mu/r);

%% Inputs
% State [x; y; z; vx; vy; vz]
xi = [-r; 0; 0; 0; vi; 0];
% Integration Time [to,tf] in seconds
t0 = 0;
tf = 10*3600;

% Integration Options
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8) ;


% call ode45
tic
[t,state] = ode45(@rates, [t0 tf], xi, options);
toc

figure
[a, b, c] = sphere;
cbState = [0 0 0 re];
cbColor = [0,0,0]; 
cbOBJ = mesh(a*cbState(1,4),b*cbState(1,4),c*cbState(1,4),'facecolor', 'c');
colormap(cbColor);
hold on
plot3(state(:,1),state(:,2),state(:,3),'linewidth',2)
h = drawCircle(0,0,re);
hold off
xlabel('x (km)')
ylabel('y (km)')
axis equal
grid on

%% EOM Function
function dYdt = rates(t,Y)
%{
  This function calculates first and second time derivatives of x
  governed by the equation of two-body motion

  r'' + mu/rmag^3*r = 0
 
  Dx   - velocity x'
  D2x  - acceleration x''
  Y    - column vector containing x and Dx at time t
  dYdt - column vector containing Dx and D2x at time t
%}
global mu
rvec    = Y(1:3);
vvec    = Y(4:6);
r = sqrt(rvec(1)^2+rvec(2)^2+rvec(3)^2) ;
Dx   = vvec;  % v
D2x  = -mu/r^3*rvec; % a
dYdt = [Dx; D2x];
end

function h = drawCircle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off
end