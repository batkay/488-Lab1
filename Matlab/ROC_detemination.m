% Read audio data
[melon, fs_melon] = audioread("audio/Melon_default.wav");
melon = melon(:, 1); % Use only the first channel

[amb, fs_amb] = audioread("ambient_noise.wav");
amb = amb(:, 1); % Use only the first channel

[vader, fs_vader] = audioread("audio/Vader.wav");
vader = vader(:, 1); % Use only the first channel

[wash, fs_wash] = audioread("audio/Wash.wav");

[drink, fs_drink] = audioread("audio/Drink.wav");

noizy = readmatrix("Noise_output.csv");
noizy = noizy(1:length(melon));
% Compute comparison scores
score_amb_amb = compare(amb, amb);
scoare_noizy_amv = compare(amb,noizy);
score_amb_melon = compare(amb, melon);
score_amb_vader = compare(amb, vader);
score_amb_drink = compare(amb,drink);
score_amb_wash = compare(amb, wash);
score_noizy_was = compare(noizy,wash);



% Compile scores into an array
scores = [score_amb_amb, score_amb_melon, score_amb_vader,score_amb_drink, score_amb_wash,score_noizy_was];
filtered_scores = double(scores <= 0.5z);

% scores = scores > 0.4;
% Define labels for the ROC analysis (1 for target, 0 for non-target)
labels = [0,0, 1, 1,1,1]; % Assuming 'amb' compared to itself is the positive class

% Calculate ROC curve data
[X, Y, T, AUC] = perfcurve(labels, filtered_scores, 1);

% Plot the ROC curve
figure;
plot(X, Y);
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for Classification');

%% 
% audio ={amb,melon,vader,wash,drink, noizy}
% scores = zeros(1,6);
% for audio
% 
%     y =  filter(bpFilt, y_unfiltered(:,i));
%     % plot buffer (includes overlapping audio frames)
%     subplot(2,1,1);
%     plot(t,y)
%     axis tight
%     ylim([-.3,.3])
%     xlabel('t (s)'), ylabel('x(t)'), title('Audio stream')
%     [pxx, freq] = pwelch(y, hamming(window_size), [], [], fs);
%     speech_power = max(pxx);
%     % word = "no word detected";
% 
% 
%     % Improved detection threshold based on dynamic conditions
%     adoptive_threshold = mean(pxx) + 2 * std(pxx); % Adaptive threshold
%     min_threshold = 1e-9;
% 
%     threshold = max(min_threshold,adoptive_threshold);
% 
%     % Word detection logic
%     if (speech_power - old_psd > threshold)
%         scores(i) = 1;
%     else
%         scores(i) = 0;
%     end
% end
