frequencySet = [1, 10, 100, 250, 500, 1e3, 2e3, 5e3, 1e4, 2e4, 4e4];
gainSet = zeros(1, length(frequencySet));
fs = 48e3;
for i = 1:length(frequencySet)
[~, output, input] = audioLatencyMeasurementSineApp('SamplesPerFrame',64,'SampleRate',fs, 'Plot', false, 'Frequency', frequencySet(i), 'Device', 'Aggregate Device');

N = length(output);
fin = fft(input);
fin = fin(1:N/2+1);
fout = fft(output);
fout = fout(1:N/2+1);

freq = 0:fs/N:fs/2;
idx = find(freq == i);
gain = fout(idx)/fin(idx);

gainSet(i) = gain;
end

mag = 20*log10(abs(gainSet));
phase = rad2deg(angle(gainSet));

figure;
subplot(2, 1, 1)
xscale log;
plot(frequencySet', mag);
subplot(2, 1, 2)
xscale log;
plot(frequencySet', phase);