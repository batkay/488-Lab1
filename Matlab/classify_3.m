function [word, c_val, lag] = classify_2(audioIn)
    [elk, fs_cats] = audioread("audio_2/Elk.wav");
    elk = elk(:, 1);
    [finding, fs_only] = audioread("audio_2/Find.wav");
    finding = finding(:, 1);
    [only, fs_quickly] = audioread("audio_2/Only.wav");
    only = only(:, 1);
    [mice, fs_turtles] = audioread("audio_2/Mice.wav");
    mice = mice(:, 1);
    [fast, fs_chase] = audioread("audio_2/Fast.wav");
    fast = fast(:, 1);

    c_values = zeros(1, 5);
    c_strings = {'Elk', 'Find', 'Only', 'Mice', 'Fast'};

    c_values(1) = compare_2(elk, audioIn);
    c_values(2) = compare_2(finding, audioIn);
    c_values(3) = compare_2(only, audioIn);
    c_values(4) = compare_2(mice, audioIn);
    c_values(5) = compare_2(fast, audioIn);

    [c_val, idx] = max(c_values);
    word = c_strings(idx);

end