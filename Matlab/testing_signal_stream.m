% [mel_def, fs_def] = audioread("audio/Melon_default.wav");
% [mel_AQ, fs_AQ] = audioread("word_melon.wav"); %recorded melon just repeat one time
% [amb,fs_amb] = audioread("ambient_noise.wav");
% 
% [~,PSD_AQ] = psd_plot.psd_calculation(mel_AQ, fs_AQ);
% [~,PSD_amb] = psd_plot.psd_calculation(amb,fs_amb);
% [~,PSD_def] = psd_plot.psd_calculation(mel_def, fs_def);
% sum(PSD_amb)
% sum(PSD_AQ)
% sum(PSD_def)
% 
% [c, lags] = xcorr(mel_def, mel_AQ, 10);
% 
% 
% 
% figure;
% plot(lags, c);
% title("Correlation Factor");
% xlabel("Lag (s)");
% ylabel("Correlation");
% 

% psd_plot(mel_AQ, fs_AQ);
% psd_plot(mel_def, fs_def);
% spectro(mel_AQ,fs_AQ)
% spectro(mel_def, fs_def);

compare("ambient_noise.wav","audio/Melon_default.wav")


 function [] = compare(inputArg2,inputArg1)    
    [x, Fs] = audioread(inputArg1);
    [x1,Fs1] = audioread(inputArg2);
    x=x';
    x=x(1,:);
    x=x';
    x1=x1';
    x1=x1(1,:);
    x1=x1';
    tt1 = (0:length(x)-1)/Fs;
    tt2 = (0:length(x1)-1)/Fs1;
    Y = fft(x);
    Z = fft(x1);
    figure
    subplot(3,1,1), plot(tt1,x);
    subplot(3,1,2), plot(tt2,x1);
    [C1,lag1] = xcorr(abs(Y),abs(Z) );
    subplot(3,1,3), plot(lag1/Fs,C1);
end
