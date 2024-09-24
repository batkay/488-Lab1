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
    % figure
    % subplot(5,1,1);
    % spectro(melon, fs_melon);
    % title('Melon Audio');
    % subplot(5,1,2);
    % spectro(vader, fs_vader);
    % title('Vader Audio');
    % subplot(5,1,3);
    % spectro(bat, fs_bat);
    % title('Bat Audio');
    % 
    % subplot(5,1,4);
    % spectro(drink, fs_drink);
    % title('Drink Audio');
    % 
    % subplot(5,1,5);
    % spectro(wash, fs_wash);
    % title('Wash Audio');

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
