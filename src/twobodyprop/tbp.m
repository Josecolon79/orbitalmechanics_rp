function state = tbp(varargin)
%TBP Two Body Propagator Function
%   A simple two body propagator using ODE45
%
%   The tbp function uses variable inputs begining in the numbered order
%   below.
%
%   Inputs (Minimum: 2, Maximum: 5 inputs):
%       1. x : [6x1] State vector in km and km/s [x;y;z;vx;vy;vz]
%       2. tf: Integration stop time (assumes ti=0 seconds unless specified)
%       3. mu: Central body gravitational parameter in km^3/s^2
%       4. ti: Integration start time (in seconds) if non-zero
%       5. options: ODE45 integration options
%       
%   Outputs an array called "state" with columns:
%       1. x (km)
%       2. y (km)
%       3. z (km)
%       4. vx (km/s)
%       5. vy (km/s)
%       6. vz (km/s)
%       7. t (physical time in seconds)
%
%disp('2-Body EOM Integration')
vis = 0;

switch nargin
    case 2
        x = cell2mat(varargin(1));
        tf = cell2mat(varargin(2));
        ti = 0;
        disp('    Assuming Sun as CB');
        mu = 132712.4018E+06;
        disp('    ODE45 Integration Options: RelTol = 1e-8, AbsTol = 1e-8')
        options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);
    case 3
        x = cell2mat(varargin(1));
        tf = cell2mat(varargin(2));
        mu = cell2mat(varargin(3));
        ti = 0;
        %disp('    ODE45 Integration Options: RelTol = 1e-8, AbsTol = 1e-8')
        options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);
    case 4
        x = cell2mat(varargin(1));
        tf = cell2mat(varargin(2));
        mu = cell2mat(varargin(3));
        ti = cell2mat(varargin(4));
        disp('    ODE45 Integration Options: RelTol = 1e-8, AbsTol = 1e-8')
        options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);
    case 5
        x = cell2mat(varargin(1));
        tf = cell2mat(varargin(2));
        mu = cell2mat(varargin(3));
        ti = cell2mat(varargin(4));
        options = varargin(5);
    otherwise
        error('    Unexpected number of inputs. See function help')
end
%tic
[t,state] = ode45(@rates, [ti tf], x, options);
state(:,7) = t;

if vis == 1
    disp('    Vis. ON')
    figure
    hold on
    plot3(state(:,1),state(:,2),state(:,3),'linewidth',2)
    hold off
    xlabel('x (km)')
    ylabel('y (km)')
    zlabel('z (km)')
    axis equal
    grid on
else
%    disp('    Vis. OFF')
end
%toc
%disp(' ')


%% Equations of 2-Body Motion
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
        rvec    = Y(1:3);
        vvec    = Y(4:6);
        r = sqrt(rvec(1)^2+rvec(2)^2+rvec(3)^2) ;
        Dx   = vvec;  % v
        D2x  = -mu/r^3*rvec; % a
        dYdt = [Dx; D2x];
    end

end

