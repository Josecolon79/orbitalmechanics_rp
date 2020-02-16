%% 2 Body Propagator with Orbital Elements
% C: 23DEC19 LM: 09FEB20

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
xi = [-6045; -3490; 2500; -3.457; 6.618; 2.533];

% Integration Time [to,tf] in seconds
t0 = 0;
tf = 10*3600;

%% Calculation
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8) ;
tic
[t,stateX] = ode45(@rates, [t0 tf], xi, options);

for i=1:length(stateX)
    r(i) = norm(stateX(i,1:3));
end

r_ = xi(1:3);
v_ = xi(4:6);
vr = dot(v_,r_)/norm(r_);
h = cross(r_,v_);
h_ = norm(h);
i = acos(h(3)/h_)*(180/pi);
if (90<i) && (i<270)
    i_ = 'retrograde';
else
    i_ = 'prograde';
end
N = cross([0;0;1],h);
omega = acos(N(1)/norm(N))*(180/pi);
if N(2) < 0
    omega = 360-omega;
end
e = (1/mu)*((norm(v_)^2 - mu/norm(r_))*r_ - norm(r_)*vr*v_);
e_ = sqrt(dot(e,e));
w = acos(dot(N,e)/(norm(N)*e_))*(180/pi);
if e(3) < 0
    w = 360-w;
end
theta = acos(dot(e,r_)/(e_*norm(r_)))*(180/pi);
rp = (h_^2/mu)*(1/(1+e_));
ra = (h_^2/mu)*(1/(1-e_));
a = 0.5*(rp+ra);
T = ((2*pi)/sqrt(mu))*a^(3/2);
T_hrs = T/3600;
toc

disp('-------------------------------------------')
disp('Input State Vector: [x;y;z;vx;vy;vz]')
disp(' ')
disp(xi)
disp(['Propagation Time: ', num2str(tf), ' seconds'])
disp('-------------------------------------------')
disp(['Angular Momentum:    ',num2str(h_), ' km^2/s'])
disp(' ')
disp(['Inclination:         ',num2str(i), ' deg'])
disp(['Inclination Type:    ',i_])
disp(' ')
disp(['RAAN:                ',num2str(omega), ' deg'])
disp(['Eccentricity:        ',num2str(e_)])
disp(['Argument of Perigee: ',num2str(w), ' deg'])
disp(['True Anomaly:        ',num2str(theta), ' deg'])
disp(' ')
disp(['Periapsis Radius:    ',num2str(rp), ' km'])
disp(['Apoapsis Radius:     ',num2str(ra), ' km'])
disp(['Semimajor Axis:      ',num2str(a), ' km'])
disp(['Orbit Period:        ',num2str(T_hrs), ' hrs'])
disp('-------------------------------------------')

figure
[X,Y] = meshgrid(-10000:1000:10000);
Z = zeros(21);
[a, b, c] = sphere;
cbState = [0 0 0 re];
cbColor = [0,0,0]; 
cbOBJ = mesh(a*cbState(1,4),b*cbState(1,4),c*cbState(1,4),'facecolor', 'c');
colormap(cbColor);
hold on
s = mesh(X,Y,Z,'FaceAlpha','0.1');
s.FaceColor = 'flat';
plot3(stateX(:,1),stateX(:,2),stateX(:,3),'linewidth',2)
h = drawCircle(0,0,re);
hold off
legend({'Earth','Equitorial Plane','Orbit'},'fontsize',14,'location','southeast')
xlabel('x (km)')
ylabel('y (km)')
axis equal
grid on
set(gcf,'color','w')

%% EOM Function
function dYdt = rates(t,Y)
    global mu
    r = Y(1:3);
    v = Y(4:6);
    r_ = norm(r);
    Dx   = v;
    D2x  = -mu/r_^3*r;
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