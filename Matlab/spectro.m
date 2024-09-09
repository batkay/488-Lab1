function[spec] = spectro(x, fs, windowSize, overlap)
arguments
    x;
    fs;
    windowSize = 1000; % number of samples per window
    overlap = 0;
end
N = length(x);
i = 1;

freq = 0:fs/windowSize:fs/2;
times = [];
windows = [];

while i + windowSize < N
    hanningWindow = hann(windowSize);
    sig = x(i:i+windowSize - 1, :) .* hanningWindow;
    tempFft = fft(sig)/windowSize;
    tempFft = tempFft(1:windowSize/2+1);
    

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

end