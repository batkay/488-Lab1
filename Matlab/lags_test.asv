[audioIn, fs] = audioread("audio_2/cats_quickly_chase_turtles_only.m4a");

[cats, fs_cats] = audioread("audio_2/Cats.wav");
cats = cats(:, 1);
[chase, fs_chase] = audioread("audio_2/Chase.wav");
chase = chase(:, 1);
[only, fs_only] = audioread("audio_2/Only.wav");
only = only(:, 1);
[quickly, fs_quickly] = audioread("audio_2/Quickly.wav");
quickly = quickly(:, 1);
[turtles, fs_turtles] = audioread("audio_2/Turtles.wav");
turtles = turtles(:, 1);

bpFilt = designfilt('bandpassiir', 'FilterOrder', 6, ...
    'HalfPowerFrequency1', f_low, 'HalfPowerFrequency2', f_high, ...
    'SampleRate', fs);

audioIn = filter(bpFilt, audioIn);

c_values = zeros(1, 5);
lag_values = zeros(1, 5);


% [c_values(1), lag_values(1)] = max(xcorr(audioIn, cats));
% [c_values(2), lag_values(2)] = max(xcorr(audioIn, chase));
% [c_values(3), lag_values(3)] = max(xcorr(audioIn, only));
% [c_values(4), lag_values(4)] = max(xcorr(audioIn, quickly));
% [c_values(5), lag_values(5)] = max(xcorr(audioIn, turtles));

[c_values(1), lag_values(1)] = compare_2(audioIn, cats);
[c_values(2), lag_values(2)] = compare_2(audioIn, chase);
[c_values(3), lag_values(3)] = compare_2(audioIn, only);
[c_values(4), lag_values(4)] = compare_2(audioIn, quickly);
[c_values(5), lag_values(5)] = compare_2(audioIn, turtles);

