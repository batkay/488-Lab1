function [word, c_val, lag] = classify_2(audioIn)
    [cats, fs_cats] = audioread("audio_2/Cats.wav");
    cats = cats(:, 1);
    [chase, fs_chase] = audioread("audio_2/Chase.wav");
    chase = chase(:, 1);
    [only, fs_only] = audioread("audio_2/Only.wav");
    only = only(:, 1);
    [quickly, fs_quickly] = audioread("audio_2/Quickly.wav");
    quickly = quickly(:, 1);
    [turtles, fs_turtles] = audioread("audio_2/Turtles.wav");
    turtles = turtles(:, 1);

    c_values = zeros(1, 5);
    c_strings = {'Cats', 'Chase', 'Only', 'Quickly', 'Turtles'};

    c_values(1) = compare_2(cats, audioIn);
    c_values(2) = compare_2(chase, audioIn);
    c_values(3) = compare_2(only, audioIn);
    c_values(4) = compare_2(quickly, audioIn);
    c_values(5) = compare_2(turtles, audioIn);

    [c_val, idx] = max(c_values);
    word = c_strings(idx);

end