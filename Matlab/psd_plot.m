% Script to plot FFT and PSD of a given signal with frequency fs
% PSD code adapted from 
% https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html

function [] = psd_plot(x, fs)

N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

figure;
plot(freq, abs(xdft));
grid on
title("FFT")
xlabel("Frequency (Hz)")
ylabel("|fft(x)|")

figure;
plot(freq,pow2db(psdx))
grid on
title("Power Spectral Density")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")
end