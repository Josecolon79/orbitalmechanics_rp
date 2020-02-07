%% Europa Clipper Dev1
% C: 25NOV19

clear; close all; clc; format long g; firstload = 1;

%% Initialize Local Orbital Mechanics Source Files
if firstload == 1
    addpath('/Users/rohanpatel/dev/dev_orbitalmechanics');
    spk = dev_OM_loaddirs;

    cd = '/Users/rohanpatel/dev/dev_orbitalmechanics/src_common/pkchp_plotter';
    addpath(cd);
    addpath(genpath(cd));
end

%% Kernals Initialization
cspice_kclear;
load('spk.mat')
nf009 = [spk,'/naif0009.tls'];
de438 = [spk,'/de438.bsp'];
euclip = [spk,'/17F12_DIR_L220604_A241223_V2_scpse.bsp'];
cspice_furnsh({de438,nf009,euclip})

[ctr_bdy] = mice_bodc2n(5);

euclip = '-159';
E01_flyby = cspice_str2et({'May 08 21:08:00 UTC 2026'});
sc1 = mice_spkezr(euclip, E01_flyby, 'J2000', 'NONE', ctr_bdy.name );
