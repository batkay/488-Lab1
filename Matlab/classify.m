function word = classify(audioIn)
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

    c_values = zeros(1, 5);
    c_strings = {'Bat', 'Drink', 'Melon', 'Vader', 'Wash'};

    c_values(1) = compare(bat, audioIn);
    c_values(2) = compare(drink, audioIn);
    c_values(3) = compare(melon, audioIn);
    c_values(4) = compare(vader, audioIn);
    c_values(5) = compare(wash, audioIn);

    [~, idx] = max(c_values);
    word = c_strings(idx);

end