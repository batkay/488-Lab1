f = 10000;
SampleRate = 48e3;
playDuration = 3;

time = (0:1/SampleRate:playDuration-1/SampleRate)';
x = chirp(time,10,3,20000, 'quadratic');

% x = sin(time*2*pi*f);
spectro(x, SampleRate);