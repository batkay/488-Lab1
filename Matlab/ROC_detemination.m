function words = ROC_detemination(audio, fs)
    [melon, fs_melon] = audioread("audio/Melon_default.wav");
    melon = melon(:, 1);
    [vader, fs_vader] = audioread("audio/Vader.wav");
    vader = vader(:, 1);
    [bat, fs_bat] = audioread("audio/Bat.wav");
    bat = bat(:, 1);
    [drink, fs_drink] = audioread("audio/Drink.wav");
    drink = drink(:, 1);
    [wash, fs_wash] = audioread("audio/Wash.wav");
    wash = wash(:, 1);
    psd_melon = psd_plot.psd_calculation(melon, fs_melon);
    psd_vader = psd_plot.psd_calculation(melon, fs_melon);

    mean = [melon';vader';bat';drink';wash'];
    ave = movmean(pow2db(psdx), 200);
end