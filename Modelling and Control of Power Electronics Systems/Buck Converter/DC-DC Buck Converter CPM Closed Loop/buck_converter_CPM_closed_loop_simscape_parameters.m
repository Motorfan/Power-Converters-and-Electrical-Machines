Vg=5;
Vo=3.3;
Rload=3.7;
L=1e-6;
C=200e-6;
Resr=0.8e-3;
RL=15e-3;
D=Vo/Vg;
Io=Vo/Rload;
Rs=0.1;        % Current sensing resistance
fs=1e6;        % Switching frequency for the converter
Dmax=0.9;
Dmin=0;
Rin=10e6;
Vcmax=5;
Voffset=0;
Vcc=5;
H=0.6;


%% Bode plot for uncompensated loop

%Gvc=vo^/vc^=(1/Rf)*[Rload||(Resr+1/sC)]
%Tu=H*Gvc
s=tf('s')
Tu=(H/Rs)*[Rload*(Resr+1/(s*C))/(Rload+Resr+1/(s*C))]

bode(Tu)
hold on

% Implementing PI compensator for outer voltage loop:
% Gcv=Gcv0*((1+wz/s)/(1+s/wp))

fc=fs/10
fz=fc/2
fp=fs
wc=2*pi*fc;
wz=2*pi*fz;
wp=2*pi*fp;

% Gcv(s=wc)*Tu(s=wc)=1
Tuwc= abs((H/Rs)*[Rload*(Resr+1/(i*wc*C))/(Rload+Resr+1/(i*wc*C))])
Gcvwc=1/Tuwc;
Gcv0=Gcvwc/(abs(1+wz/(i*wc))*abs(1+(i*wz)/wp))
Gcv=tf([Gcv0,Gcv0*wz],[1/wp,1,0])

bode(Gcv)
hold on

T=Tu*Gcv;
bode(T)

legend('Tu','Gcv','T')

R1=1.2e3;
R2=Gcv0*R1
C2=1/(2*pi*R2*fz)
C3=1/(2*pi*R2*fp)

Rb=R1/(1-H)
Ra=(1/H-1)*Rb

% Adding artificial ramp for getting more stable waveforms:

m2=Vo/L
ma=m2;
Va=Rs*ma*(1/fs)