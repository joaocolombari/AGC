% Clear workspace and close all figures
clear all;
close all;
clc;

% Parameters
fs = 10000;                % Sampling frequency (Hz)
t = 0:1/fs:6;             % Time vector (3 seconds duration)
f1 = 44;                  % Frequency of the sinusoid (Hz)
f2 = 110;                 % Frequency of the second sinusoid (Hz)
A_below = 0.2;            % Amplitude below threshold
A_above = 1;              % Amplitude above threshold
comp_threshold = -10;     % Threshold in dBFS
comp_ratio = 2;           % Compression ratio
attack_time = 0.1;        % Attack time (seconds)
release_time = 0.2;       % Release time (seconds)

% Input Signal
% Sinusoidal input with varying amplitude for the first sine wave
t1 = t(t <= 1); % First 1 second below threshold
t2 = t(t > 1 & t <= 2); % Next 1 second above threshold
t3 = t(t > 2 & t <= 3); % Last 1 second below threshold
t4 = t(t > 3 & t <= 4); % Last 1 second below threshold
t5 = t(t > 4 & t <= 5); % Last 1 second below threshold
t6 = t(t > 5); % Last 1 second below threshold

x1 = [A_below * sin(2*pi*f1*t1) ...
      A_above * sin(2*pi*f1*t2) ...
      A_below * sin(2*pi*f1*t3) ...
      A_below * sin(2*pi*f2*t4) ...
      A_above * sin(2*pi*f2*t5) ...
      A_below * sin(2*pi*f2*t6)];

% Simulink parameters 
signal.time = t';
signal.signals.values = x1';
signal.signals.dimensions = 1;

% Filter coef design
fc = 80;
% For low pass
[b, a] = butter(8, fc/(fs/2), "low"); % num, den
% For high pass
[d, c] = butter(8, fc/(fs/2), "high");

% Compressor Processing with Attack and Release
y1_comp = zeros(size(x1));
for i = 1:length(x1)
    y1_comp(i) = compressor_AGC(x1(i), comp_threshold, comp_ratio, fs, attack_time, release_time);
end

% Plotting
figure('Position', [100, 100, 1200, 900]);

% --- Compressor Transfer Curve ---
% Transfer Curve
in_levels_db = linspace(-60, 0, 1000);
out_levels_db_comp = compressor_transfer(in_levels_db, comp_threshold, comp_ratio);

subplot(2,1,1);
plot(in_levels_db, out_levels_db_comp, 'b', 'LineWidth', 2);
title('Compressor Transfer Curve (dB)');
xlabel('Input Level (dB)');
ylabel('Output Level (dB)');
grid on;
ylim([-60 0]);

% --- Compressor Output Signal ---
subplot(2,1,2);
plot(t, x1, 'Color', [0.2 0.2 0.2 0.3], 'LineWidth', 1); % Original signal (dashed line)
hold on;
plot(t, y1_comp, 'r', 'LineWidth', 1); % Compressed signal (solid line)
title('Compressor Output with Attack and Release Times');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal', 'Compressed Signal');
grid on;
ylim([-1 1]);

sgtitle('Compressor with Attack and Release Times');
