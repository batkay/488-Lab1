function [t, audioOut, loopbackAudio]  = audioLatencyMeasurementSineApp(varargin)
%AUDIOLATENCYMEASUREMENTEXAMPLEAPP Measure audio latency by using a
%loopback audio cable to connect the audio-out port to audio-in port.
%
% This example uses audioPlayerRecorder which requires full-duplex capable
% audio devices. On Windows, ASIO drivers are required.
%
% Optional Inputs (Name/Value pairs):
%   AUDIOLATENCYMEASUREMENTEXAMPLEAPP(...,'SamplesPerFrame',BufferSize)
%       BufferSize can be a vector of different values to try. 
%       Defaults to 96.
%   AUDIOLATENCYMEASUREMENTEXAMPLEAPP(...,'SampleRate',Fs)
%       Fs can be a vector of sample rates to try.
%       Defaults to 48000 (48 kHz).   
%   AUDIOLATENCYMEASUREMENTEXAMPLEAPP(...,'Device',MyDevice)
%       MyDevice is a string with the name of the device to be used.
%       Defaults to the system default device.
%   AUDIOLATENCYMEASUREMENTEXAMPLEAPP(...,'IOChannels',IOChannels)
%       IOChannels is a 2-element vector with custom channels to use.
%       Defaults to [1 1].
%   AUDIOLATENCYMEASUREMENTEXAMPLEAPP(...,'Ntrials',N)
%       N is a positive integer scalar it the number of trials to run.
%       Defaults to 1.
%   AUDIOLATENCYMEASUREMENTEXAMPLEAPP(...,'FilterLength',L)
%       l is the length of the linear-phase FIR filter to use.
%       Defaults to 1 (no filter).
%   AUDIOLATENCYMEASUREMENTEXAMPLEAPP(...,'Plot',flag)
%       flag is a boolean indicating whether to plot the measurements.
%       Defaults to false.
% Output: 
%   A table with latency in milliseconds for each trial.
%
% This function is an example only. It may change in a future release.

% Copyright 2014-2017 The MathWorks, Inc.

p = inputParser;

p.addParameter('SamplesPerFrame',96); %[64 96 128 192 256 384 512];
p.addParameter('Ntrials',1);
p.addParameter('FilterLength',1);
p.addParameter('SampleRate',48e3); %SampleRate = [44.1e3,48e3,88.2e3,96e3];
p.addParameter('Device','Default');
p.addParameter('IOChannels',[1 1]);
p.addParameter('Plot',false);
p.addParameter('Frequency', 10); %Hz

p.parse(varargin{:});
res = p.Results;

Ntrials         = res.Ntrials;
device          = res.Device;
iochannels      = res.IOChannels;
SampleRate      = res.SampleRate;
L               = res.FilterLength;
plotflag        = res.Plot;
SamplesPerFrame = res.SamplesPerFrame;
frequency = res.Frequency;

validateattributes(Ntrials,{'numeric'},{'positive', 'integer', 'scalar','<=', 5},...
    'audioLatencyMeasurementExampleApp','Ntrials');

validateattributes(L,{'numeric'},{'positive', 'integer', 'scalar','finite'},...
    'audioLatencyMeasurementExampleApp','L');

validateattributes(iochannels,{'numeric'},{'positive', 'finite','integer', 'vector',...
    'numel', 2},'audioLatencyMeasurementExampleApp','IOChannels');

validateattributes(SampleRate,{'numeric'},{'positive', 'finite','vector'},...
    'audioLatencyMeasurementExampleApp','SampleRate');

validateattributes(SamplesPerFrame,{'numeric'},{'positive', 'finite','integer','vector'},...
    'audioLatencyMeasurementExampleApp','SamplesPerFrame');

validateattributes(plotflag,{'logical'},{'scalar'},...
    'audioLatencyMeasurementExampleApp','Plot');

validateattributes(frequency,{'numeric'},{'positive', 'finite','vector'},...
    'audioLatencyMeasurementExampleApp','Frequency');

Lb = length(SamplesPerFrame);
Lf = length(SampleRate);

t = [];
for k = 1:Lb
    for m = 1:Lf
        [r, audioOut, loopbackAudio] = ...
            latencyMeasurementTrial('SamplesPerFrame',SamplesPerFrame(k),'FilterLength',L,...
            'Device',device,'Plot',false,'IOChannels',iochannels,'SampleRate',SampleRate(m),...
            'Ntrials',Ntrials,'Plot',plotflag, 'Frequency', frequency);
        t = [t;r];
    end
end

function [r, audioOut, loopbackAudio] = latencyMeasurementTrial(varargin)

p = inputParser; 

p.addParameter('FilterLength',1);
p.addParameter('SampleRate',48e3);
p.addParameter('SamplesPerFrame',512);
p.addParameter('Device','Default');
p.addParameter('IOChannels',[1 1]);
p.addParameter('Plot',false);
p.addParameter('Ntrials',1);
p.addParameter('Frequency', 10);

p.parse(varargin{:});
res = p.Results;

L          = res.FilterLength;
SampleRate = res.SampleRate;
frameSize  = res.SamplesPerFrame;
plotflag   = res.Plot;
device     = res.Device;
iochannels = res.IOChannels;
Ntrials     = res.Ntrials;
f = res.Frequency;

% Audio file to read from:
fileReader = dsp.AudioFileReader('RockDrums-48-stereo-11secs.mp3', ...
                'SamplesPerFrame', frameSize);
playDuration = 3;

% Audio IO:
syncAudioDevice = audioPlayerRecorder('SampleRate',SampleRate,'Device',device);

syncAudioDevice.BitDepth = '32-bit float';

syncAudioDevice.RecorderChannelMapping = iochannels(1);
syncAudioDevice.PlayerChannelMapping   = iochannels(2);

% Buffer to store played and recorded signals. Add an additional trial for
% warmup since there are sometimes drops in the first run.
NFrames = ceil(playDuration*SampleRate/frameSize);
Buffer  = dsp.AsyncBuffer((Ntrials+1)*NFrames*frameSize);

% Store audio in Buffer to not have disk access in the loop
fileReader.SamplesPerFrame = NFrames*frameSize;
audioOut = fileReader();
audioOut = audioOut(:,1); % Keep only first channel
time = (0:1/SampleRate:playDuration-1/SampleRate)';
audioOut = sin(time*2*pi*f);
for k = 1:Ntrials+1
    write(Buffer,audioOut);   % Initialize Buffer
end

% Design filter for algorithm loop
b = fir1(L,.9);
z = [];

% Initialize results
r.SamplesPerFrame = frameSize*ones(Ntrials,1);
r.SampleRate = SampleRate/1000*ones(Ntrials,1);
if L > 1
    r.FilterLength = L*ones(Ntrials,1);
end
r.Latency = NaN;
    
%% Loopback simulation

% MATLAB simulation. Add an additional trial for warmup since there are
% sometimes drops in the first run.
Underruns = zeros(Ntrials+1,1);
Overruns  = zeros(Ntrials+1,1);
for k = 1:Ntrials+1
    for ind = 1:NFrames
        [audioIn, nUnderruns, nOverruns] = syncAudioDevice(read(Buffer,frameSize));
        Underruns(k) = Underruns(k) + nUnderruns;
        Overruns(k)  = Overruns(k)  + nOverruns;
        [FilteredAudioIn,z] = filter(b,1,audioIn,z);
        write(Buffer,FilteredAudioIn);
    end
end

fprintf('Trial(s) done for frameSize %d. \n',frameSize);

% Compute cross-correlation and plot
read(Buffer,NFrames*frameSize);
latency = zeros(Ntrials,1);
for k = 1:Ntrials
    loopbackAudio = read(Buffer,NFrames*frameSize);
    % Account for possible drops in the warmup run
    [temp,idx] = xcorr(audioOut,loopbackAudio(Underruns(1)+Overruns(1)+1:end));
    rxy = abs(temp);
    
    [~,Midx] = max(rxy);
    latency(k) = -idx(Midx)*1/SampleRate;
end

latency(latency<0) = NaN;

r.Overruns = Overruns(2:end);
r.Underruns = Underruns(2:end);
r.Latency  = latency*1000;

r = struct2table(r);

if L == 1
    r.Properties.VariableUnits = {'Samples' 'Hz' 'ms' 'Samples' 'Samples'};
    r.Properties.VariableNames = {'SamplesPerFrame', 'SampleRate_kHz',...
        'Latency_ms', 'Overruns', 'Underruns'};
else
    r.Properties.VariableUnits = {'Samples' 'Hz' 'Samples' 'ms' 'Samples' 'Samples'};
    r.Properties.VariableNames = {'SamplesPerFrame', 'SampleRate_kHz' 'FilterLength',...
        'Latency_ms', 'Overruns', 'Underruns'};
end

%% Plot original and loopback signal
if plotflag
    fprintf('Plotting... \n');
    
    figure
    t = 1/SampleRate*(0:size(loopbackAudio,1)-1);
    subplot(2,1,1), plot(t,[audioOut,loopbackAudio])
    title(['Audio signals: SamplesPerFrame: ',num2str(frameSize),' SampleRate: ',num2str(SampleRate)]);
    legend('Signal from audio file',...
        'Signal recorded (added latency of audio input and output)');
    xlabel('Time (in sec)');
    ylabel('Audio signal');
    axis([0 3 -1 1]);
        
    subplot(2,1,2), plot(1/SampleRate*((0:2*length(audioOut)-2)-length(audioOut)),temp)
    title('Cross correlation between played and received signals');
    xlabel('Time (in sec)');
    ylabel('correlation');
    axis([-3 3 -1000 2000]);

    psd_plot(loopbackAudio, SampleRate)
end

%% Cleanup
release(fileReader); % release the input file
release(syncAudioDevice);  


