% function words = ROC_detemination(audio, fs)
%     [melon, fs_melon] = audioread("audio/Melon_default.wav");
%     melon = melon(:, 1);
%     [vader, fs_vader] = audioread("audio/Vader.wav");
%     vader = vader(:, 1);
%     [bat, fs_bat] = audioread("audio/Bat.wav");
%     bat = bat(:, 1);
%     [drink, fs_drink] = audioread("audio/Drink.wav");
%     drink = drink(:, 1);
%     [wash, fs_wash] = audioread("audio/Wash.wav");
%     wash = wash(:, 1);
%     psd_melon = psd_plot.psd_calculation(melon, fs_melon);
%     psd_vader = psd_plot.psd_calculation(melon, fs_melon);
% 
%     mean = [melon';vader';bat';drink';wash'];
%     ave = movmean(pow2db(psdx), 200);
% end

audioDir = './speech_commands_v0.02/backward';

ads = audioDatastore(audioDir, 'IncludeSubfolders',true, 'FileExtensions','.wav', 'LabelSource','foldernames');
features = [];
labels = [];
while hasdata(ads)
    [audioIn,info] = read(ads);
    coeffs = mfcc(audioIn,info.SampleRate);
    tempFeature = mean(coeffs, 1);
    tempFeature = reshape(tempFeature, 14,[]);  % This ensures it's always a row vector
    features = [features; tempFeature'];
    labels = [labels;info.Label];
end

classifier = fitcecoc(features, labels);

testAudioDir ='./speech_commands_v0.02/';
[testFeatures, testLabels] = helperExtractFeatures(testAudioDir);
predictedLabels = predict(classifier, testFeatures);

confMat = confusionmat(testLabels, predictedLabels);
confchart = confusionchart(confMat, categories(testLabels));


[X, Y, T, AUC] = perfcurve(testLabels, scores(:,2), positiveClass);
plot(X, Y);
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for Classification by SVM')
