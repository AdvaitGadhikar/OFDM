function [pm, t] = phasemod(data,fc,freqdev,fs)


N = numel(data)
Am = max(abs(data))
kp = 2*pi*freqdev/Am

t = 0:1/fs:(N-1)/fs
pm = cos(2*pi*fc*t + kp*data)
