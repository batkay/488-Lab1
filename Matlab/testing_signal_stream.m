[mel_def, fs_def] = audioread("audio/Melon_default.wav");
[mel_h, fs_h] = audioread("audio/Melon_deep.wav");
[bad_def, fs_bad] = audioread("audio/badfeeling.wav");
[mel_AQ, fs_AQ] = audioread("word_melon.wav"); %recorded melon just repeat one time
[amb,fs_amb] = audioread("ambient_noise.wav");
% 
[~,PSD_AQ] = psd_plot.psd_calculation(mel_AQ, fs_AQ);
[~,PSD_amb] = psd_plot.psd_calculation(amb,fs_amb);
[~,PSD_def] = psd_plot.psd_calculation(mel_def, fs_def);
sum(PSD_amb)
sum(PSD_AQ)
sum(PSD_def)

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
computeROC("ambient_noise.wav","audio/Melon_default.wav");
%% Functions
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
    Y_raw = fft(x);
    Z_raw = fft(x1);
    Y_len = length(Y_raw);
    Z_len = length(Z_raw);
    Y = Y_raw(1:Y_len/2+1);
    Z = Z_raw(1:Z_len/2+1);
    % Creating the figure with subplots
    figure
    subplot(3,1,1);
    plot(tt1, x);
    hold on;
    plot(tt2, x1);

    title("Audio Waveform");
    xlabel("Time (seconds)");
    ylabel("Amplitude");
    legend("Audio 1","Audio 2")
    hold off;
    subplot(3,1,2);
    plot(0:Fs/Y_len:Fs/2,Y);
    hold on
    plot(0:Fs1/Z_len:Fs1/2,Z);
    title("Audio FFT");
    xlabel("Freqency (Hz)");
    ylabel("Amplitude");
    legend("Audio 1","Audio 2")

    hold off;
    % Cross-correlation of the magnitude of the frequency spectrums
    [C1, lag1] = xcorr(abs(Y), abs(Z));
    subplot(3,1,3);
    plot(lag1/Fs, C1);
    title("Cross-Correlation of Audio Spectra");
    xlabel("Lag (seconds)");
    ylabel("Correlation coefficient");
end

function [FPR, TPR, thresholds] = computeROC(inputArg1, inputArg2)
    [x, Fs] = audioread(inputArg1);
    [x1, Fs1] = audioread(inputArg2);
    
    if size(x, 2) == 2
        x = mean(x, 2);
    end
    if size(x1, 2) == 2
        x1 = mean(x1, 2);
    end

    % Compute the FFT of both signals
    Y = fft(x);
    Z = fft(x1);
    Y = Y(1:floor(end/2)+1);
    Z = Z(1:floor(end/2)+1);
    
    [c, lags] = xcorr(abs(Y), abs(Z));
    
    peak_corr = max(abs(c));

    % Generate a range of thresholds from minimum to maximum correlation observed
    thresholds = linspace(min(abs(c)), max(abs(c)), 100);
    TPR = zeros(1, length(thresholds));
    FPR = zeros(1, length(thresholds));

    % Calculate TPR and FPR for each threshold
    for i = 1:length(thresholds)
        % True Positive: Correlation above threshold (assuming peak_corr is the true positive)
        TPR(i) = sum(abs(c) >= thresholds(i)) / length(c);
        
        % False Positive: Correlation below threshold (assuming zero correlation is the true negative)
        FPR(i) = sum(abs(c) < thresholds(i)) / length(c);
    end

    % Plot the ROC curve
    figure;
    plot(FPR, TPR, 'LineWidth', 2);
    title('ROC Curve for Audio Correlation');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    grid on;
end
