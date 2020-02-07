%% Trajectory Visualization
% C: 05OCT19
clear; close all; clc; format long g

%% Kernals Initialization
% CSPICE MICE integration 
cspice_kclear;
nf009 = [pwd,filesep,fullfile('src','SPKs','naif0009.tls')];
de438 = [pwd,filesep,fullfile('src','SPKs','de438.bsp')];
europaclipper = [pwd,filesep,fullfile('src','SPKs','17F12_DIR_L220604_A241223_V2_scpse.bsp')];
jovianMoons = [pwd,filesep,fullfile('src','SPKs','jup310.bsp')];
cspice_furnsh({de438,nf009,jovianMoons,europaclipper})

%% Inputs
europaclipper = '-159';
europa = '502';
ganymede = '503';
io = '501';
callisto = '504';
[ctr_bdy] = mice_bodc2n(599);
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Date Time of Visualization
et1 = cspice_str2et( {'Dec 01, 2024', 'Oct 11, 2028'} );
num_of_Pts = 10000;

%% Calculation
t1 = (0:num_of_Pts-1) * ( et1(2) - et1(1) )/num_of_Pts + et1(1);
t1cal = cspice_etcal(t1);
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%Encounter Bodies States
scale = 1;
scale_outter = 1;
scale_sun = 1;

[a, b, c] = sphere;
sun = [0 0 0 scale_sun*69911.513];
sc1 = mice_spkezr(europaclipper, t1, 'J2000', 'NONE', ctr_bdy.name );
europastate = mice_spkezr(europa, t1, 'J2000', 'NONE', ctr_bdy.name );
ganymedestate = mice_spkezr(ganymede, t1, 'J2000', 'NONE', ctr_bdy.name );
callistostate = mice_spkezr(callisto, t1, 'J2000', 'NONE', ctr_bdy.name );
iostate = mice_spkezr(io, t1, 'J2000', 'NONE', ctr_bdy.name );
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Plotting
jupiterColor = [0.800,0.712,0.576]; 
s1 = [sc1.state];
moonE = [europastate.state];
moonG = [ganymedestate.state];
moonC = [callistostate.state];
moonI = [iostate.state];

figure(1)
ax = gca;
speed = 32;

for i=1:num_of_Pts/speed
    sunOBJ = mesh(a*sun(1,4),b*sun(1,4),c*sun(1,4),'facecolor', 'y');
    colormap(jupiterColor);
    hold on
    plot3(s1(1,1:speed*i),s1(2,1:speed*i),s1(3,1:speed*i),'linewidth',2);
    plot3(s1(1,speed*i),s1(2,speed*i),s1(3,speed*i),'o-','color','r');
    plot3(moonE(1,1:speed*i),moonE(2,1:speed*i),moonE(3,1:speed*i),'linewidth',2);
    plot3(moonE(1,speed*i),moonE(2,speed*i),moonE(3,speed*i),'o-','color','r');
    plot3(moonG(1,1:speed*i),moonG(2,1:speed*i),moonG(3,1:speed*i),'linewidth',2);
    plot3(moonG(1,speed*i),moonG(2,speed*i),moonG(3,speed*i),'o-','color','r');    
    plot3(moonC(1,1:speed*i),moonC(2,1:speed*i),moonC(3,1:speed*i),'linewidth',2);
    plot3(moonC(1,speed*i),moonC(2,speed*i),moonC(3,speed*i),'o-','color','r');    
    plot3(moonI(1,1:speed*i),moonI(2,1:speed*i),moonI(3,1:speed*i),'linewidth',2);
    plot3(moonI(1,speed*i),moonI(2,speed*i),moonI(3,speed*i),'o-','color','r');    
    
    hold off
    set(gcf,'color','k');
    set(gca,'color','k');
    ax.XColor = 'w';
    ax.YColor = 'w';
    ax.ZColor = 'w';
    setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    xlabel(['X (km)'],'color','w');
    ylabel(['Y (km)'],'color','w');
    zlabel(['Z (km)'],'color','w');
    title("Europa Clipper 17F12 Trajectory | " + t1cal(speed*i,1:11),'fontsize',16,'color','w')
    daspect([1 1 1])
    grid on
    ax.GridColor = [1 1 1];
    drawnow
end
