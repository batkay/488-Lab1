[melon, fs_melon] = audioread("audio/Melon_default.wav");
melon = melon(:, 1);
[vader, fs_vader] = audioread("audio/Vader.wav");
vader = vader(:, 1);
[bat, fs_bat] = audioread("audio/Bat.wav");
bat = bat(:, 1);
[drink, fs_drink] = audioread("audio/Drink.wav");
drink = drink(:, 1);
[wash, fs_wash] = audioread("audio/Wash.wav");
wash = wash(:, 1);
figure
subplot(5,1,1);
spectro(melon, fs_melon);
title('Melon Audio');

subplot(5,1,2);
spectro(vader, fs_vader);
title('Vader Audio');

subplot(5,1,3);
spectro(bat, fs_bat);
title('Bat Audio');

subplot(5,1,4);
spectro(drink, fs_drink);
title('Drink Audio');

subplot(5,1,5);
spectro(wash, fs_wash);
title('Wash Audio');
fs = 48e03;

[bad,bad_Fs]= audioread("audio/Sentence.wav");
bad = bad(:,1);
figure;
spectro(bad,bad_Fs);
f_low = 300; % Lower cutoff frequency (300 Hz)
f_high = 3400; % Upper cutoff frequency (3400 Hz)
bpFilt = designfilt('bandpassiir', 'FilterOrder', 6, ...
    'HalfPowerFrequency1', f_low, 'HalfPowerFrequency2', f_high, ...
    'SampleRate', fs);

y = filter(bpFilt, bad(:,1));
disp(snr(y,fs));

figure;
window_size= 600;
% win = hamming(window_size,'periodic');
% percentOverlap = 50;
% overlap = round(window_size*percentOverlap/100);
% mergeDuration = 0.44;
% mergeDist = round(mergeDuration*fs);
% % detectSpeech(y,fs,"Window",win,"OverlapLength",overlap,"MergeDistance",mergeDist,"Thresholds",[6.5 0])

[idx,thresholds] =detectSpeech(y,fs,"Window",hamming(window_size,'periodic'));

% Loop through each detected speech segment and play it
for i = 1:size(idx, 1)
    segmentStart = idx(i, 1);
    segmentEnd = idx(i, 2);
    speechSegment = y(segmentStart:segmentEnd);  % Extract the segment
    sound(speechSegment, fs);  % Play the segment
    pause(length(speechSegment)/fs + 0.5);  % Pause to allow the segment to finish plus a little extra time before the next
end

detectSpeech(y,fs,"Window",hamming(window_size,'periodic'));