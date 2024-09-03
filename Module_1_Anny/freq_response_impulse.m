
clear all;
close all;
clc;
%% Setup
fs = 48e3; 
duration = 5;
samplesPerFrame = 32; 
adr = audioDeviceReader('Device','Aggregate Device','SampleRate', fs, 'SamplesPerFrame', samplesPerFrame);

t = 0:1/fs:duration-1/fs; % Time vector

% impulse train
impulse_freq = 500;
impulse_train = zeros(size(t)); 
period_samples = fs / impulse_freq; 
impulse_train(1:period_samples:length(t)) = 1;
plot(t,impulse_train)
sound(impulse_train, fs);

% Store the recorded audio
numFrames = floor(duration * fs / samplesPerFrame);
ambient_noise = zeros(numFrames * samplesPerFrame, 1);

% Record ambient noise
disp('Recording ambient noise...');
for i = 1:numFrames
    audioFrame = adr(); % Read a frame of audio samples
    ambient_noise((i-1)*samplesPerFrame + 1 : i*samplesPerFrame) = audioFrame;
end

disp('Finished recording ambient noise.');
release(adr);

% Plot the recorded ambient noise
t = (0:length(ambient_noise)-1) / fs; % Time vector
figure;
plot(t, ambient_noise);
xlabel('Time (s)');
ylabel('Amplitude');
title('Ambient Noise Recording');
grid on;
%% FFT

Y_amb = fft(ambient_noise);
N = length(Y_amb);
Y_amb = Y_amb(1:N/2+1);
% Compute the frequency vector 
f = 0:fs/N:fs/2; % Frequency vector

%%  Plot frequency response
figure;
plot(f, abs(Y_amb));
title('Frequency Response - Ambient');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 fs/2]); % Limit x-axis to Nyquist frequency
grid on;

%% 

psdx = (1/(fs*length(Y_amb))) * abs(Y_amb).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
figure;
plot(f,pow2db(psdx))
grid on
title("Power Spectral Density")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")

