%% Simulation parameters
Pout =500;
fline=50;  %[line frequency in Hz]
Vp=3;      %[peak value of sawtooth waveforms in V]
%% Diode rectifier parameters
Cf=0.01e-6;
Vac=240;
Ron=1e-3;
Vf=0.7;
%% Boost converter parameters
Vg1=Vac*sqrt(2);
Vo1=400;
Rload1=Vo1^2/Pout;
L1=250e-6;
C1=220e-6;
D1=1-Vg1/Vo1;
VM=1/3;        % Voltage of PWM
Rs1=0.25;      % Current sensing resistance
fs1=1e5;       % Switching frequency for the converter
H1=1/100;      % Voltage sensing gain

%% Bode plot for uncompensated loop
Gid0=(2*Vo1)/((1-D1)^2*Rload1);
f0=(1-D1)/(2*pi*sqrt(L1*C1))
w0=2*pi*f0;
Q0=Rload1*(1-D1)*sqrt(C1/L1);
fz1=1/(pi*Rload1*C1)
wz1=2*pi*fz1;

% Gid=(iL^/d^)=(Gid0*(1+s/wz))/(1+s/(Q0*w0)+(s/w0)^2)
% Ti = Gid*(1/VM)*Rs = Gid

Gid= tf([Gid0/wz1,Gid0],[1/w0^2,1/(Q0*w0),1]);
figure(1)
bode(Gid)
hold on

% Implementing PI compensator for current loop:
% Gci=Gci0*(1+wzc/s)

fc1=fs1/10
fzc=fc1/5

wc1=2*pi*fc1;
wzc=2*pi*fzc;


% Gid(s=wc)*Gci(s=wc)=1
Gidwc=abs((Gid0*(1+(i*wc1)/wz1))/(1+(i*wc1)/(Q0*w0)+((i*wc1)/w0)^2));
Gciwc=1/Gidwc;
Gci0=Gciwc/abs(1+wzc/(i*wc1))
Gci=tf([Gci0,Gci0*wzc],[1,0]);

bode(Gci)
hold on

Tc=Gid*Gci;
bode(Tc)
hold on

% To design voltage compensator loop, closed-loop response should 
% approximately be:
% Tv=H*Gcv*(1/Rs)*(Gvd/Gid) 
% Uncompensated loop gain is
% Tvu=H*(1/Rs)*(Gvd/Gid)
% Gvd=(v^/d^)=(Gvd0*(1-s/wzv))/(1+s/(Q0*w0)+(s/w0)^2)
% Implementing PI comp. for voltage loop:
% Gcv= Gcv0*((1+wzo/s)

Gvd0=Vo1/(1-D1)
wzv=(((1-D1)^2)*Rload1)/L1;
fzv=wzv/(2*pi)

Gvd= tf([Gvd0/wzv,Gvd0],[1/w0^2,1/(Q0*w0),1]);
Tvu=H1*(1/Rs1)*(Gvd/Gid);
bode(Tvu)
hold on

% Tvu(s=wv)*Gcv(s=wv)=1

fv=fs1/100
wv=2*pi*fv;

Gvdwv=abs((Gvd0*(1+(i*wv)/wzv))/(1+(i*wv)/(Q0*w0)+((i*wv)/w0)^2));
Gidwv=abs((Gid0*(1+(i*wv)/wz1))/(1+(i*wv)/(Q0*w0)+((i*wv)/w0)^2));
Tvuwv=H1*(1/Rs1)*(Gvdwv/Gidwv);
Gcvwv=1/Tvuwv;

fzo=fv/3
wzo=2*pi*fzo;


Gcv01=Gcvwv/abs(1+wzo/(i*wv))
Gcv1=tf([Gcv01,Gcv01*wzo],[1,0]);

bode(Gcv1)
hold on

Tv=Tvu*Gcv1;
bode(Tv)

legend('Gid','Gci','Tc','Tvu','Gcv1','Tv')

%% DC transformer parameters
V1dc=400;
V2dc=48;
n=V1dc/V2dc

%% Buck converter parameters
Vg=48;
Vo=12;
L=45e-6;
C=680e-6;
RL=15e-3;
Resr=0.5e-3
D=Vo/Vg;
Io=Pout/Vo
Rload=Vo/Io
Rs=0.1;        % Current sensing resistance
fs=200e3;      % Switching frequency for buck converter
Dmax=0.9;
Dmin=0;
Vcmax=12;
Voffset=0;
Vcc=12;       %[Op-amp supply voltage in V]
H=0.6;        % Voltage sensing gain


%% Bode plot for uncompensated loop

%Gvc=vo^/vc^=(1/Rf)*[Rload||(Resr+1/sC)]
%Tu=H*Gvc
s=tf('s')
Tu=(H/Rs)*[Rload*(Resr+1/(s*C))/(Rload+Resr+1/(s*C))]
figure(2)
bode(Tu)
hold on

% Implementing PI compensator for outer voltage loop:
% Gcv=Gcv0*(1+wz/s)

fc=fs/100
fz=fc/50

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
ma=m2;           %[Artificial ramp]
Va=Rs*ma*(1/fs)  %[Peak value for artificial ramp in V]