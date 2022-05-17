function bit_seq = GenerateBits(N_bits)
%
% Inputs:
%   N_bits:     Number of bits in the sequence
% Outputs:
%   bit_seq:    The sequence of generated bits
%
% This function generates a sequence of bits with length equal to N_bits
%%% WRITE YOUR CODE HERE
x = rand(1, N_bits+200);
bit_seq = round(x(201:N_bits+200));
%%%
end
