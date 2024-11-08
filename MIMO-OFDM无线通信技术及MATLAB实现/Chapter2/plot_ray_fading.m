clear; close all; clc
rng(0)
fc= 9e8;           % carrier frequency[Hz]
fs=5e4;            % sampling frequency[MHz]
speed_kmh=120;     % moving table speed[km/h]
Ts=1/fs;           % smpling time[s]
v_ms= speed_kmh/3.6;  % velocity[m/s]
wl_m= 3e8/fc;      % wavelength[m]
% channel parameters setting: SCM case 2
PDP_dB=[0. -1. -9. -10. -15. -20];
t_ns=[0 310 710 1090 1730 2510];
BS_theta_LOS_deg=0;
MS_theta_LOS_deg=0;
BS_AS_deg=2;                        % Laplacian PAS
BS_AoD_deg=50*ones(size(PDP_dB));
MS_AS_deg=35;                   % for Lapalcian PAS
DoT_deg=22.5;
MS_AoA_deg=67.5*ones(size(PDP_dB));
% generates phase of a subray
[BS_theta_deg,MS_theta_deg,BS_PHI_rad]=gen_phase(BS_theta_LOS_deg,BS_AS_deg,BS_AoD_deg,MS_theta_LOS_deg,MS_AS_deg,MS_AoA_deg);
PDP=dB2w(PDP_dB);
% generates coefficients
t=(0:1e4-1)*Ts;
h= ray_fading(20,PDP,BS_PHI_rad,MS_theta_deg,v_ms,DoT_deg,wl_m,t);
plot(t,10*log10(abs(h(1,:))))
title(['Ray Channel Model, f_c=',num2str(fc),'Hz, T_s=',num2str(Ts),'s']);
xlabel('time[s]'), ylabel('Magnitude[dB]')