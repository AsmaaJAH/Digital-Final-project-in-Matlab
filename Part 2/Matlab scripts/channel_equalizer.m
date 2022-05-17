clc
clear
close all

%% Generation of the Main Signal:
N=10000;
variance = 1e-15;                          %varince of second noise generator
M = 20;                                   %order of adaptive filter

%% BPSK Generation For Digital Signal:
% Converting Each Zero of the random signal to "-1"
x1 = randi([0 1],N,1);
for i = 1:N
    if x1(i) == 0
        x1(i) = -1;
    end
end

%% Generation of the noise signal.
second_generator = variance*(randn(N+1000,1) + 1i*randi(N+1000,1));
second_generator = second_generator(1001:N+1000);

%% Generation of the Multipath Channel:
l = 100;                            %Number of paths
% channel_matrix = MultipathChannel(l,N);
% Taking the first column of the channel matrix:
% h = channel_matrix(:,1);

% Another Channel:
n=0:l;
h=1./(1+(n-5).^2);

%% Paramaters for the weiner Solution:
% adding the effect of the Multipath:
u=conv(h,x1);
u=u(1:N);
% adding the generated noise:
% The input of the wiener filter:
u=u+second_generator;
% The desired output from the wiener filter:
% Calculating the delay:
delay = ((M-1)/2) + ((l-1)/2);
d=[zeros(delay,1) ;u];
d=d(1:N);

%% Reciever: 
% Wiener Filter to reduce the error of the multipath signal:
w_optimum_weiner = weiner(N,M,u,d);
%output for the reciever
z = (conv(w_optimum_weiner, u));
X_Estimated = zeros(l,1);
%Decision Maker 
for i=1:length(z)
    if z(i) > 0
        B =1; 
    else
        B=-1;
    end
    X_Estimated(i) = B;   %Estimated_Transmitted_signal
end

%% Bit error rate calculation:
BER = ComputeBER(x1,X_Estimated);

%% weight of the filter:
figure(1);
stem(w_optimum_weiner,'LineWidth',2,'color','black') ;hold on;
title('wieghts of the filters');

%% %%%%% frequency response %%%%%%%%%
% channel effect:
figure(2);hold on;freqz(h);
figure(2);hold on;freqz(w_optimum_weiner,1);
figure(2);hold on; freqz(w_optimum_weiner,1);

lines = findall(gcf,'type','line');
lines(1).Color = 'red';
lines(2).Color= 'black';
lines(2).LineStyle="-.";
lines(2).LineWidth= 2;
lines(3).Color='yellow';
lines(3).LineWidth=4;


%% weiner Function:
function w_optimum_weiner = weiner(N,M,u,d)
    p = zeros(M,1);                          
    r = zeros(M,1);
    for i = 0:M-1
        p(i+1) = mean(u(1:N-i).*d(i+1:N));   %get the cross correlation vector
        r(i+1) = mean(u(1:N-i).*u(i+1:N));   %get the auto correlation matrix
    end
    R = toeplitz(r);                         %fill the auto correlation matrix
    w_optimum_weiner = inv(R)*p;             %get the wiener filter weights
end

%% Compute the BER:
function BER = ComputeBER(bit_seq,rec_bit_seq)
    L = length(bit_seq);
    difference = 0;
    for i= 1:L
        if bit_seq(i) ~= rec_bit_seq(i)
            difference = difference + 1 ;
        end
    end
    BER = difference/L;
end

%% Mulipath another solution:
function channel_matrix = MultipathChannel(L,N)
    channel_matrix = zeros(L,L);
    channel_attenuator = abs(randn(1));

    for i =1:L
        for j = i:L
            channel_matrix(j,i) = exp(-(j-i)*10/N)*channel_attenuator;
        end 
    end
end