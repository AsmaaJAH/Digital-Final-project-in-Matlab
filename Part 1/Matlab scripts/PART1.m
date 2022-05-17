close all
clc
fs = 100*(10^5);
ts = 1/ fs ;
B = 100 * 1000;
T = 2/B;
drtn = T*fs;
drtn = cast(drtn,'uint32');
%all = drtn*2
t_axis = linspace(0,2*T,drtn*2);
f_axis = linspace(-.5*fs ,.5*fs,2*drtn);
%% Generate pulses 
%first pulse 
square1=[zeros(1,drtn) ones(1,drtn)];
%second pulse
square2=[ones(1,drtn) zeros(1,drtn)];

figure;
subplot(3,1,1)
plot(t_axis ,square1,'linewidth',2)
hold on 
plot(t_axis ,square2,'linewidth',2)
title('The square pulses in time domain');
legend('Pulse 1','Pulse 2');
%% Frequancy response of square pulses
square1_freq = fftshift(fft(square1));
square2_freq = fftshift(fft(square2));

subplot(3,1,2)
plot(f_axis,abs(square1_freq),'linewidth',2);
hold on 
plot(f_axis ,abs(square2_freq),'linewidth',2);
xlim([-1000000,1000000])
title('The square pulses in time domain');
legend('Pulse 1','Pulse 2');
%% Band limited channel
%frequency
drtn = cast(drtn,'double');
valueOfOneSample=2*drtn*(ts);
numb_of_zeros = (fs/2- B)*valueOfOneSample;
numb_of_zeros = cast(numb_of_zeros,'uint32');
limited_channel_freq = [zeros( 1, numb_of_zeros) (ones(1,2*drtn-2*numb_of_zeros))  zeros( 1, numb_of_zeros) ];

subplot(3,1,3)
plot(f_axis ,limited_channel_freq,'linewidth',2)
xlim([-1000000,1000000])
title('The band limited channel in frequency domain');
%% Passing the pulses to the the band limitted channel
%time domain
out_square1_freq = square1_freq.* limited_channel_freq ;
out_square2_freq = square2_freq.* limited_channel_freq ;

%frequency domain
out_square1 = real(ifft(ifftshift(out_square1_freq )));
out_square2 = real(ifft(ifftshift(out_square2_freq))) ;

figure;
subplot(2,1,1)
plot(t_axis,out_square1,'linewidth',2);
hold on 
plot(t_axis ,out_square2,'linewidth',2);
title('The square pulses after band limitted channel in time domain');
legend('Pulse 1','Pulse 2');

subplot(2,1,2)
plot(f_axis,abs(out_square1_freq),'linewidth',2);
hold on 
plot(f_axis ,abs(out_square2_freq),'linewidth',2)
xlim([-1000000,1000000])
title('The square pulses after band limitted channel in frequency domain');
legend('Pulse 1','Pulse 2');
%% For zero ISI generating pulses
%sinc or triangle
%time domain
sinc_siganl = sinc((t_axis.*B));
n=length(sinc_siganl);
sinc_siganl1= sinc_siganl;
sinc_siganl2= [zeros(1,200) sinc_siganl(1:n-200) ];

figure;
subplot(3,1,1)
plot(t_axis , sinc_siganl1,'linewidth',2 )
hold on
plot(t_axis , sinc_siganl2,'linewidth',2 )
title('The pulses for zero ISI in time domain');
legend('Pulse 1','Pulse 2');


%frequancy domain
sinc_siganl1_freq = fftshift(fft(sinc_siganl1));
sinc_siganl2_freq = fftshift(fft(sinc_siganl2));

subplot(3,1,2)
plot(f_axis , abs(sinc_siganl1_freq),'linewidth',2 )
hold on
plot(f_axis , abs(sinc_siganl2_freq),'linewidth',2 )
xlim([-1000000,1000000]);
title('The pulses for zero ISI in frequency domain');
legend('Pulse 1','Pulse 2');

subplot(3,1,3)
plot(f_axis ,limited_channel_freq,'linewidth',2)
xlim([-1000000,1000000])
title('The band limited channel in frequency domain');
%% After band channel for zero ISI
%frequency domain
out_sinc_siganl1_freq = sinc_siganl1_freq .* limited_channel_freq;
out_sinc_siganl2_freq = sinc_siganl2_freq .* limited_channel_freq;
%time domain
out_sinc_siganl1 = real(ifft(ifftshift(out_sinc_siganl1_freq )));
out_sinc_siganl2 = real(ifft(ifftshift(out_sinc_siganl2_freq))) ;

figure;
subplot(2,1,1)
plot(t_axis,out_sinc_siganl1,'linewidth',2);
hold on 
plot(t_axis ,out_sinc_siganl2,'linewidth',2);
title('The pulses for zero ISI after band limitted channel in time domain');
legend('Pulse 1','Pulse 2');

subplot(2,1,2)
plot(f_axis,abs(out_sinc_siganl1_freq),'linewidth',2);
hold on 
plot(f_axis ,abs(out_sinc_siganl2_freq),'linewidth',2)
title('The pulses for zero ISI after band limitted channel in frequency domain');
legend('Pulse 1','Pulse 2');
%% Adding additive white gaussian noise to pulses for zero ISI
%time domain
pulse1_noise = Computenoise(out_sinc_siganl1,drtn);
pulse2_noise = Computenoise(out_sinc_siganl2,drtn);

figure;
subplot(2,1,1)
plot(t_axis,pulse1_noise,'linewidth',2);
hold on 
plot(t_axis,pulse2_noise,'linewidth',2);
title('The pulses for zero ISI after band limitted channel with AWGN in time domain');
legend('Pulse 1','Pulse 2');

%frequency domain
pulse1_noise_freq = fftshift(fft(pulse1_noise));
pulse2_noise_freq = fftshift(fft(pulse2_noise));

subplot(2,1,2)
plot(f_axis,abs(pulse1_noise_freq),'linewidth',2);
hold on 
plot(f_axis,abs(pulse2_noise_freq),'linewidth',2);
xlim([-10^6,10^6]);
title('The pulses for zero ISI after band limitted channel with AWGN in frequency domain');
legend('Pulse 1','Pulse 2');
%% Computing BER
%BER for the pulses with zero ISI
fprintf('BER for the pulses with zero ISI is : ');
AWGN_out3 = out(pulse1_noise,drtn);
AWGN_out4 = out(pulse2_noise,drtn);
BER_pulse1 = ComputeBER(AWGN_out3,sinc_siganl1)
BER_pulse2 = ComputeBER(AWGN_out4,sinc_siganl2)