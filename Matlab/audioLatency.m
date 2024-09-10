% Script to do loopback test with different signals ie drum, sine, chrip,
% square
% 'Aggregate Device'
% audioLatencyMeasurementDrumApp('SamplesPerFrame',64,'SampleRate',48e3, 'Plot', true, 'Device', 'Default')
[t, ~, ~] = audioLatencyMeasurementSineApp('SamplesPerFrame',64,'SampleRate',48e3, 'Plot', true, 'Frequency', 10000, 'Device', 'Aggregate Device');
disp(t)
% audioLatencyMeasurementChirpApp('SamplesPerFrame',64,'SampleRate',48e3, 'Plot', true, 'Device', 'Default')
% audioLatencyMeasurementSquareApp('SamplesPerFrame',64,'SampleRate',48e3, 'Plot', true, 'Device', 'Default')
