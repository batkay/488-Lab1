% Script to generate white noise, filter, then lot fft and psd

fs = 48e3; % sample frequency
sigma_x = 1; % Standard deviation of white noise
s = 1; % time in seconds
t = 0:1/fs:s-1/fs;
noise = sigma_x * randn(1, fs * s); % s seconds of white noise

% plot original signal
figure;
plot(t, noise);
grid on
title("Noise")
xlabel("Time (s)")
ylabel("Signal")

psd_plot(noise, fs);

% now filter noise
filtered = lowpass(noise,150,fs);

% plot original signal
figure;
plot(t, filtered);
grid on
title("Filtered")
xlabel("Time (s)")
ylabel("Signal")

psd_plot(filtered, fs);