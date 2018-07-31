clc
clear all

n = 4096
N = 512

data = randi([0 1], 1, n)
% data = audioread('sa1.wav')
data = ones(32,1) * data
data_addedsamples = data(:)
num = numel(data_addedsamples)
data_real = data_addedsamples(1:2:num)
data_imaginary = data_addedsamples(2:2:num)
% data_imaginary = [data_imaginary; zeros(1,1) ]
qam_data = (((2.*data_real) - 1) + ((2.*data_imaginary)-1).*j)'

% qam_data = [qam_data , zeros(1,25)]
num1 = numel(qam_data)

% % now we generate the ifft matrix
ifft_matrix = ones(16,16)
Wn = exp(-j*2*pi/16)
% % Defining the IFFT matrix to be used instead of the IFFT command 
for p = 2:16
    for q = 2:16
        ifft_matrix(p,q) = (Wn')^((p-1)*(q-1))
    end
end
% ifft_matrix = (1/16).*ifft_matrix
% % now we convert the data from serial to parallel
% for i = 1:64
%     block(i,:) = qam_data(16*(i-1) + 1 : 16*i)
% end

block = (reshape(qam_data,[num1/16 16]))'

ofdm_block = ifft_matrix*block
% % now we reshape the matrix to get the modulated data stream

ofdm_stream = (ofdm_block(:))'
num2 = numel(ofdm_stream)
t1 = 1:1:num2
figure
plot(t1,ofdm_stream,'blue')
hold on

a = max(real(ofdm_stream))
b = min(real(ofdm_stream))
points = numel(ofdm_stream);

average_power = (1/points)*(sum(real(ofdm_stream).^2));
peak_value = a.^2;
papr = peak_value/average_power


peak_pulse = max(abs(ofdm_stream));

% normalized_stream = (ofdm_stream)./(peak_pulse)
% % quantiaztion
% n = 5
% 
% temp = (round(normalized_stream.*(2^n)))./(2^n)
% % temp = quantize(ofdm_stream,int, 16)
% plot(t,temp,'red')


% average_power2 = (1/points)*(sum(real(temp).^2))
% peak_value2 = a.^2
% papr2 = peak_value2/average_power2


% % % add cyclic prefix

% % compare spectral efficiency of FM and PM for ce ofdm

% % now we implement ce ofdm using Frequency Modulation


% % FM modulation centre frequency = 2.4GHz
% % Frequency deviation 20MHz pk to pk

% sample code for FM modulation

% % [fm t2] = freqmod(real(ofdm_stream),2.4e9,20e6,38.4e9)

fm = fmmod(real(ofdm_stream) ,2.4e9,2.4e11,4e9)

t2 = 0:(1/1000):((numel(fm)-1)/1000)

% fm = fmmod(real(ofdm_stream), 2.4e9, 4.8e9, 10e6);

figure
plot(t2,abs(fm))
title('FM Signal')
hold on

% Now we will plot the frequency spectrum of the FM signal

% freq_spectrum_fm = abs(fftshift(fft(fm)))
% freq_bins = [0 : numel(fm)-1]
% N_2 = ceil(numel(fm)/2)
% freq_hz = (freq_bins - N_2)*fs/(numel(fm))
% figure('Name','Frequency Spectrum of FM Signal')
% plot(freq_hz,freq_spectrum_fm)

freq_spectrum_fm = fft(fm)
N = numel(freq_spectrum_fm)
figure
plot(0:N-1 , abs(freq_spectrum_fm))
title('FM frequency spectrum')


% now we shall do phase modulation

[pm t3] = phasemod(real(ofdm_stream),2.4e9,2.4e11,4.8e9)
figure
plot(t3,abs(pm))
title('PM Signal')
hold on

freq_spectrum_pm = fft(pm)
N = numel(freq_spectrum_pm)
figure
plot(0:N-1 , abs(freq_spectrum_pm))
title('PM frequency spectrum')








