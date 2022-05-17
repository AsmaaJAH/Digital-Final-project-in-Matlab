function AWGN_out = out(sgn,drtn)
AWGN_out=zeros(size(sgn));
n=1;
for i= drtn/2:drtn:length(sgn)
 if( sgn(1,i)>= 0 )
 AWGN_out(n)=1;
 else
 AWGN_out(n)=0; 
 end
 n=n+1;
end