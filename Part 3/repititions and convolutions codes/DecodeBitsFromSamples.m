function rec_bit_seq = DecodeBitsFromSamples(rec_sample_seq,case_type,fs)
%
% Inputs:
%   rec_sample_seq: The input sample sequence to the channel
%   case_type:      The sampling frequency used to generate the sample sequence
%   fs:             Number of samples per bit
% Outputs:
%   rec_sample_seq: The sequence of sample sequence after passing through the channel
%
% This function takes the sample sequence after passing through the
% channel, and decodes from it the sequence of bits based on the considered
% case and the sampling frequence
if (nargin <= 2)
    fs = 1;
end
switch case_type

    case 'part_1'
        num_ones=1;
        num_zeros=1;
        for i=1 : (length(rec_sample_seq)/fs)
            for x=1 : fs
                if rec_sample_seq(i*fs-x+1)==1
                    num_ones=num_ones+1;
                else
                    num_zeros=num_zeros+1;
                end
            end
        if num_ones >= num_zeros
            rec_bit_seq(i)=1;
        else
            rec_bit_seq(i)=0;
        end
        num_ones=1;
        num_zeros=1;
        end
  %%%      
%%convolution decoder
    case 'part_2'
        %----------Get r and K and the basic constants---------------
        [r,K] = size(fs);
        len = length(rec_sample_seq);
        n_registers=K-1; 
        n_states = 2^n_registers;

        %--------- Generate the viterbi table for path metric-----------
         table = cell(n_states,1+len/r);
         table(:,:) = num2cell(inf); 
         table{1,1} = 0; % first initialization (Path metric)

        %---------- Filling the viterbi table---------------------------
         for col = 1:len/r
             %Update the word to be compared..
             word = rec_sample_seq(col*r-r+1:col*r);
             for index=1:n_states
                  state = flip(de2bi(index-1,n_registers));
                   for i=0:1
                   new_state = [i state];
                   temp = GenerateSamples(flip(new_state),'part_2',fs); 
                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   state_out = temp(end-r+1:end);
                       % Calculate the hamming distance
                   col2go = col+1;
                   row2go=bi2de(flip(new_state(1:end-1)))+1;
                   acc_ham_distance = sum(state_out ~= word) + table{index,col};
                   table{row2go,col2go}= min(table{row2go,col2go},acc_ham_distance);
                   end
             end
         end

        %--------------Get the bits correspond to the optimum path generated-----
        %output_bits = viterbi_backward_bits(table,n_registers);

        table = cell2mat(table);
        [rows,cols]= size(table);

        rec_bit_seq = [];
        prev_state_indecies = linspace(1,rows,rows);              
        for i = cols:-1:2
            %Get the minimum value index within the possible stream indeices
        [~,index] = min(table(prev_state_indecies,i));  
            % Map the minimum index to the exact index in the whole table
        index = prev_state_indecies(index);
             % Figure out the state which path metric is the chosen minimum one.
        current_state = flip(de2bi(index-1,n_registers));
             % Concatenate the discovered bit, according to the current state.
        rec_bit_seq = cat(2,current_state(1),rec_bit_seq);
             % Decide the possible previous states
        prev_states = bi2de([0 current_state(n_registers);
                             1 current_state(n_registers)]);
             % Convert the possible states numbers to MATLAB indecies
        prev_state_indecies = prev_states + 1;
        end
  
end