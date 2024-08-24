% Parameters
fs = 1000;            % Sampling frequency (Hz)
t = 0:1/fs:1;         % Time vector (1 second duration)
f1 = 5;               % Frequency of the first sinusoid (Hz)
f2 = 15;              % Frequency of the second sinusoid (Hz)
A = 1;                % Amplitude of the sinusoid
clip_level = 0.8;     % Clipping level for non-linear system

% Input Signals
x1 = A * sin(2*pi*f1*t);                   % Simple sinusoid
x2 = A * (sin(2*pi*f1*t) + sin(2*pi*f2*t)); % Sum of sines

% Linear System (Output = Input)
y1_linear = x1;
y2_linear = x2;

% Non-linear System with Clipping
y1_nonlinear = min(max(x1, -clip_level), clip_level);  % Clipping the sinusoid
y2_nonlinear = min(max(x2, -clip_level), clip_level);  % Clipping the sum of sines

% Compute the Fourier Transform (spectrum)
N = length(t);  % Number of samples
f = (0:N-1)*(fs/N);  % Frequency vector

X1 = abs(fft(x1)/N);  % Spectrum of input x1
X2 = abs(fft(x2)/N);  % Spectrum of input x2
Y1_linear = abs(fft(y1_linear)/N);  % Spectrum of linear output y1
Y2_linear = abs(fft(y2_linear)/N);  % Spectrum of linear output y2
Y1_nonlinear = abs(fft(y1_nonlinear)/N);  % Spectrum of non-linear output y1
Y2_nonlinear = abs(fft(y2_nonlinear)/N);  % Spectrum of non-linear output y2

% Plotting
figure;

% Plot Linear System Responses
subplot(2,3,1);
plot(x1, y1_linear);
title('Input vs Output (Linear System)');
xlabel('Input');
ylabel('Output');
ylim([-1 1]);

subplot(2,3,2);
plot(t, y1_linear, 'r');
title('Linear System Response (Simple Sinusoid)');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Output');
ylim([-1 1]);

subplot(2,3,3);
plot(f, Y1_linear, 'r');
title('Spectrum of Linear Output (Sum of Sines)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 100]);

% Plot Linear System Responses
subplot(2,3,4);
plot(x1, y1_nonlinear);
title('Input vs Output (Non-Linear System)');
xlabel('Input');
ylabel('Output');
ylim([-1 1]);

subplot(2,3,5);
plot(t, y1_nonlinear, 'r');
title('Linear System Response (Simple Sinusoid)');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Output');
ylim([-1 1]);

subplot(2,3,6);
plot(f, Y2_nonlinear, 'r');
title('Spectrum of Linear Output (Sum of Sines)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 100]);

% Adjust layout for better visualization
sgtitle('I/O Functions, Input vs Output, and Spectrum for Linear and Non-linear Systems');
