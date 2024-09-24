%% Adapted from DeepLearningSpeechRecognition Example.m, Matlab 2020b

% Modified to take FFT and PSD at end, used to measure noise for room
% through microphone, noise through loopback, and noise for no connection

% Initializes audio device, streams audio data and displays running buffer
% of time-domain data

clear all;
close all;

%% Initialize Streaming Audio from Microphone

fs = 48e3; % sample frequency
audioFrameRate = 32;
dataPrecision = '16-bit integer';
adr = audioDeviceReader( 'Device','MacBook Pro Microphone','SampleRate',fs,'SamplesPerFrame',floor(fs/audioFrameRate),'BitDepth',dataPrecision);
% 'Device','Aggregate Device',
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

timeLimit = 35;

tic;
i = 1;
t = [0:fs-1]/fs;

old_psd = 0; %set the initial value of PSD to 0
psd_array = [0, 0, 0];
word = "no word detected";
disp("start recording")


classificationDelay = .6;  % Delay in seconds before reclassifying
lastClassificationTime = 0;  % Track when the last classification was done

%filter range

f_low = 200; % Lower cutoff frequency (300 Hz)
f_high = 3400; % Upper cutoff frequency (3400 Hz)

bpFilt = designfilt('bandpassiir', 'FilterOrder', 6, ...
    'HalfPowerFrequency1', f_low, 'HalfPowerFrequency2', f_high, ...
    'SampleRate', fs);
% Visualize the frequency response of the filter
% fvtool(bpFilt);

window_size = round(1/audioFrameRate*fs)*0.5;

word_detected = false; % Flag for word detection
word_display_duration = 0.5; % Duration (in seconds) to keep displaying the word
display_timer = 0; % Timer to manage how long the word is displayed

% % testing audio
% [big, big_fs] = audioread("audio/bigAudio.wav");
% b = audioplayer(big,big_fs);
% play(b)


while ishandle(h) && toc < timeLimit

    % Extract audio samples from the audio device and add to the buffer.
    [audioIn overrun(i)] = adr();
    write(audioBuffer,audioIn);

    y_unfiltered(:,i) =5 *read(audioBuffer,fs,fs-adr.SamplesPerFrame);

    % Apply filter to isolate human voice
    y =  filter(bpFilt, y_unfiltered(:,i));


    % plot buffer (includes overlapping audio frames)
    subplot(2,1,1);
    plot(t,y)
    axis tight
    ylim([-.3,.3])
    xlabel('t (s)'), ylabel('x(t)'), title('Audio stream')
    [pxx, freq] = pwelch(y, hamming(window_size), [], [], fs);
    speech_power = max(pxx);
    % word = "no word detected";


    % Improved detection threshold based on dynamic conditions
    adoptive_threshold = mean(pxx) + 2 * std(pxx); % Adaptive threshold
    min_threshold = 1e-9;

    threshold = max(min_threshold,adoptive_threshold);

    % Word detection logic
    if (speech_power - old_psd > threshold) && (toc - lastClassificationTime > classificationDelay)
        word = classify(y);  
        word_detected = true;
        display_timer = toc;
        lastClassificationTime = toc;  % Update last classification time
        disp("Word detected");
    else
        if toc - display_timer > word_display_duration
            word_detected = false;
        end
    end

    % display_word = word;
    % Display the word if detected
    if word_detected
        display_word = word;
    else
        display_word = "no word detected";
    end

    text(0.2, 0.2, display_word, "FontSize", 40);
    text(0.2, -0.2, num2str(speech_power), "FontSize", 40);

    old_psd = speech_power;
    % freq =0:fs/length(y):fs/2;
    subplot(2,1,2);

    % win = hamming(window_size,'periodic');
    % percentOverlap = 50;
    % overlap = round(window_size*percentOverlap/100);
    % 
    % mergeDuration = 0.44;
    % mergeDist = round(mergeDuration*fs);

     
    [idx,threshold] = detectSpeech(y,fs,"Window",win);
    detectSpeech(y,fs,"Window",win)

    % segmentStart = idx(i, 1);
    % segmentEnd = idx(i, 2);
    % speechSegment = y(segmentStart:segmentEnd);  % Extract the segment
    % sound(speechSegment, fs);  % Play the segment
    % pause(length(speechSegment)/fs + 0.5);  % Pause to allow the segment to finish plus a little extra time before the next
    % word = [word,classify(speechSegment)];
    % plot(freq,pxx);
    % detectSpeech(y,fs);
    title("psd plot");
    ylim([-1 1])

    drawnow
    i = i+1;


end

% Release audio objects
release(adr)
release(audioBuffer)
disp("end recording")


%% function
