function rec_encoded_seq  = BSChannel(encoded_seq,p)
%
% Inputs:
%   encoded_seq:     The input  sequence to the channel
%   p:               The bit flipping probability
% Outputs:
%   rec_encoded_seq: The sequence after passing through the channel
%
% This function takes the encoded sequence passing through the channel, and
% generates the output sequence 
encoded_seq      = ~~encoded_seq;
rec_encoded_seq  = zeros(size(encoded_seq));
rec_encoded_seq  = ~~rec_encoded_seq;
 
channel_effect = rand(size(rec_encoded_seq))<=p;

rec_encoded_seq = xor(encoded_seq,channel_effect);
rec_encoded_seq = rec_encoded_seq + 0;