% pass in data1 and data2 without taking fft
function [r, lag] = compare_2(data1, data2)
arguments
    data1;
    data2;
end

    N1 = length(data1);
    N2 = length(data2);

    N = max(N1, N2);

    data1 = paddata(data1, N);
    data2 = paddata(data2, N);

    s1 = abs(spectrogram(data1, hanning(1024)));
    s2 = abs(spectrogram(data2, hanning(1024)));

    s1 = reshape(s1, 1, []);
    s2 = reshape(s2, 1, []);
    sLen = max(length(s1), length(s2));

    s1 = paddata(s1, sLen);
    s2 = paddata(s2, sLen);
    [r, lag] = max(xcorr(s1, s2, 'normalized'));
    
end