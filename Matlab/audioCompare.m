[data1, fs1] = audioread("audio/badfeeling.wav");
[data2, fs2] = audioread("audio/badfeeling2.wav");
[data3, fs3] = audioread("audio/badfeelingbb8.wav");

[mel_def, fs_def] = audioread("audio/Melon_default.wav");
[mel_2, fs_2] = audioread("audio/Melon_2.wav");
[mel_deep, fs_deep] = audioread("audio/Melon_deep.wav");
[mel_fast, fs_fast] = audioread("audio/Melon_fast.wav");
[mel_whis, fs_whis] = audioread("audio/Melon_whisper.wav");

% size = max(length(data1), length(data2));
% data1 = paddata(data1, size);
% data2 = paddata(data2, size);

data1 = data1(:, 1);
data2 = data2(:, 1);
data3 = data3(:, 1);
mel_def = mel_def(:, 1);
mel_deep = mel_deep(:, 1);
mel_fast = mel_fast(:, 1);
mel_whis = mel_whis(:, 1);
mel_2 = mel_2(:, 1);

[c, lags] = xcorr(mel_def, mel_2, 10);

figure;
plot(lags, c);
title("Correlation Factor");
xlabel("Lag (s)");
ylabel("Correlation");


t = 0:1/fs_2:((length(mel_2)-1)/fs_2);
figure;
plot(t, mel_2);
title("Data Signal");
xlabel("Time (s)");
ylabel("Amplitude");

psd_plot(mel_2, fs_2);
spectro(mel_2, fs_2);