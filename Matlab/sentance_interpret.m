% [audio, fs] = audioread("audio_2/cats_chase_only_turtles_quickly.m4a");
[audio, fs] = audioread("audio_2/cats_quickly_chase_turtles_only.m4a");
% [audio, fs] = audioread("audio_2/turtles_quickly_chase_only_cats.m4a");
% [audio, fs] = audioread("audio_2/Turtles_2.m4a");

f_low = 200; % Lower cutoff frequency (300 Hz)
f_high = 3400; % Upper cutoff frequency (3400 Hz)

bpFilt = designfilt('bandpassiir', 'FilterOrder', 6, ...
    'HalfPowerFrequency1', f_low, 'HalfPowerFrequency2', f_high, ...
    'SampleRate', fs);

audioFiltered = filter(bpFilt, audio);
sound(audioFiltered, fs);

holds = [0.02, 0.03];

% [sigs, thresh] = detectSpeech(audioFiltered, fs, 'Window',hann(1500));

for sig = sigs'
    temp = audioFiltered(sig(1):sig(2));
    [word, cVal] = classify_2(temp);

    disp(word + " " + num2str(cVal))
end