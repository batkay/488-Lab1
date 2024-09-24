function[spec] = spectro(x, fs, windowSize, overlap, fftLen, windowType)
arguments
    x;
    fs;
    windowSize = 1000; % number of samples per window
    overlap = 0; % number of samples from previous window to use
    fftLen = windowSize; % how many samples to use in fft
    windowType = @hann; % windowing function
end
N = length(x);
i = 1;

times = [];
windows = [];

freq = 0:fs/fftLen:fs/2;


while i + windowSize < N
    hanningWindow = windowType(windowSize);
    sig = x(i:i+windowSize - 1, :) .* hanningWindow;
    tempFft = fft(sig, fftLen)/fftLen;
    tempFft = tempFft(1:fftLen/2+1);
    tempFft = 20*log10(abs(tempFft) ./ freq');

    time = i * 1/fs;

    times = [times; time];
    windows = [windows; tempFft'];

    % increment
    i = i + windowSize - overlap;
end

% figure;
imagesc(times, freq, windows', 'CDataMapping','scaled');
colormap('jet');
axis('xy');
colorbar;
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title("Spectrogram");

spec = windows';

end