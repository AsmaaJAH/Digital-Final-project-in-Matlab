function sample_seq = GenerateSamples(bit_seq,case_type,fs)
%
% Inputs:
%   bit_seq:    Input bit sequence
%   fs:         additional var 
% Outputs:
%   sample_seq: The resultant sequence of samples
%
% This function takes a sequence of bits and generates a sequence of
% samples as per the input number of samples per bit

switch case_type
    case 'part_1'
        sample_seq = zeros(1,length(bit_seq)*fs);
        for i=1 : length(bit_seq)
            for j=1 : fs
                sample_seq(i*fs-j+1) = bit_seq(i);
            end 
        end
        
    case 'part_2'
        gp=fs;
        [r,K] = size(gp);
        bit_seq = [zeros(1,K-1) bit_seq]; 
        sample_seq = [];
         %----------- The algorithm steps ------------
        for n=K:length(bit_seq)
             for i=1:r
               g = gp(i,:); 
               temp = g.*bit_seq(n-K+1:n);
               tt=temp(1);
               for i=2:length(temp);
                   tt=xor(tt,temp(i));
               end
               sample_seq = [sample_seq tt];
             end
        end
end