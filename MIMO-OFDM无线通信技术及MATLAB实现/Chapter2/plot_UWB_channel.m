% plot_UWB_channel.m
clear; close all; clc;
no_output_files = 1;  % non-zero: avoids writing output files of continuous-time responses
Ts = 0.167;        % sampling time (nsec)
num_ch=100; % number of channel impulse responses to generate
rng(12);  % initialize state of function for repeatability
channel_model = 1;  % channel model number from 1 to 4
% get channel model params based on this channel model number
[Lam,lam,Gam,gam,nlos,sdi,sdc,sdr] = UWB_parameters(channel_model);
fprintf(['Model Parameters:\n','\t Lam= %.4f, lam= %.4f, Gam= %.4f, gam= %.4f\n\t NLOS flag= %d, std_shdw= %.4f, std_ln_1= %.4f, std_ln_2= %.4f\n'],...
 Lam,lam,Gam,gam,nlos,sdi,sdc,sdr);
% get a bunch of realizations (impulse responses)
[h_ct,t_ct,t0,np] = UWB_model_ct(Lam,lam,Gam,gam,num_ch,nlos,sdi,sdc,sdr);
% now reduce continuous-time result to a discrete-time result
[hN,N] = convert_UWB_ct(h_ct,t_ct,np,num_ch,Ts);
% if we wanted complex baseband model or to impose some filtering function,
% this would be a good place to do it
h = resample(hN,1,N);  % decimate the columns of hN by factor N
h = h*N;  % correct for 1/N scaling imposed by decimation
channel_energy = sum(abs(h).^2);  % channel energy
h_len = size(h,1);
t = (0:(h_len-1))*Ts;  % for use in computing excess & RMS delays
excess_delay = zeros(1,num_ch);
rms_delay = zeros(1,num_ch);
num_sig_paths = zeros(1,num_ch);
num_sig_e_paths = zeros(1,num_ch);
for k=1:num_ch
  % determine excess delay and RMS delay
  sq_h = abs(h(:,k)).^2/channel_energy(k);
  t_norm = t - t0(k);  % remove the randomized arrival time of first cluster
  excess_delay(k) = t_norm*sq_h;
  rms_delay(k) = sqrt((t_norm-excess_delay(k)).^2*sq_h);
  % determine # of significant paths (paths within 10 dB from peak)
  threshold_dB = -10;   % dB
  temp_h = abs(h(:,k));
  temp_thresh = 10^(threshold_dB/20)*max(temp_h);
  num_sig_paths(k) = sum(temp_h>temp_thresh);
  % determine number of sig. paths (captures x % of energy in channel)
  temp_sort = sort(temp_h.^2);  % sorted in ascending order of energy
  cum_energy = cumsum(temp_sort(end:-1:1));  % cumulative energy
  x = 0.85;
  index_e = min(find(cum_energy >= x*cum_energy(end)));
  num_sig_e_paths(k) = index_e;
end
energy_mean = mean(10*log10(channel_energy));
energy_stddev = std(10*log10(channel_energy));
mean_excess_delay = mean(excess_delay);
mean_rms_delay = mean(rms_delay);
mean_sig_paths = mean(num_sig_paths);
mean_sig_e_paths = mean(num_sig_e_paths);
temp_average_power = sum(h'.*(h)')/num_ch;
temp_average_power = temp_average_power/max(temp_average_power);
average_decay_profile_dB = 10*log10(temp_average_power);
 
fprintf('Model Characteristics:\n');
fprintf('\t Mean delays: excess (tau_m) = %.1f ns, RMS (tau_rms) = %1.f\n', ...
    mean_excess_delay, mean_rms_delay);
fprintf('\t # paths: NP_10dB =  %.1f, NP_85%% = %.1f\n', ...
    mean_sig_paths, mean_sig_e_paths);
fprintf('\t Channel energy: mean = %.1f dB, std deviation = %.1f dB\n', ...
  energy_mean, energy_stddev);

figure
subplot(211)
plot(t,h), grid on
title('Impulse response realizations')
xlabel('Time (ns)') 
subplot(212)
plot(1:num_ch, excess_delay, 'b-', ...
  [1 num_ch], mean_excess_delay*[1 1], 'r-' );
grid on, title('Excess delay (ns)')
xlabel('Channel number')
figure
subplot(211)
plot(1:num_ch, rms_delay, 'b-', ...
  [1 num_ch], mean_rms_delay*[1 1], 'r-' );
grid on, title('RMS delay (ns)'), xlabel('Channel number')
subplot(212)
plot(1:num_ch, num_sig_paths, 'b-', ...
  [1 num_ch], mean_sig_paths*[1 1], 'r-');
grid on, title('Number of significant paths within 10 dB of peak')
xlabel('Channel number')
figure
subplot(211)
plot(1:num_ch, num_sig_e_paths, 'b-', ...
  [1 num_ch], mean_sig_e_paths*[1 1], 'r-');
grid on, title('Number of significant paths capturing > 85% energy')
xlabel('Channel number')
subplot(212)
plot(t,average_decay_profile_dB); grid on
axis([0 t(end) -60 0]), title('Average Power Decay Profile')
xlabel('Delay (nsec)'), ylabel('Average power (dB)')
figure
hold on;
plot(1:num_ch,10*log10(channel_energy),'b-')
plot([1 num_ch], energy_mean*[1 1], 'g-')
plot([1 num_ch], energy_mean+energy_stddev*[1 1], 'r:')
plot([1 num_ch], energy_mean-energy_stddev*[1 1], 'r:')
xlabel('Channel number'), ylabel('dB'), title('Channel Energy');
legend('Per-channel energy', 'Mean', '\pm Std. deviation', 'Location','best')