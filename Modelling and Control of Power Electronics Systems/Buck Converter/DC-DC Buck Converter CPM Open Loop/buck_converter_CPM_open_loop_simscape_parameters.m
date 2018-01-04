Vg=5;
Vo=2;
Rload=0.4;
L=1e-6;
C=200e-6;
Resr=0.8e-3;
RL=15e-3;
D=Vo/Vg;
Io=Vo/Rload;      
Rs=0.3;          % Current sensing resistance
fs=1e6;          % Switching frequency for the converter
Dmax=0.9;
Dmin=0;
iLmax=5;
Vc=Rs*iLmax;
Rin=10e6;   
H=0.6;


%% Bode plot for uncompensated loop

%Gvc=vo^/vc^=(1/Rf)*[Rload||(Resr+1/sC)]
%Tu=H*Gvc
s=tf('s')
Tu=(H/Rs)*[Rload*(Resr+1/(s*C))/(Rload+Resr+1/(s*C))]

bode(Tu)
legend('y = Tu')




