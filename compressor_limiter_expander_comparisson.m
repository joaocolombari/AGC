% Clear workspace and close all figures
clear all;
close all;
clc;

% Parameters
fs = 1000;                % Sampling frequency (Hz)
t = 0:1/fs:1;             % Time vector (1 second duration)
f1 = 5;                   % Frequency of the sinusoid (Hz)
A = 1;                    % Amplitude of the sinusoids
clip_level = 0.316;         % Clipping level for non-linear system

% Compressor Parameters
comp_threshold = -10;     % Threshold in dBFS
comp_ratio = 2;           % Compression ratio

% Expander Parameters
exp_threshold = -10;      % Threshold in dBFS
exp_ratio = 0.5;          % Expansion ratio

% Input Signals
x1 = A * sin(2*pi*f1*t);  % Simple sinusoid

%% Non-linear Clipping
% Transfer Curve
in_levels = linspace(-1, 1, 1000);
out_levels_clip = min(max(in_levels, -clip_level), clip_level);

% Processed Signals
y1_clip = min(max(x1, -clip_level), clip_level);

% dB Conversion
in_levels_db_clip = 20*log10(abs(in_levels) + eps);  % Add eps to avoid log(0)
out_levels_db_clip = 20*log10(abs(out_levels_clip) + eps);

% Spectrum Calculation
N = length(t);
f = (0:N-1)*(fs/N);
Y1_clip = abs(fft(y1_clip)/N);

%% Compressor
% Transfer Curve
in_levels_db = linspace(-60, 0, 1000);
out_levels_db_comp = compressor_transfer(in_levels_db, comp_threshold, comp_ratio);

% Processed Signals
y1_comp = compressor_process(x1, comp_threshold, comp_ratio);

% Spectrum Calculation
Y1_comp = abs(fft(y1_comp)/N);

%% Expander
% Transfer Curve
out_levels_db_exp = expander_transfer(in_levels_db, exp_threshold, exp_ratio);

% Processed Signals
y1_exp = expander_process(x1, exp_threshold, exp_ratio);

% Spectrum Calculation
Y1_exp = abs(fft(y1_exp)/N);

%% Plotting
figure('Position', [100, 100, 1200, 900]);

% --- Non-linear Clipping Plots ---
% Transfer Curve in dB
subplot(3,2,1);
plot(in_levels_db_clip, out_levels_db_clip, 'b', 'LineWidth', 2);
title('Clipping Transfer Curve (dB)');
xlabel('Input Level (dB)');
ylabel('Output Level (dB)');
grid on;
ylim([-60 0]); xlim([-60 0]);

% Time-Domain Output
subplot(3,2,2);
plot(t, y1_clip, 'r', 'LineWidth', 1);
title('Clipping Output (Simple Sinusoid)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
ylim([-1 1]);

% --- Compressor Plots ---
% Transfer Curve
subplot(3,2,3);
plot(in_levels_db, out_levels_db_comp, 'b', 'LineWidth', 2);
title('Compressor Transfer Curve (dB)');
xlabel('Input Level (dB)');
ylabel('Output Level (dB)');
grid on;
ylim([-60 0]);

% Time-Domain Output
subplot(3,2,4);
plot(t, y1_comp, 'r', 'LineWidth', 1);
title('Compressor Output (Simple Sinusoid)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
ylim([-1 1]);

% --- Expander Plots ---
% Transfer Curve
subplot(3,2,5);
plot(in_levels_db, out_levels_db_exp, 'b', 'LineWidth', 2);
title('Expander Transfer Curve (dB)');
xlabel('Input Level (dB)');
ylabel('Output Level (dB)');
grid on;
ylim([-60 0]);

% Time-Domain Output
subplot(3,2,6);
plot(t, y1_exp, 'r', 'LineWidth', 1);
title('Expander Output (Simple Sinusoid)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
ylim([-1 1]);

sgtitle('AGC Processing: Clipping, Compression, and Expansion');

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

% Compressor Processing Function
function y_comp = compressor_process(x, threshold, ratio)
    x_db = 20*log10(abs(x) + eps); % Convert to dB, add eps to avoid log(0)
    sign_x = sign(x);              % Preserve sign
    y_db = compressor_transfer(x_db, threshold, ratio);
    y_comp = sign_x .* 10.^(y_db/20);
end

% Expander Transfer Function
function out_db = expander_transfer(in_db, threshold, ratio)
    out_db = in_db;
    for i = 1:length(in_db)
        if in_db(i) < threshold
            out_db(i) = threshold + (in_db(i) - threshold)*ratio;
        end
    end
end

% Expander Processing Function
function y_exp = expander_process(x, threshold, ratio)
    x_db = 20*log10(abs(x) + eps); % Convert to dB, add eps to avoid log(0)
    sign_x = sign(x);              % Preserve sign
    y_db = expander_transfer(x_db, threshold, ratio);
    y_exp = sign_x .* 10.^(y_db/20);
end
