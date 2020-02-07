function plotOrbGeneric(varargin)
% PLOTORB1 Orbit Visualization for N number of bodies
%
%   C: 13SEP19 LM: 31DEC19
%
%   Inputs:
%       ft = Title of Figure (string)
%       'bdy' = Body Name (string)
%       state = array containing state data (collums of X, Y, Z data)
%                (:,1) = x component
%                (:,2) = y component
%                (:,3) = z component
%
%       Repeat 'bdy' and state for however many bodies that need to be
%       plotted.
%       
%   Outputs:
%       figure(#)
%
%

ft = (varargin(1));
figure()
hold on
for i=2:1+((length(varargin)-1)/2)
    state = cell2mat(varargin(1,i+i-1));
    plot3(state(:,1),state(:,2),state(:,3),'linewidth',1.5,'DisplayName',cell2mat(varargin(1,i+i-2)));
end
legend('show')    
hold off
ax = gca;
axis equal
set(gcf,'color','k');
set(gca,'color','k');
ax.XColor = 'w';
ax.YColor = 'w';
ax.ZColor = 'w';
setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
xlabel(['X (km)'],'color','w','fontsize',14);
ylabel(['Y (km)'],'color','w','fontsize',14);
zlabel(['Z (km)'],'color','w','fontsize',14);
title([ft],'color','w','fontsize',18);
view(180,270)
grid on
ax.GridColor = [1 1 1];
end