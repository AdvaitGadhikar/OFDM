function [fm, t] = freqmod(data,fc,freqdev,fs)


N = numel(data)
Am = max(abs(data))
kf = 2*pi*freqdev/Am
integral_data = cumsum(data)
t = 0:1/fs:(N-1)/fs
fm = cos(2*pi*fc*t + kf*integral_data)


