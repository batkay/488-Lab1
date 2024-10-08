% Script to plot FFT and PSD of a given signal with frequency fs
% PSD code adapted from
% https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html
classdef psd_plot
    methods(Static)
        function psdx = psd_plot(x, fs)
            noise = readmatrix("Noise_output.csv");
            freq = 0:fs/length(x):fs/2;
            % Calculate SNR
            SNR = signal2noise(x,noise,fs);
            fprintf('The Signal-to-Noise Ratio (SNR) is: %.2f dB\n', SNR);

            % Calculate dynamic range
            [xdft,psdx] = psd_calculation(x,fs);
            ave = movmean(pow2db(psdx), 70);
            dynamic_range = calculate_dynamic_range(ave);
            fprintf('The Dynamic Range is: %.2f dB\n', dynamic_range);

            psd_ploting(freq,xdft,psdx);

        end

        function [xdft,psdx] = psd_calculation(x,fs)
            N = length(x);
            xdft = fft(x);
            xdft = xdft(1:N/2+1);
            psdx = (1/(fs*N)) * abs(xdft).^2;
            psdx(2:end-1) = 2*psdx(2:end-1);

        end

        function SNR =signal2noise(x,noise,fs)
            [~, P_signal] = psd_calculation(x,fs);
            [~, P_noise ] =  psd_calculation(noise,fs);
            SNR = 20 * log10(sum(P_signal)/sum(P_noise)); % SNR
        end

        function SNR = signal2noise_freq_dependent(x, noise, fs)
            N = length(x);
            freq = linspace(0, fs/2, floor(N/2)+1);
            [~, P_signal] = psd_calculation(x, fs);
            [~, P_noise] = psd_calculation(noise, fs);

            bands = [0 31.5 63 125 250 500 1000 2000 4000 8000 16000 fs/2];
            SNR = zeros(1, length(bands)-1);

            for i = 1:length(bands)-1
                band_indices = (freq >= bands(i)) & (freq < bands(i+1));
                band_signal_power = sum(P_signal(band_indices));
                band_noise_power = sum(P_noise(band_indices));

                SNR(i) = 20 * log10(band_signal_power / band_noise_power);
            end
        end


        function SNR = signal2noise_mean_method(signal,fs)
            noise_estimate = signal - mean(signal);
            P_noise = var(noise_estimate);
            P_signal = bandpower(signal);
            SNR = 20 * log10(P_signal/P_noise); % SNR

        end

        function dynamic_range = calculate_dynamic_range(psdx)
            max_power = max(psdx);
            min_power = min(psdx); % Avoid log of zero
            dynamic_range = abs(20 * log10(max_power / min_power)); % Dynamic range in dB
        end

        function psd_ploting (freq,xdft,psdx)
            figure;
            plot(log(freq), abs(xdft));
            grid on
            title("FFT")
            xlabel("Frequency (Hz)")
            ylabel("|fft(x)|")

            ave = movmean(pow2db(psdx), 200);
            figure;
            plot(freq,pow2db(psdx))
            hold on;
            plot(freq, ave,'r',"LineWidth",2)
            grid on
            title("Power Spectral Density")
            xlabel("Frequency (Hz)")
            ylabel("Power/Frequency (dB/Hz)")


        end
    end
end