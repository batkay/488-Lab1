%% test script to compare 2 audios

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

compare(mel_def, mel_whis);


% [c, lags] = xcorr(mel_def, mel_2);
% 
% figure;
% plot(lags, c);
% title("Correlation Factor");
% xlabel("Lag (s)");
% ylabel("Correlation");
% 
% 
% t = 0:1/fs_2:((length(mel_2)-1)/fs_2);
% figure;
% plot(t, mel_2);
% title("Data Signal");
% xlabel("Time (s)");
% ylabel("Amplitude");
% 
% psd_plot(mel_2, fs_2);
% 
% N_def = length(mel_def);
% def_fft = fft(mel_def);
% def_fft = def_fft(1:N_def/2+1);
% 
% N_2 = length(mel_2);
% fft_2 = fft(mel_2);
% fft_2 = fft_2(1:N_2/2+1);
% 
% N_whis = length(mel_whis);
% fft_whis = fft(mel_whis);
% fft_whis = fft_whis(1:N_whis/2+1);
% 
% 
% N1 = length(data1);
% fft1 = fft(data1);
% fft1 = fft1(1:N1/2+1);
% 
% N2 = length(data2);
% fft2 = fft(data2);
% fft2 = fft2(1:N2/2+1);
% 
% N3 = length(data3);
% fft3 = fft(data3);
% fft3 = fft3(1:N3/2+1);
% 
% up = max(length(def_fft), length(fft_whis));
% def_fft = paddata(def_fft, up);
% fft_whis = paddata(fft_whis, up);
% [c, lags] = xcorr(def_fft, fft_whis, 'normalized');
% 
% figure;
% plot(lags, abs(c));