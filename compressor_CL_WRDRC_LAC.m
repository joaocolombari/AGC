% Clear workspace and close all figures
clear all;
close all;
clc;

% Parameters for plotting
input_levels_db = 0:0.1:120;  % Input levels in dB SPL

% Compression Limiting Compressor Parameters
threshold_limiting = 90;   % Threshold for limiting (dB SPL)
ratio_limiting = 10;       % High ratio for limiting

% WDRC Compressor Parameters
threshold_wdrc = 50;       % Threshold for WDRC (dB SPL)
ratio_wdrc = 3;            % WDRC compression ratio

% LAC (Low Amplitude Compressor) Parameters
threshold_lac_1 = 30;      % First knee point threshold (dB SPL)
threshold_lac_2 = 100;     % Second knee point threshold (dB SPL)
ratio_lac_1 = 3;         % Compression ratio below 100 dB SPL
ratio_lac_2 = 1;          % Compression ratio above 100 dB SPL

% --- Compression Limiting Compressor ---
out_levels_limiting = compressor_transfer(input_levels_db, threshold_limiting, ratio_limiting);

% --- WDRC Compressor ---
out_levels_wdrc = compressor_transfer(input_levels_db, threshold_wdrc, ratio_wdrc);

% --- LAC Compressor ---
out_levels_lac = input_levels_db;
for i = 1:length(input_levels_db)
    if input_levels_db(i) > threshold_lac_2
        % Apply the second compression stage after the first one
        out_levels_lac(i) = out_levels_lac(find(input_levels_db <= threshold_lac_2, 1, 'last')) + (input_levels_db(i) - threshold_lac_2) / ratio_lac_2;
    elseif input_levels_db(i) > threshold_lac_1
        % Apply the first compression stage
        out_levels_lac(i) = threshold_lac_1 + (input_levels_db(i) - threshold_lac_1) / ratio_lac_1;
    end
end

% Plotting
figure('Position', [100, 100, 1200, 900]);

% --- Compression Limiting Compressor Plot ---
subplot(3,1,1);
plot(input_levels_db, out_levels_limiting, 'r', 'LineWidth', 2);
title('Compression Limiting Compressor Transfer Curve');
xlabel('Input Level (dB SPL)');
ylabel('Output Level (dB SPL)');
grid on;
ylim([0 120]);

% --- WDRC Compressor Plot ---
subplot(3,1,2);
plot(input_levels_db, out_levels_wdrc, 'g', 'LineWidth', 2);
title('WDRC Compressor Transfer Curve');
xlabel('Input Level (dB SPL)');
ylabel('Output Level (dB SPL)');
grid on;
ylim([0 120]);

% --- LAC Compressor Plot ---
subplot(3,1,3);
plot(input_levels_db, out_levels_lac, 'b', 'LineWidth', 2);
title('LAC Compressor Transfer Curve with Two Knee Points');
xlabel('Input Level (dB SPL)');
ylabel('Output Level (dB SPL)');
grid on;
ylim([0 120]);

sgtitle('Compressor Transfer Curves in dB SPL');
