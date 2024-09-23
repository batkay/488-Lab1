%% Adapted from DeepLearningSpeechRecognitionExample.m, Matlab 2020b

% Modified to take FFT and PSD at end, used to measure noise for room
% through microphone, noise through loopback, and noise for no connection

% Initializes audio device, streams audio data and displays running buffer
% of time-domain data

%% Initialize Streaming Audio from Microphone

fs = 48e3; % sample frequency
audioFrameRate = 20; 
dataPrecision = '16-bit integer'; 
adr = audioDeviceReader('SampleRate',fs,'SamplesPerFrame',floor(fs/audioFrameRate),'BitDepth',dataPrecision);

% note: other options available in audioDeviceReader, e.g., selection of audio device, driver 

% to see all devices, 
devR = getAudioDevices(adr)

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
    subplot(2, 1, 1)
    plot(t,y(:,i))
    axis tight
    ylim([-.3,.3]) 
    xlabel('t (s)'), ylabel('x(t)'), title('Audio stream')
    word = classify(y(:, i));
    text(0.2, 0.2, word, "FontSize", 40);
    subplot(2, 1, 2)
    [windows, times, freq] = spectro(y(:, i), fs);
    imagesc(times, freq, windows, 'CDataMapping','scaled');
    colormap('jet');
    axis('xy');
    colorbar;
    xlabel("Time (s)");
    ylabel("Frequency (Hz)");
    drawnow


    i = i+1; 

end
% psd_plot(y(:,i - 1), fs);
% Release audio objects 
release(adr)
release(audioBuffer)



%% testing
% Record_audioLatencyMeasurement('Device',"Aggregate Device",'SampleRate',fs,'SamplesPerFrame',64,"Plot",true);
% Play_audioLatencyMeasurement('Device',"Aggregate Device",'SampleRate',fs,'SamplesPerFrame',64,"Plot",true);
% recordLoopbackAudio('Device',"Aggregate Device",'SampleRate',fs,'SamplesPerFrame',64,"Plot",true);
