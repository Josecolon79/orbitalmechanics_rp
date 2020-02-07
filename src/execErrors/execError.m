
function R = execError(varargin)
%EXECERROR Creates Error Delta Values Given a Velocity Vector
%
%   This is only calculates the ERRORS! Not the final DV Vector!
%
%   Inputs: varargin
%       1. (REQ.) flag = 1 or 0
%       2. (REQ.) DeltaV vector = [1x3] or [3x1] or [1x1]
%       3.        3sigma % Value expressed as a decimal
%       4.        #ofSamples/Sigma (Total Samples = this number*3)
%       5.        Delta-V Component Bias [x y z]
%                   any value between 0 and 1 to serve as a multiplier to
%                   the Delta-V error. For example: if there is no
%                   z-component to the Delta-V vector, the bias can be very
%                   little (between 0 and probably 0.1). Setting all three
%                   components to 1 makes random errors purely from the
%                   Delta-V magnitude.
%
%   Output: R Matrix
%       (:,1:4)  = 3 Sigma x,y,z,mag
%       (:,5:8)  = 2 Sigma x,y,z,mag
%       (:,9:12) = 1 Sigma x,y,z,mag
%

    switch nargin
        case 2
            flag = cell2mat(varargin(1));
            dv = cell2mat(varargin(2));
            sig3estPercent = 0.10;
            s = 100;
            dvbias = [1 1 1];
        case 3
            flag = cell2mat(varargin(1));
            dv = cell2mat(varargin(2));
            sig3estPercent = cell2mat(varargin(3));
            s = 100;
            dvbias = [1 1 1];
        case 4
            flag = cell2mat(varargin(1));
            dv = cell2mat(varargin(2));
            sig3estPercent = cell2mat(varargin(3));
            s = cell2mat(varargin(4));
            dvbias = [1 1 1];
        case 5
            flag = cell2mat(varargin(1));
            dv = cell2mat(varargin(2));
            sig3estPercent = cell2mat(varargin(3));
            s = cell2mat(varargin(4));
            dvbias = cell2mat(varargin(5));
    end

    i = 0; j=0; k=0;
    %totalSteps = 1;

    vmag = norm(dv);
    sig3 = vmag*sig3estPercent;

    while k<=s && j<=s && i<=s
        vx = (-1 +(1+1)*randn(1,1))*sig3*dvbias(1);    
        vy = (-1 +(1+1)*randn(1,1))*sig3*dvbias(2);
        vz = (-1 +(1+1)*randn(1,1))*sig3*dvbias(3);
        vmagcalc = sqrt(vx^2 + vy^2 +vz^2);
        %totalSteps = totalSteps+1;

        if i<s
            if vmagcalc <= sig3 && vmagcalc >= (sig3/3 + sig3/3)
                i = i+1;
                R(i,1) = vx;
                R(i,2) = vy;
                R(i,3) = vz;
                R(i,4) = vmagcalc;
            end
        end
        if j<s
            if  vmagcalc <= (sig3/3 + sig3/3) && vmagcalc >= sig3/3
                j = j+1;
                R(j,5) = vx;
                R(j,6) = vy;
                R(j,7) = vz;
                R(j,8) = vmagcalc;
            end
        end
        if k<s
            if vmagcalc <= sig3/3 && vmagcalc >= 0
                k = k+1;
                R(k,9) = vx;
                R(k,10) = vy;
                R(k,11) = vz;
                R(k,12) = vmagcalc;
            end
        else
            k = s+1;
        end
    end

end