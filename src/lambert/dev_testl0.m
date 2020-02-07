%% Lambert Arc Calculation Method
% C: 31DEC19

clear; close all; clc; format long g;

%% Kernals Initialization
% CSPICE MICE integration 
cspice_kclear;
nf009 = [pwd,filesep,fullfile('src','SPKs','naif0009.tls')];
de438 = [pwd,filesep,fullfile('src','SPKs','de438.bsp')];
cspice_furnsh({de438,nf009})

%% Inputs
% Bodies
depbdy = '3';
arrbdy = '4';   
[ctr_bdy] = mice_bodc2n(0);
mu = 1.32712*10^11;

% Days and Bounds
et = cspice_str2et( {'Jan 01, 2000', 'Oct 02, 2001'} );

%% <<<Lambert Calculation>>>
% cspice_etcal(number) <-- conv to UTC date/time
pb1 = mice_spkezr(depbdy, et(1), 'J2000', 'NONE', ctr_bdy.name );
pb2 = mice_spkezr(arrbdy, et(2), 'J2000', 'NONE', ctr_bdy.name );
tof = et(2) - et(1);
l1result = l0(1,pb1.state,pb2.state,tof,mu)
