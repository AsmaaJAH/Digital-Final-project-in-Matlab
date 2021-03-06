function BER = ComputeBER(bit_seq,rec_bit_seq)
%
% Inputs:
%   bit_seq:     The input bit sequence
%   rec_bit_seq: The output bit sequence
% Outputs:
%   BER:         Computed BER
%
% This function takes the input and output bit sequences and computes the
% BER

%%% WRITE YOUR CODE HERE
l = length(bit_seq);
e_samples=0;
for i=1 : l
        if  bit_seq(i) ~= rec_bit_seq(i)
            e_samples = e_samples +1;
        end
end
BER = e_samples/l;
%%%
%%%
