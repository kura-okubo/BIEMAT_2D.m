% main script to run TPV3 2D model
clear all;
addpath("../../code");

%% Input parameters
prm.pname = "ex_modeIII";
prm.fs=0.6;
prm.fd=0.4;
prm.Dc=0.4; % originally this is 0.4m
prm.Tu=12e6; % critical stress threshold used in Tada and Madariaga (2001)

prm.sn=20e6;
prm.tau0=6e6;
prm.tau_nuc=15e6;

prm.mu=30e9;
prm.cs=3000;
prm.L = 30e3;
prm.Lc= 2e3;
prm.ds=150;
prm.T=1.3;
prm.dt=0.02;
prm.et=0.5;

%% Nucleation length From Uenishi and Rice 2003
W = ((prm.fs-prm.fd)/prm.Dc)*prm.sn;
prm.hr = 1.158*prm.mu/W;
fprintf("Nucleation length: %4.2f [km]\n", prm.hr/1e3);
%% Run simulation

A = biemat_2d(prm);

%% Save data
if ~exist("OUTPUT", "dir"); mkdir("OUTPUT"); end
save(sprintf("OUTPUT/data_%s.mat", prm.pname));
