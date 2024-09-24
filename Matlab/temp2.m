[audioIn, fs_in] = audioread("audio_2/only_elk_find_mice_fast.m4a");

[elk, fs_cats] = audioread("audio_2/Elk.wav");
elk = elk(:, 1);
[finding, fs_only] = audioread("audio_2/Find.wav");
finding = finding(:, 1);
[only, fs_quickly] = audioread("audio_2/Only.wav");
only = only(:, 1);
[mice, fs_turtles] = audioread("audio_2/Mice.wav");
mice = mice(:, 1);
[smart, fs_chase] = audioread("audio_2/Fast.wav");
smart = smart(:, 1);

