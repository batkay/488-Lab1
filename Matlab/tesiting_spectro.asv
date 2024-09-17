
%% import all the audios
mainDir = 'audio/'; % Update this path

% List all audio files

subdirs = {'Bat', 'Drink', 'Melon', 'Vader', 'Wash', 'Other'};
for k = 1:length(subdirs)
    subdirPath = fullfile(mainDir, subdirs{k});
    files = dir(fullfile(subdirPath, '*.m4a'));
    count = dir(fullfile(subdirPath,'*'));
    for i = 1:length(files)
        % Read the audio file
        [audioData, fs] = audioread(fullfile(subdirPath, files(i).name));
        
        cleanName = matlab.lang.makeValidName(files(i).name);
        % Store audio data and sample rate in the structure
        dataStruct.(sprintf('%s_audioData', cleanName)) = audioData;
        fsStruct.(sprintf('%s_fs', cleanName)) = fs;
    end

end

%% Score calculation
audioFiles = {'audio/Bat_2.m4a','audio/Bat_3.m4a','audio/Bat_4.m4a','audio/Bat_noisy.m4a','audio/Drink.m4a','audio/Drink_2.m4a'}; % Define your actual file paths
computeROCUsingCrossCorrelation(computeAllCrossCorrelations(mainDir), 'audio/Bat.m4a');

%% Process ROC

computeROC("audio/Bat.m4a","ambient_noise.wav" );
function computeROC(inputArg1, inputArg2)
    [x, Fs] = audioread(inputArg1);
    [x1, Fs1] = audioread(inputArg2);

    if size(x, 2) == 2
        x = mean(x, 2); % Convert to mono if stereo
    end
    if size(x1, 2) == 2
        x1 = mean(x1, 2); % Convert to mono if stereo
    end

    Compute the FFT of both signals
    Y = fft(x);
    Z = fft(x1);
    Y = Y(1:floor(length(Y)/2)+1); 
    Z = Z(1:floor(length(Z)/2)+1); % Keep only the half frequencies avoid alias

    [c, lags] = xcorr(abs(Y), abs(Z),'none'); % Normalized cross-correlation

    peak_corr = max(abs(c));
    
    labels = abs(c) < peak_corr; % True if below peak correlation
    scores = abs(c); % Use correlation as scores for ROC
    
    % Calculate ROC curve
    [X, Y, T, AUC] = perfcurve(labels, scores, 0); % 0 assumes the positive class is labeled as 0
    AUC
    figure;
    plot(X, Y, 'LineWidth', 2);
    title(['ROC Curve for Audio Correlation, AUC = ' num2str(AUC)]);
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    grid on;
end
%%


function computeROCUsingCrossCorrelation(scores, groundTruthFile)
    [groundTruthSignal, fsG] = audioread(groundTruthFile);
    scores = zeros(numFiles, 1);
    trueLabels ={'Bat', 'Drink', 'Melon', 'Vader', 'Wash'}; % Example category labels
       
    % Calculate cross-correlation and extract scores
    for i = 1:numFiles
        [audioSignal, fs] = audioread(audioFiles{i});
        if fs ~= fsG
            audioSignal = resample(audioSignal, fsG, fs);
        end

        [c, lags] = xcorr(audioSignal, groundTruthSignal, 'none');
        
        % Extract the maximum correlation value as the score
        scores(i) = max(abs(c));
    end
    
    % Assuming binary classification for category 1
    binaryLabels = trueLabels == 1;
    
    % Compute ROC curve
    [X, Y, T, AUC] = perfcurve(binaryLabels, scores, true);
    
    % Plot the ROC curve
    figure;
    plot(X, Y);
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    title(['ROC Curve with AUC = ' num2str(AUC)]);
    grid on;
end

function computeAllCrossCorrelations(baseDir)
    % List of keywords excluding 'badfeeling'
    keywords = {'Wash', 'Vader', 'Melon', 'Drink', 'Bat'};

    % Iterate through each keyword
    for k = 1:length(keywords)
        keyword = keywords{k};

        % Ground truth .wav file
        wavFile = fullfile(baseDir, [keyword, '.wav']);

        % Check if the ground truth file exists
        if ~isfile(wavFile)
            warning(['Missing ground truth WAV file for ', keyword]);
            continue;  % Skip this keyword if ground truth file is missing
        end

        [groundTruth, fs] = audioread(wavFile);
        m4aFiles = dir(fullfile(baseDir, [keyword, '*.m4a']));
        for i = 1:length(m4aFiles)
            m4aFile = fullfile(baseDir, m4aFiles(i).name);
            [audioData, fs1] = audioread(m4aFile);
            % Compute the cross-correlation
            [c, lags] = xcorr(audioData, groundTruth, 'coeff');
            % Find the peak correlation and its lag
            [peakCorr, idx] = max(abs(c));
            lagPeak = lags(idx);
            % Display or store results
            disp(['Keyword: ', keyword, ', File: ', m4aFiles(i).name, ...
                  ', Peak Correlation: ', num2str(peakCorr), ...
                  ', Lag: ', num2str(lagPeak)]);

            % Optional: plot the cross-correlation
            figure;
            plot(lags, c);
            title(['Cross-correlation between ', keyword, ' WAV and M4A']);
            xlabel('Lags');
            ylabel('Correlation');
            grid on;
        end
    end
end

