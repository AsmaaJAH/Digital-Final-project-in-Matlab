clear;clc;
%% Comparisons of coding techniques
%% Data bits
N_bits = 1024; % Total number of bits
% Generate a sequence of bits equal to the total number of bits
bit_seq = GenerateBits(N_bits);
%% repetation
% Number of samples per symbol (bit)
fs  = 2;    
sample_seq = GenerateSamples(bit_seq,'part_1',fs); 
%% convolution 
%generative polynomial
%gp= [1 1 1;
 %     1 0 1
  %    0 1 1];
  gp = [1 1 1;
      1 0 1];
sample_seq_2 = GenerateSamples(bit_seq,'part_2',gp);
%% ===channel effect=== decodeing  
%%BER change with diffrent BSC crossover probability using diffrent channel codes   
p_vect          = 0:0.1:0.5;  
% Use this vector to extract different values of p in your code
BER_case_1_vec  = zeros(size(p_vect));  
BER_case_2_vec  = zeros(size(p_vect));  

for p_ind = 1:length(p_vect)
    rec_sample_seq = BSC(sample_seq,p_vect(p_ind));
    rec_bit_seq = DecodeBitsFromSamples(rec_sample_seq,'part_1',fs);
    BER_case_1_vec(p_ind) = ComputeBER(bit_seq,rec_bit_seq);
    
    rec_sample_seq_2 = BSC(sample_seq_2,p_vect(p_ind));
    rec_bit_seq_2 = DecodeBitsFromSamples(rec_sample_seq_2,'part_2',gp);
    BER_case_2_vec(p_ind) = ComputeBER(bit_seq,rec_bit_seq_2); 
end
plot(p_vect,BER_case_1_vec,'o-r','linewidth',2); hold on;
plot(p_vect,BER_case_2_vec,'o-b','linewidth',2); hold on;

xlabel('Values of p','fontsize',10)
ylabel('BER','fontsize',10)
legend('repetation','convolution','polar','fontsize',10)
grid on