clc
clear

N=8;                            % N Channels
n=log2(N);                      % N=2^n
A=[4 6 7 8];                    % information bit == message 
u_A=[1 1 0 1];                  % information vetor == mostly it is equal to the message positions 
AC=[1 2 3 5];                   % frozen bit == reliability sequance for N ==or it's called Q  
u_AC=[0 0 0 0];                 % frozen vector ==the principal idea of polar coding is putting the
                                % information bits on those "good" channels whose capacity tend to be 1
                                % and the frozen bits on the "bad" ones.
snr=6;
p_vec = 0:0.01:0.5;                  % prob of BSC flipping  
BER_vec  = zeros(size(p_vec)); 
%% Polar codes encoder
F=[1 0;1 1];                         %   F==G polar transformation kernal matrix
F_n=F;
    for i=1:(n-1)                    %   num of bits combined 
                                     %   this is the polar transformation because G = kron( A,B )
                                     %   returns the Kronecker tensor product of matrices A and B .
       F_n=kron(F_n,F);              %   If A is an m -by- n matrix and B is a p -by- q matrix, 
                                     %   then kron(A,B) is an m*p -by- n*q matrix formed by taking all possible
                                     %   products between the elements of A and the matrix B .
    end
I=eye(2^n);                           %   where eye(N) is the N-by-N identity matrix.
G_n=F_n;                              %   F==G polar transformation kernal matrix
u=u_A*I(A,:)+u_AC*I(AC,:);            %   u is the unencoded codeword to be compared with the received or decoded codeword u_e
x=mod(u_A*G_n(A,:)+u_AC*G_n(AC,:),2); % x is the encoded codeword

%% polar_code_channel
for p_index = 1:length(p_vec)
    
    %BSC with p prob of flipping
    x = BSChannel(x,p_vec(p_index)); 
    
    y=zeros(1,N);
    %  mapping (by using Binary PSK modulation)
    for i=1:N
        if(x(i)==0)
            y(i) = 1; % 0-->+1
       else
            y(i) = -1; % 1-->-1
        end
    end
    y =awgn(y,snr);                    % additive white gaussian noise
 %% Decoder 
u_e = polar_code_SC_decoder(n,N,y,AC); %  u_e: estimated codeword
 %% computing BER
    count=0;
    for i=1:length(u)                  %u is the un-encoded bit seq using polarization transformation encoding 

        if(u_e(i)~=u(i))
           count=count+1;    
        end
    end
    BER_vec(p_index)=count/length(u);
    
if(u==u_e)
    fprintf('Correct! your BER=%d when P=%d \n',BER_vec(p_index), p_vec(p_index));
else
    fprintf('some bits flipped & needed error correction,your BER=%d when P=%d \n',BER_vec(p_index), p_vec(p_index));
end
 
end

%%  Plotting the results
figure
plot(p_vec,BER_vec,'linewidth',2); hold on;
xlabel('Values of p','fontsize',15)
ylabel('BER','fontsize',15)
title('Polar Code')
grid on 
