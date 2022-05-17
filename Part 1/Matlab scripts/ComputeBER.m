function BER = ComputeBER(bit_seq,rec_bit_seq)
E=0;
N = length ( bit_seq );
for i = 1:1: N 
   if  bit_seq (i) ~= rec_bit_seq (i) 
       E=E+1;
   end 
end
BER = E / N ;
end