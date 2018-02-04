Vg=48;
Vo=12;
Pout=500;
Io=Pout/Vo
Rload=Vo/Io
L=45e-6;
C=680e-6;
Resr=0.8e-3;
RL=15e-3;
D=Vo/Vg;
Io=Vo/Rload;
Rs=0.1;        % Current sensing resistance
fs=200e3;        % Switching frequency for the converter
Dmax=0.9;
Dmin=0;
H=0.6;
Vcc=5;
Vcmax=Vcc;
Voffset=0;

%% Bode plot for uncompensated loop

%Gvc=vo^/vc^=(1/Rf)*[Rload||(Resr+1/sC)]
%Tu=H*Gvc
s=tf('s')
Tu=(H/Rs)*[Rload*(Resr+1/(s*C))/(Rload+Resr+1/(s*C))]

bode(Tu)
hold on

% Implementing PI compensator for outer voltage loop:
% Gcv=Gcv0*(1+wz/s)

fc=fs/10
fz=fc/2

wc=2*pi*fc;
wz=2*pi*fz;


% Gcv(s=wc)*Tu(s=wc)=1
Tuwc= abs((H/Rs)*[Rload*(Resr+1/(i*wc*C))/(Rload+Resr+1/(i*wc*C))])
Gcvwc=1/Tuwc;
Gcv0=Gcvwc/abs(1+wz/(i*wc))
Gcv=tf([Gcv0,Gcv0*wz],[1,0])

bode(Gcv)
hold on

T=Tu*Gcv;
bode(T)

legend('Tu','Gcv','T')



% Adding artificial ramp for getting more stable waveforms:

m2=Vo/L
ma=m2;
Va=Rs*ma*(1/fs)