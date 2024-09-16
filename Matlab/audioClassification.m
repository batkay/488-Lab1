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

[audio_2, fs_2] = audioread("audio/Drink_2.m4a");
audio_2 = audio_2(:, 1);

c_values = zeros(1, 5);
c_strings = {'Melon', 'Vader', 'Bat', 'Drink', 'Wash'};
[~, c_melon] = compare(melon, audio_2);
c_values(1) = max(c_melon);
[~, c_vader] = compare(vader, audio_2);
c_values(2) = max(c_vader);
[~, c_bat] = compare(bat, audio_2);
c_values(3) = max(c_bat);
[~, c_drink] = compare(drink, audio_2);
c_values(4) = max(c_drink);
[~, c_wash] = compare(wash, audio_2);
c_values(5) = max(c_wash);

[m, idx] = max(c_values);
disp(c_strings(idx));
disp(m);