function[spec] = spectro(x, fs, windowSize, overlap, fftLen)
arguments
    x;
    fs;
    windowSize = 1000; % number of samples per window
    overlap = 0;
    fftLen = windowSize;
end
N = length(x);
i = 1;

times = [];
windows = [];

freq = 0:fs/fftLen:fs/2;


while i + windowSize < N
    hanningWindow = hann(windowSize);
    sig = x(i:i+windowSize - 1, :) .* hanningWindow;
    tempFft = fft(sig, fftLen)/fftLen;
    tempFft = tempFft(1:fftLen/2+1);
    

    time = i * fs;

    times = [times; time];
    windows = [windows; tempFft'];

    % increment
    i = i + windowSize - overlap;
end

figure;
imagesc(times, freq, abs(windows'), 'CDataMapping','scaled');
colormap('jet');
axis('xy');
colorbar;

figure;
plot(freq, abs(tempFft));

spec = windows';

end