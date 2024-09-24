[audio, fs] = audioread("audio_2/cats_chase_only_turtles_quickly.m4a");
cat = audio(39500:58500);

classify_2(cat);

figure;
plot(1:length(cat), cat);