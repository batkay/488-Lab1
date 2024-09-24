% [audio, fs] = audioread("audio_2/cats_chase_only_turtles_quickly.m4a");
% [audio, fs] = audioread("audio_2/cats_quickly_chase_turtles_only.m4a");
% [audio, fs] = audioread("audio_2/turtles_quickly_chase_only_cats.m4a");
% [audio, fs] = audioread("audio_2/Turtles_2.m4a");
% [audio, fs] = audioread("audio_2/mice_find_only_elk_fast.m4a");
[audio, fs] = audioread("audio_2/mice_find_only_elk_fast_2.m4a");
% [audio, fs] = audioread("audio_2/elk_find_mice_fast_only.m4a");

f_low = 200; % Lower cutoff frequency (300 Hz)
f_high = 3400; % Upper cutoff frequency (3400 Hz)

bpFilt = designfilt('bandpassiir', 'FilterOrder', 6, ...
    'HalfPowerFrequency1', f_low, 'HalfPowerFrequency2', f_high, ...
    'SampleRate', fs);

audioFiltered = filter(bpFilt, audio);

% audioFiltered = audio;
% N = length(audioFiltered);
% windowSize = 200;
% i = 1;
% while i + windowSize < N
%     if (sum(abs(audioFiltered(i:i+windowSize))) < .5)
%         audioFiltered(i:i+windowSize) = 0;
%     end
%     i = i + windowSize;
% end

% sound(audioFiltered, fs);

holds = [0.02, 0.03];

% figure;
% subplot(2, 1, 1);
% plot(1:N, audio);
% subplot(2, 1, 2);
% plot(1:N, audioFiltered);
% 
% figure;

[sigs, thresh] = detectSpeech(audioFiltered, fs, 'Window',hann(400));
detectSpeech(audioFiltered, fs, 'Window',hann(400));

for sig = sigs'
    temp = audioFiltered(sig(1):sig(2));
    temp2 = audio(sig(1):sig(2));

    [word, cVal] = classify_3(temp2);

    sound(temp2, fs);
    disp(word + " " + num2str(cVal))
end