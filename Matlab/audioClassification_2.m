[bat_2, fs_bat_2] = audioread("audio_2/Cats_2.m4a");
bat_2 = bat_2(:, 1);
[bat_3, fs_bat_3] = audioread("audio_2/Cats_3.m4a");
bat_3 = bat_3(:, 1);
[bat_4, fs_bat_4] = audioread("audio_2/Cats_4.m4a");
bat_4 = bat_4(:, 1);

[drink_2, fs_drink_2] = audioread("audio_2/Chase_2.m4a");
drink_2 = drink_2(:, 1);
[drink_3, fs_drink_3] = audioread("audio_2/Chase_3.m4a");
drink_3 = drink_3(:, 1);
[drink_4, fs_drink_4] = audioread("audio_2/Chase_4.m4a");
drink_4 = drink_4(:, 1);

[melon_2, fs_meon_2] = audioread("audio_2/Only_2.m4a");
melon_2 = melon_2(:, 1);
[melon_3, fs_meon_3] = audioread("audio_2/Only_3.m4a");
melon_3 = melon_3(:, 1);
[melon_4, fs_meon_4] = audioread("audio_2/Only_4.m4a");
melon_4 = melon_4(:, 1);

[vader_2, fs_vader_2] = audioread("audio_2/Quickly_2.m4a");
vader_2 = vader_2(:, 1);
[vader_3, fs_vader_3] = audioread("audio_2/Quickly_3.m4a");
vader_3 = vader_3(:, 1);
[vader_4, fs_vader_4] = audioread("audio_2/Quickly_4.m4a");
vader_4 = vader_4(:, 1);

[wash_2, fs_wash_2] = audioread("audio_2/Turtles_2.m4a");
wash_2 = wash_2(:, 1);
[wash_3, fs_wash_3] = audioread("audio_2/Turtles_3.m4a");
wash_3 = wash_3(:, 1);
[wash_4, fs_wash_4] = audioread("audio_2/Turtles_4.m4a");
wash_4 = wash_4(:, 1);

c_values = zeros(1, 5);
c_strings = {'Cats', 'Chase', 'Only', 'Quickly', 'Turtles'};

trueValues = strings(1, 15);
predictedValues = strings(1, 15);

a = {bat_2, bat_3, bat_4, drink_2, drink_3, drink_4, melon_2, melon_3, melon_4, vader_2, vader_3, vader_4, wash_2, wash_3, wash_4};
for i  = 1:5
    for j = 1:3
        audio_2 = a{(i - 1) * 3 + j};

        trueValues((i - 1) * 3 + j) = c_strings(i);

        predictedValues((i - 1) * 3 + j) = classify_2(audio_2);
    end
end
figure;
cm = confusionchart(trueValues, predictedValues);
