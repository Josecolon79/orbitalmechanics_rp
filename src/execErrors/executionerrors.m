%% Velocity Execution Error Analysis Tool
% Assumes 2BP and Deterministic Position Vector
% C: 02JAN20

clear; close all; clc; start = tic;

%% Plotting Options
plt1 = 0;   % Plot 3-D Trajectories Visual
plt2 = 0;   % Plot Position Dispersion
plt3 = 1;   % Plot Velocity Dispersion
plt4 = 1;   % Sample Errors Generated

%% Inputs
re = 6378;
mu = 398600;  % Earth
%mu = 1.327e11; % Sun km3/s2

alt = 50000;
r = alt + re;
vi = sqrt(mu/r);
tf = 1*24*3600;
tfh = tf/3600;

% Initial Position and Velocity
p  = [r; r; r/10];
v  = [0;vi; vi/10];

% Delta-V Vector
dv = [0.000;0.05000;0.000];   % in km/s
% Bias error of the DV in a particular dir. (0 bias off. 1 = max bias)
dvbias = [0.2 1 0.2];

% States
xi = [p;v];
x2 = [p;(v+dv)];
state  = tbp(xi,tf,mu); % No Maneuver
state2 = tbp(x2,tf,mu); % Deterministic Maneuver

% Execution Errors
tic
s = 100;                    % # of Random Velocity Samples to Generate
sig3estPercent = 0.01;      % 01%=3Sigma
R = execError(1,dv,sig3estPercent,s,dvbias);
vmag = norm(dv);

%% Calculation
for i=1:size(R,1)
    x3 = [p;(v+dv+R(i,1:3)')];
    x2 = [p;(v+dv+R(i,5:7)')];
    x1 = [p;(v+dv+R(i,9:11)')];
    stateError(i).state3 = tbp(x3,tf,mu);
    stateError(i).state2 = tbp(x2,tf,mu);
    stateError(i).state1 = tbp(x1,tf,mu);
end
disp('Execution Errors Calculation Time')
toc
disp(' ')


%% Visuals
if plt1==1
    tic
    hold on
    for i=1:length(stateError)
        plot3(stateError(i).state3(:,1),stateError(i).state3(:,2),stateError(i).state3(:,3),'linewidth',1.5,'color','b');
        plot3(stateError(i).state2(:,1),stateError(i).state2(:,2),stateError(i).state2(:,3),'linewidth',1.5,'color','m');
        plot3(stateError(i).state1(:,1),stateError(i).state1(:,2),stateError(i).state1(:,3),'linewidth',1.5,'color','c');

        if i ==1
            plot3(state2(:,1),state2(:,2),state2(:,3),'linewidth',1.5,'color','r');
        end

    end
    [a, b, c] = sphere;
    cbState = [0 0 0 re];
    cbColor = [0,0,0]; 
    cbOBJ = mesh(a*cbState(1,4),b*cbState(1,4),c*cbState(1,4),'facecolor', 'c');
    colormap(cbColor);
    hold off
    ax = gca;
    axis equal
    set(gcf,'color','k');
    set(gca,'color','k');
    ax.XColor = 'w';
    ax.YColor = 'w';
    ax.ZColor = 'w';
    xlabel('X (km)','color','w','fontsize',14);
    ylabel('Y (km)','color','w','fontsize',14);
    zlabel('Z (km)','color','w','fontsize',14);
    title(['Plotted Trajectory Dispersion of a ',num2str(vmag),' km/s burn | ',num2str(tfh),'-hr. Prop.'],'color','w','fontsize',18);
    legend({'\color{white}3\sigma','\color{white}2\sigma','\color{white}1\sigma','\color{white}Det.'},'fontsize',16,'location','southeast','color','k')
    view(360,90)
    grid on
    ax.GridColor = [1 1 1];
    disp('Trajectories Visual Calculation Time')
    toc
    disp(' ')

end


if plt2==1
    tic
    figure(2)
    hold on
    for j=1:length(stateError)

        x = stateError(j).state3(end,1);
        y = stateError(j).state3(end,2);
        z = stateError(j).state3(end,3);
        scatter3(x,y,z,'b')

        x = stateError(j).state2(end,1);
        y = stateError(j).state2(end,2);
        z = stateError(j).state2(end,3);
        scatter3(x,y,z,'m')

        x = stateError(j).state1(end,1);
        y = stateError(j).state1(end,2);
        z = stateError(j).state1(end,3);
        scatter3(x,y,z,'c')

        if j==1
            scatter3(state2(end,1),state2(end,2),state2(end,3),'filled','r')
        end
    end
    hold off
    ax = gca;
    axis equal
    set(gcf,'color','w');
    set(gca,'color','w');
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.ZColor = 'k';
    setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    xlabel('X (km)','color','k','fontsize',14);
    ylabel('Y (km)','color','k','fontsize',14);
    zlabel('Z (km)','color','k','fontsize',14);
    title(['Position Dispersion of a ',num2str(vmag),' km/s burn | ',num2str(tfh),'-hr. Prop.'],'color','k','fontsize',18);
    legend({'\color{black}3\sigma','\color{black}2\sigma','\color{black}1\sigma','\color{black}Det.'},'fontsize',16,'location','southeast','color','w')
    view(360,90)
    grid on
    ax.GridColor = [0 0 0];
    disp('Position Dispersion Visual Calculation Time')
    toc
    disp(' ')
end

if plt3==1
    figure(3)
    tic
    hold on
    for j=1:length(stateError)

        x = stateError(j).state3(end,4);
        y = stateError(j).state3(end,5);
        z = stateError(j).state3(end,6);
        scatter3(x,y,z,'b')

        x = stateError(j).state2(end,4);
        y = stateError(j).state2(end,5);
        z = stateError(j).state2(end,6);
        scatter3(x,y,z,'m')

        x = stateError(j).state1(end,4);
        y = stateError(j).state1(end,5);
        z = stateError(j).state1(end,6);
        scatter3(x,y,z,'c')

        if j==1
            scatter3(state2(end,4),state2(end,5),state2(end,6),'filled','r')
        end
    end
    hold off
    ax = gca;
    axis equal
    set(gcf,'color','w');
    set(gca,'color','w');
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.ZColor = 'k';
    setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
    xlabel('V_X (km/s)','color','k','fontsize',14);
    ylabel('V_Y (km/s)','color','k','fontsize',14);
    zlabel('V_Z (km/s)','color','k','fontsize',14);
    title(['Velocity Dispersion of a ',num2str(vmag),' km/s burn | ',num2str(tfh),'-hr. Prop.'],'color','k','fontsize',18);
    legend({'\color{black}3\sigma','\color{black}2\sigma','\color{black}1\sigma','\color{black}Det.'},'fontsize',16,'location','southeast','color','w')
    view(360,90)
    grid on
    ax.GridColor = [0 0 0];
    disp('Velocity Dispersion Visual Calculation Time')
    toc
    disp(' ')
end

if plt4==1
    
    RR(1:1:s,1) = vmag*(sig3estPercent/3);
    RR(1:1:s,2) = vmag*((sig3estPercent/3)+(sig3estPercent/3));
    RR(1:1:s,3) = vmag*sig3estPercent;
    RR(1:1:s,4) = 0;
    
    
    tic
    figure(4)
    annotation('textbox', [0 0.9 1 0.1], ...
        'String', ['\DeltaV_e_r_r_o_r from a ',num2str(vmag),' km/s burn | 3\sigma = ',num2str(sig3estPercent*100),'% Est. Model'], ...
        'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center','fontsize',20)

    subplot(1,3,1)
    hold on
    plot(R(:,1),'linewidth',1.5)
    plot(R(:,2),'linewidth',1.5)
    plot(R(:,3),'linewidth',1.5)
    plot(R(:,4),'linewidth',1.5,'color','k')
    plot(RR(:,1),' --','linewidth',1.5,'color','r')
    plot(RR(:,2),' --','linewidth',1.5,'color','r')
    plot(RR(:,3),' --','linewidth',1.5,'color','r')
    plot(-RR(:,1),' --','linewidth',1.5,'color','r')
    plot(-RR(:,2),' --','linewidth',1.5,'color','r')
    plot(-RR(:,3),' --','linewidth',1.5,'color','r')
    plot(RR(:,4),' -','linewidth',1.5,'color','r')
    hold off
    xlabel('Samples','fontsize',16)
    ylabel('Random Execution Delta (km/s)','fontsize',16)
    title('2\sigma - 3\sigma','fontsize',18)
    legend({'V_x','V_y','V_z','V_m_a_g','\sigma'},'fontsize',16,'location','southwest')
    set(gcf,'color','w');
    set(gca,'color','w');
    xlim([0 s]);
    grid on

    subplot(1,3,2)
    hold on
    plot(R(:,5),'linewidth',1.5)
    plot(R(:,6),'linewidth',1.5)
    plot(R(:,7),'linewidth',1.5)
    plot(R(:,8),'linewidth',1.5,'color','k')
    plot(RR(:,1),' --','linewidth',1.5,'color','r')
    plot(RR(:,2),' --','linewidth',1.5,'color','r')
    plot(RR(:,3),' --','linewidth',1.5,'color','r')
    plot(-RR(:,1),' --','linewidth',1.5,'color','r')
    plot(-RR(:,2),' --','linewidth',1.5,'color','r')
    plot(-RR(:,3),' --','linewidth',1.5,'color','r')
    plot(RR(:,4),' -','linewidth',1.5,'color','r')
    hold off
    xlabel('Samples','fontsize',16)
    ylabel('Random Execution Delta (km/s)','fontsize',16)
    title('1\sigma - 2\sigma','fontsize',18)
    legend({'V_x','V_y','V_z','V_m_a_g','\sigma'},'fontsize',16,'location','southwest')
    set(gcf,'color','w');
    set(gca,'color','w');
    xlim([0 s]);
    grid on

    subplot(1,3,3)
    hold on
    plot(R(:,9),'linewidth',1.5)
    plot(R(:,10),'linewidth',1.5)
    plot(R(:,11),'linewidth',1.5)
    plot(R(:,12),'linewidth',1.5,'color','k')
    plot(RR(:,1),' --','linewidth',1.5,'color','r')
    plot(RR(:,2),' --','linewidth',1.5,'color','r')
    plot(RR(:,3),' --','linewidth',1.5,'color','r')
    plot(-RR(:,1),' --','linewidth',1.5,'color','r')
    plot(-RR(:,2),' --','linewidth',1.5,'color','r')
    plot(-RR(:,3),' --','linewidth',1.5,'color','r')
    plot(RR(:,4),' -','linewidth',1.5,'color','r')
    hold off
    xlabel('Samples','fontsize',16)
    ylabel('Random Execution Delta (km/s)','fontsize',16)
    title('0\sigma - 1\sigma','fontsize',18)
    legend({'V_x','V_y','V_z','V_m_a_g','\sigma'},'fontsize',16,'location','southwest')
    set(gcf,'color','w');
    set(gca,'color','w');
    xlim([0 s]);
    grid on
    disp('Error Values Dispersion Visual Calculation Time')
    toc
    disp(' ')
end

elapsed = toc(start);
disp('Total Computation Time')
disp(['Elapsed time is ' , num2str(elapsed),' seconds.'])
