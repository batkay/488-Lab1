frequencySet = [1, 5, 10, 20, 50, 75, 100, 250, 500, 1e3, 2e3, 5e3, 7e3, 1e4, 1.5e4, 2e4];
% frequencySet = [2e3];
gainSet = zeros(1, length(frequencySet));
fs = 48e3;
for i = 1:length(frequencySet)
[~, input, output] = audioLatencyMeasurementSineApp('SamplesPerFrame',64,'SampleRate',fs, 'Plot', false, 'Frequency', frequencySet(i), 'Device', 'Aggregate Device');

N = length(output);
fin = fft(input);
fin = fin(1:N/2+1);
fout = fft(output);
fout = fout(1:N/2+1);

freq = 0:fs/N:fs/2;
idx = find(freq == frequencySet(i));
gain = fout(idx)/fin(idx);

gainSet(i) = gain;
end

mag = 20*log10(abs(gainSet));
phase = rad2deg(angle(gainSet));

figure;
subplot(2, 1, 1)
plot(frequencySet', mag);
xscale log;
title("Amplitude vs Frequency");
xlabel("Frequency (Hz)");
ylabel("Gain (dB)");

subplot(2, 1, 2)
plot(frequencySet', phase);
xscale log;
title("Phase vs Frequency");
xlabel("Frequency (Hz)");
ylabel("Phase (degrees)");