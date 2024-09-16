% pass in data1 and data2 without taking fft
function [lags, corr] = compare(data1, data2)
    data1 = data1/max(data1);
    data2 = data2/max(data2);

    data1(abs(data1) < 0.1) = 0;
    data2(abs(data2) < 0.1) = 0;

    N1 = length(data1);
    fft1 = fft(data1);
    fft1 = fft1(1:N1/2+1);

    N2 = length(data2);
    fft2 = fft(data2);
    fft2 = fft2(1:N2/2+1);

    upSize = max(N1, N2);
    fft1 = abs(fft1)/ max(abs(fft1));
    fft2 = abs(fft2)/ max(abs(fft2));

    fft1 = paddata(fft1, upSize);
    fft2 = paddata(fft2, upSize);

    [corr, lags] = xcorr(fft1, fft2, 'normalized');

    figure;
    plot(lags, corr);
    title("Correlation Factor");
    xlabel("Lag (s)");
    ylabel("Correlation");
end