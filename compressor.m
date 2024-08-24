% Clear workspace and close all figures
clear all;
close all;
clc;

% Parameters
fs = 1000;                % Sampling frequency (Hz)
t = 0:1/fs:3;             % Time vector (3 seconds duration)
f1 = 44;                   % Frequency of the sinusoid (Hz)
A_below = 0.2;            % Amplitude below threshold
A_above = 1;              % Amplitude above threshold
comp_threshold = -10;     % Threshold in dBFS
comp_ratio = 2;           % Compression ratio
attack_time = 0.1;       % Attack time (seconds)
release_time = 0.2;       % Release time (seconds)

% Input Signal
% Sinusoidal input with varying amplitude
t1 = t(t <= 1); % First 1 second below threshold
t2 = t(t > 1 & t <= 2); % Next 1 second above threshold
t3 = t(t > 2); % Last 1 second below threshold

x1 = [A_below * sin(2*pi*f1*t1) ...
      A_above * sin(2*pi*f1*t2) ...
      A_below * sin(2*pi*f1*t3)];

% Compressor Processing with Attack and Release
y1_comp = compressor_with_dynamics(x1, comp_threshold, comp_ratio, fs, attack_time, release_time);

% Spectrum Calculation
N = length(t);
f = (0:N-1)*(fs/N);
Y1_comp = abs(fft(y1_comp)/N);

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

%% Supporting Functions

% Compressor Transfer Function
function out_db = compressor_transfer(in_db, threshold, ratio)
    out_db = in_db;
    for i = 1:length(in_db)
        if in_db(i) > threshold
            out_db(i) = threshold + (in_db(i) - threshold)/ratio;
        end
    end
end

% Compressor Processing Function with Attack and Release Times
function y_comp = compressor_with_dynamics(x, threshold, ratio, fs, attack_time, release_time)
    % Convert attack and release times to sample counts
    attack_samples = round(attack_time * fs);
    release_samples = round(release_time * fs);

    % Initialize output
    y_comp = zeros(size(x));
    gain = 1;  % Initial gain
    
    % Process signal sample by sample
    for n = 1:length(x)
        % Compute current gain based on input level
        x_db = 20*log10(abs(x(n)) + eps); % Convert to dB, add eps to avoid log(0)
        if x_db > threshold
            target_gain = 10^((compressor_transfer(x_db, threshold, ratio) - x_db)/20);
            % Attack phase
            gain = gain + (target_gain - gain) / attack_samples;
        else
            % Release phase
            gain = gain - (gain - 1) / release_samples;
        end
        % Apply gain to the signal
        y_comp(n) = x(n) * gain;
    end
end
