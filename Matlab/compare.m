% pass in data1 and data2 without taking fft
function r = compare(data1, data2, display)
arguments
    data1;
    data2;
    display = false;
end
    corr = 0;

    N1 = length(data1);
    N2 = length(data2);

    N = max(N1, N2);

    data1 = paddata(data1, N);
    data2 = paddata(data2, N);


    % s1 = spectro(data1, 48e3);
    % s2 = spectro(data2, 48e3);
    s1 = abs(spectrogram(data1, hanning(1000)));
    s2 = abs(spectrogram(data2, hanning(1000)));

    % [m,n] = size(s1);
    % [m1,n1] = size(s2);
    % if m < m1
    %     s2 = s2(1:m,:); % extend A with rows of zeros, up to the number of rows of A1
    % elseif m > m1
    %     s1 = s1(1:m1,:); % extend A1 with rows of zeros, up to the number of rows of A
    % end
    % if n < n1
    %     s2 = s2(:,1:n); % extend A with columns of zeros, up to the number of columns of A1
    % elseif n > n1
    %     s1 = s1(:,1:n1); % extend A1 with columns of zeros, up to the number of columns of A
    % end

    % if m < m1
    %     s1(m1,:) = 0; % extend A with rows of zeros, up to the number of rows of A1
    % elseif m > m1
    %     s2(m,:) = 0; % extend A1 with rows of zeros, up to the number of rows of A
    % end
    % if n < n1
    %     s1(:,n1) = 0; % extend A with columns of zeros, up to the number of columns of A1
    % elseif n > n1
    %     s2(:,n) = 0; % extend A1 with columns of zeros, up to the number of columns of A
    % end
    % s1(s1 == inf) = 0;
    % s2(s2 == inf) = 0;

    s1 = reshape(s1, 1, []);
    s2 = reshape(s2, 1, []);
    sLen = max(length(s1), length(s2));

    s1 = paddata(s1, sLen);
    s2 = paddata(s2, sLen);
    r = max(xcorr(s1, s2, 'normalized'));
    corr = corr + r;
    % r = max(normxcorr2(s1, s2), [], "all");


    data1 = data1/max(data1);
    data2 = data2/max(data2);

    data1(abs(data1) < 0.3) = 0;
    data2(abs(data2) < 0.3) = 0;

    

    c1 = max(abs(xcorr(data1, data2, 'normalized')));
    corr = corr + c1;

    fft1 = fft(data1);
    fft1 = fft1(1:N/2+1);

    fft2 = fft(data2);
    fft2 = fft2(1:N/2+1);

    fft1 = abs(fft1)/ max(abs(fft1));
    fft2 = abs(fft2)/ max(abs(fft2));

    c2 = max(abs(xcorr(fft1, fft2, 'normalized')));
    corr = corr + max(c2);
    if display
        figure;
        display(lags, c);
        title("Correlation Factor");
        xlabel("Lag (s)");
        ylabel("Correlation");
    end
end