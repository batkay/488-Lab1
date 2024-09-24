[audioIn, fs] = audioread("audio_2/only_elk_find_mice_fast.m4a");

[elk, fs_cats] = audioread("audio_2/Elk.wav");
elk = elk(:, 1);
[mice, fs_chase] = audioread("audio_2/Mice.wav");
mice = mice(:, 1);
[only, fs_only] = audioread("audio_2/Only.wav");
only = only(:, 1);
[finder, fs_quickly] = audioread("audio_2/Find.wav");
finder = finder(:, 1);
[faster, fs_turtles] = audioread("audio_2/Fast.wav");
faster = faster(:, 1);

% bpFilt = designfilt('bandpassiir', 'FilterOrder', 6, ...
%     'HalfPowerFrequency1', f_low, 'HalfPowerFrequency2', f_high, ...
%     'SampleRate', fs);
% 
% audioIn = filter(bpFilt, audioIn);

c_values = zeros(1, 5);
lag_values = zeros(1, 5);


% [c_values(1), lag_values(1)] = max(xcorr(audioIn, cats));
% [c_values(2), lag_values(2)] = max(xcorr(audioIn, chase));
% [c_values(3), lag_values(3)] = max(xcorr(audioIn, only));
% [c_values(4), lag_values(4)] = max(xcorr(audioIn, quickly));
% [c_values(5), lag_values(5)] = max(xcorr(audioIn, turtles));

[c_values(1), lag_values(1)] = compare_2(audioIn, elk);
[c_values(2), lag_values(2)] = compare_2(audioIn, mice);
[c_values(3), lag_values(3)] = compare_2(audioIn, only);
[c_values(4), lag_values(4)] = compare_2(audioIn, finder);
[c_values(5), lag_values(5)] = compare_2(audioIn, faster);

