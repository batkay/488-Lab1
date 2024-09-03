%% Adapted from DeepLearningSpeechRecognitionExample.m, Matlab 2020b

% Initializes audio device, streams audio data and displays running buffer
% of time-domain data

%% Initialize Streaming Audio from Microphone

fs = 48e3; % sample frequency
audioFrameRate = 20; 
dataPrecision = '16-bit integer'; 
adr = audioDeviceReader('Device','Microphone (Sound Blaster Play! 3)','SampleRate',fs,'SamplesPerFrame',floor(fs/audioFrameRate),'BitDepth',dataPrecision);

% note: other options available in audioDeviceReader, e.g., selection of audio device, driver 

% to see all devices, devR = getAudioDevices(adr), devR{:}

% Open question: how to control microphone gain? 

% see Matlab references:  
% https://www.mathworks.com/help/audio/gs/real-time-audio-in-matlab.html
% https://www.mathworks.com/help/audio/gs/audio-io-buffering-latency-and-throughput.html 
% possibly https://www.mathworks.com/help/audio/ug/measure-audio-latency.html 

%% Stream audio from the device

% Initialize a buffer for the audio frames (might be possible without dsp.* tools, processing advantage of dsp.* unknown)
audioBuffer = dsp.AsyncBuffer(fs);

h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);

timeLimit = 10;

tic;
i = 1;
t = [0:fs-1]/fs; 

while ishandle(h) && toc < timeLimit

    % Extract audio samples from the audio device and add to the buffer.
    [audioIn overrun(i)] = adr();
    write(audioBuffer,audioIn);
    y(:,i) = read(audioBuffer,fs,fs-adr.SamplesPerFrame);

    % plot buffer (includes overlapping audio frames)
    plot(t,y(:,i))
    axis tight
    ylim([-.3,.3]) 
    xlabel('t (s)'), ylabel('x(t)'), title('Audio stream')
    drawnow

    i = i+1; 

end

% Release audio objects 
release(adr)
release(audioBuffer)

%% 
audioLatencyMeasurementExampleApp('SamplesPerFrame',[32 1024],'SampleRate',96e3,'Plot',true)

% %% frequency analysis
% [N, numFrames] =size(y);
% 
% 
% % Perform FFT for each frame
% for i = 1:numFrames
%     Y = fft(y(:, i)); % FFT of the i-th frame
%     P2 = abs(Y/N); % Two-sided spectrum
%     P1 = P2(1:N/2+1); % Single-sided spectrum
%     P1(2:end-1) = 2*P1(2:end-1); % Correct the amplitude
%     Y_freq(:, i) = P1; % Store the result
% end
% 
% % Frequency vector
% f = fs*(0:(N/2))/N;
% 
% %%
% % Plot the frequency content of the first frame as an example
% figure;
% plot(f, Y_freq(:, 1));
% title('Amplitude Spectrum of First Frame');
% xlabel('Frequency (Hz)');
% ylabel('|P1(f)|');
% grid on;
%% 
