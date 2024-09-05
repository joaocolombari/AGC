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
% Load FIR coefficients from FIR.mat
load('FIR_one_channel_realistic.mat'); % Assuming 'Num_low' and 'Num_high' are the variable names in the .mat file

% FIR Filter Design
% FIR with the same number of coefficients as IIR (order+1 coefficients)
fir_low = Num_low;

% FIR with a similar response (imported from FIR.mat)
fir_high = Num_high;

% Dummy gain
Av_scene = 1;

