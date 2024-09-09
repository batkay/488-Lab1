function[spec] = spectro(x, fs, windowSize, overlap)
arguments
    x;
    fs;
    windowSize = 10000; % number of samples per window
    overlap = 0;
end
N = length(x);
i = 1;

freq = 0:fs/windowSize:fs/2;
times = [];
windows = [];

while i + windowSize - overlap < N
    tempFft = fft(x);
    tempFft = tempFft(1:windowSize/2+1);
    

    time = i * fs;

    times = [times; time];
    windows = [windows; tempFft'];

    % increment
    i = i + windowSize - overlap;
end
image(times, freq, abs(windows), 'CDataMapping','scaled');
colorbar;

end