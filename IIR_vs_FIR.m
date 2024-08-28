% Clear workspace and close all figures
clear all;
close all;
clc;

% Load FIR coefficients from FIR.mat
load('FIR.mat'); % Assuming 'Num_low' and 'Num_high' are the variable names in the .mat file

% Sampling frequency
fs = 10000; 

% IIR Filter Design (Butterworth)
fc = 80; % Cutoff frequency
order = 8; % Filter order

% IIR low-pass filter
[b_iir, a_iir] = butter(order, fc/(fs/2), 'low');

% FIR Filter Design
% FIR with the same number of coefficients as IIR (order+1 coefficients)
fir_same_coeffs = Num_low;

% FIR with a similar response (imported from FIR.mat)
fir_similar_response = Num_high;

% Plotting IIR Filter frequency response
figure('Position', [100, 100, 1200, 900]);
freqz(b_iir, a_iir, 1024, fs);
set(subplot(2,1,1), 'XLim',[0 500]);
set(subplot(2,1,2), 'XLim',[0 500]);
grid on;

% Plotting FIR Filter with the same number of coefficients as IIR
figure('Position', [100, 100, 1200, 900]);
freqz(fir_same_coeffs, 1, 1024, fs);
set(subplot(2,1,1), 'XLim',[0 500]);
set(subplot(2,1,2), 'XLim',[0 500]);
grid on;

% Plotting FIR Filter with similar response to IIR
figure('Position', [100, 100, 1200, 900]);
freqz(fir_similar_response, 1, 1024, fs);
set(subplot(2,1,1), 'XLim',[0 500]);
set(subplot(2,1,2), 'XLim',[0 500]);
grid on;
