function [u_e] = polar_code_SC_decoder(n,N,y,AC)
%   n: number of level
%   N: length of codeword
%   y: undecoded codeword
%   AC: frozen bit
%   stage: current processing stage
%   LLR: log-likelihood ratio
%   HB: estimated hard bits
%   u_e: estimate of codeword

    %   initializing the log-likelihood ratio 
    LLR = zeros([N,n+1]);
    LLR(:,1) = y;  

    %polar_code_initializing_HardBit
    HardBits = zeros(N,n+1);
    for i=1:N
        if(LLR(i,1)>=0)
            HardBits(i,1) = 0;
        else
            HardBits(i,1) = 1;
        end
    end


    for stage=1:n
        % Calculate alpha_left
        % polar_code_updateLLR_Left   
        Ns = 2^(n-stage+1);
        for j=1:Ns:N
            for i=j:j+Ns/2-1
                p = LLR(i,stage); %alpha_i
                q = LLR(i+Ns/2,stage); %alpha_(i+Ns/2)
                LLR(i,stage+1) = sign(p)*sign(q)*min([abs(p),abs(q)]);
            end
        end
        
        
        %polar_code_updateHB_L
        %Calculate beta_left
        Ns = 2^(n-stage+1);
        for j=1:Ns:N
            for i=j:j+Ns/2-1
                if(stage==n&&ismember(i,AC))
                    HardBits(i,stage+1) = 0;
                elseif(LLR(i,stage+1)>=0)
                    HardBits(i,stage+1) = 0;
                else
                    HardBits(i,stage+1) = 1;
                end
            end
        end
        
        
        %polar_code_updateLLR_R 
        % Calculate alpha_right
        Ns = 2^(n-stage+1);
        for j=1:Ns:N
            for i=j:j+Ns/2-1
                p = LLR(i,stage); %alpha_i
                q = LLR(i+Ns/2,stage); %alpha_(i+Ns/2)
                LLR(i+Ns/2,stage+1) = (1-2*HardBits(i,stage+1))*p+q;
            end
        end
        
        %HardBits = polar_code_updateHB_R    
        %Calculate beta_right
        Ns = 2^(n-stage+1);
        for j=1:Ns:N
            for i=j+Ns/2:j+Ns-1
                if(stage==n&&ismember(i,AC))
                    HardBits(i,stage+1) = 0;
                elseif(LLR(i,stage+1)>=0)
                    HardBits(i,stage+1) = 0;
                else
                    HardBits(i,stage+1) = 1;
                end
            end
        end  
    end
    u_e = HardBits(:,n+1)';
end

