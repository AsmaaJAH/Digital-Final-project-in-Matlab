%% part-2 Inter-Symbol Interference due to multi-path channels
L = 100;                   %No of paths
S = randsrc(L,1,[0,1]); 
A=length(S);

for i= 1 : length(S) 
    if S(i) == 0
        S(i)= -1;
    end
end

%% generation Matrix of channel coeffients:
h = MultipathChannel(L,1);
H = tril(toeplitz(h));
V = H * S;
Eb_No_db = 0;       % The specified Eb/No value in dB
Energy_per_bit = 1;
No = Energy_per_bit/( 10^(Eb_No_db/10));
noise= randn(size(V))*sqrt(No/2); %generate Noise
Y = (H * S) + noise ; %getting the received signal Y

%% Estimation of transmitted signal from Received signal
Z= inv(H); %Equalize channel effect
X= Z * Y;  
X_Estimated = zeros(l,1);
%Decision Maker 
for i=1:length(S)
    if X(i) > 0
        B =1; 
    else
        B=-1;
    end
    X_Estimated(i) = B;   %Estimated_Transmitted_signal
end

BER = ComputeBER(S, X_Estimated);
%% Estimation of BER vs Eb/No
Eb_No_dB_vector = -30:1.5:0;
BER1=zeros(size(Eb_No_dB_vector));
for i= 1:length(Eb_No_dB_vector)
    for k=1:5 
        No=Energy_per_bit/( 10^(Eb_No_dB_vector(i)/10) );
        noise= randn(size(V))*sqrt(No/2);
        Y = (H * S) + noise ;
        Z= inv(H);
        X= Z * Y;
        X_Estimated = zeros(l,1);
        for j=1:A
            if X(j) > 0
                B =1; 
            else
                B =-1;
            end
            X_Estimated(j) = B;
        end

        yy(k)= ComputeBER(S, X_Estimated);
    end
    BER1(i) = sum(yy)/k;
end
%Plotting BER vs Eb/No
figure();
semilogy(Eb_No_dB_vector,BER1,'-xk');
xlabel('Eb/No');
ylabel('BER');

%% Multipath Channel:
function h = MultipathChannel(L,N)
    if nargin < 2
        N = 1;
    end
    h = randn(L,N) + 1i*randn(L,N);
    power_profile = exp(-0.5*[0:L-1])';
    power_profile = repmat(power_profile,1,N);
    h = abs(h).*power_profile;
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
