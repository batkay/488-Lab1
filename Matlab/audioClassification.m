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

[bat_2, fs_bat_2] = audioread("audio/Bat_2.m4a");
bat_2 = bat_2(:, 1);
[bat_3, fs_bat_3] = audioread("audio/Bat_3.m4a");
bat_3 = bat_3(:, 1);
[bat_4, fs_bat_4] = audioread("audio/Bat_4.m4a");
bat_4 = bat_4(:, 1);

[drink_2, fs_drink_2] = audioread("audio/Drink_2.m4a");
drink_2 = drink_2(:, 1);
[drink_3, fs_drink_3] = audioread("audio/Drink_3.m4a");
drink_3 = drink_3(:, 1);
[drink_4, fs_drink_4] = audioread("audio/Drink_4.m4a");
drink_4 = drink_4(:, 1);

[melon_2, fs_meon_2] = audioread("audio/Melon_2.m4a");
melon_2 = melon_2(:, 1);
[melon_3, fs_meon_3] = audioread("audio/Melon_3.m4a");
melon_3 = melon_3(:, 1);
[melon_4, fs_meon_4] = audioread("audio/Melon_4.m4a");
melon_4 = melon_4(:, 1);

[vader_2, fs_vader_2] = audioread("audio/Vader_2.m4a");
vader_2 = vader_2(:, 1);
[vader_3, fs_vader_3] = audioread("audio/Vader_3.m4a");
vader_3 = vader_3(:, 1);
[vader_4, fs_vader_4] = audioread("audio/Vader_4.m4a");
vader_4 = vader_4(:, 1);

[wash_2, fs_wash_2] = audioread("audio/Wash_2.m4a");
wash_2 = wash_2(:, 1);
[wash_3, fs_wash_3] = audioread("audio/Wash_3.m4a");
wash_3 = wash_3(:, 1);
[wash_4, fs_wash_4] = audioread("audio/Wash_4.m4a");
wash_4 = wash_4(:, 1);

c_values = zeros(1, 5);
c_strings = {'Bat', 'Drink', 'Melon', 'Vader', 'Wash'};

trueValues = strings(1, 15);
predictedValues = strings(1, 15);

a = {bat_2, bat_3, bat_4, drink_2, drink_3, drink_4, melon_2, melon_3, melon_4, vader_2, vader_3, vader_4, wash_2, wash_3, wash_4};
for i  = 1:5
    for j = 1:3
        audio_2 = a{(i - 1) * 3 + j};

        trueValues((i - 1) * 3 + j) = c_strings(i);

        c_values(1) = compare(bat, audio_2);
        c_values(2) = compare(drink, audio_2);
        c_values(3) = compare(melon, audio_2);
        c_values(4) = compare(vader, audio_2);
        c_values(5) = compare(wash, audio_2);

        [~, idx] = max(c_values);
        predictedValues((i - 1) * 3 + j) = c_strings(idx);
    end
end
figure;
cm = confusionchart(trueValues, predictedValues);

% [audio_2, fs_2] = audioread("audio/Wash_2.m4a");
% audio_2 = audio_2(:, 1);

% figure;
% subplot(2, 1, 1)
% plot(1:length(audio_2), audio_2)
% subplot(2, 1, 2)
% plot(1:length(drink), drink)
% figure;
% subplot(2, 1, 1)
% plot(1:length(audio_2), audio_2)
% subplot(2, 1, 2)
% plot(1:length(bat), bat)
% 
% c_values = zeros(1, 5);
% c_strings = {'Melon', 'Vader', 'Bat', 'Drink', 'Wash'};
% c_values(1) = compare(melon, audio_2);
% c_values(2) = compare(vader, audio_2);
% c_values(3) = compare(bat, audio_2);
% c_values(4) = compare(drink, audio_2);
% c_values(5) = compare(wash, audio_2);
% [~, c_melon] = compare(melon, audio_2);
% c_values(1) = max(c_melon);
% [~, c_vader] = compare(vader, audio_2);
% c_values(2) = max(c_vader);
% [~, c_bat] = compare(bat, audio_2);
% c_values(3) = max(c_bat);
% [~, c_drink] = compare(drink, audio_2);
% c_values(4) = max(c_drink);
% [~, c_wash] = compare(wash, audio_2);
% c_values(5) = max(c_wash);

% [m, idx] = max(c_values);
% disp(c_strings(idx));
% disp(c_values);