f = 10000;
SampleRate = 48e3;
playDuration = 3;

time = (0:1/SampleRate:playDuration-1/SampleRate)';
x = sin(time*2*pi*f);

spectro(x, SampleRate);