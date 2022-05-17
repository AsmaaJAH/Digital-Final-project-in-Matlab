function AWGN = Computenoise(sig,drtn)
No=1;
AWGN= sig + sqrt((No/2))*randn(1,length(sig));
