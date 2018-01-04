Vg=200;
Vo=500;
Io=30;
L=150e-6;
C=500e-6;
D=1-Vg/Vo;
Rload=Vo/Io;
VM=1;        % Voltage of PWM
Rs=1;        % Current sensing resistance
fs=20e3;     % Switching frequency for the converter
H=1/100;     % Voltage sensing gain

%% Bode plot for uncompensated loop
Gid0=(2*Vo)/((1-D)^2*Rload);
f0=(1-D)/(2*pi*sqrt(L*C))
w0=2*pi*f0;
Q0=Rload*(1-D)*sqrt(C/L);
fz=1/(pi*Rload*C)
wz=2*pi*fz;

% Gid=(iL^/d^)=(Gid0*(1+s/wz))/(1+s/(Q0*w0)+(s/w0)^2)
% Ti = Gid*(1/VM)*Rs = Gid

Gid= tf([Gid0/wz,Gid0],[1/w0^2,1/(Q0*w0),1]);
%bode(Gid)

% Implementing PI compensator for current loop:
% Gci=Gci0*((1+wzc/s)/(1+s/wpc))

fc=fs/10
fzc=fc/5
fpc=5*fc
wc=2*pi*fc;
wzc=2*pi*fzc;
wpc=2*pi*fpc

% Gid(s=wc)*Gci(s=wc)=1
Gidwc=abs((Gid0*(1+(i*wc)/wz))/(1+(i*wc)/(Q0*w0)+((i*wc)/w0)^2));
Gciwc=1/Gidwc;
Gci0=Gciwc/(abs(1+wzc/(i*wc))*abs(1+(i*wzc)/wpc))
Gci=tf([Gci0,Gci0*wzc],[1/wpc,1,0]);

R1=10e3;
R2=Gci0*R1
C2=1/(2*pi*R2*fzc)
C3=1/(2*pi*R2*fpc)

%bode(Gci)
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
% Gcv= Gcv0*((1+wzo/s)/(1+s/wpo))

Gvd0=Vo/(1-D)
wzv=(((1-D)^2)*Rload)/L;
fzv=wzv/(2*pi)

Gvd= tf([Gvd0/wzv,Gvd0],[1/w0^2,1/(Q0*w0),1]);
Tvu=H*(1/Rs)*(Gvd/Gid);
%bode(Tvu)

% Tvu(s=wv)*Gcv(s=wv)=1

fv=fs/100
wv=2*pi*fv;

Gvdwv=abs((Gvd0*(1+(i*wv)/wzv))/(1+(i*wv)/(Q0*w0)+((i*wv)/w0)^2));
Gidwv=abs((Gid0*(1+(i*wv)/wz))/(1+(i*wv)/(Q0*w0)+((i*wv)/w0)^2));
Tvuwv=H*(1/Rs)*(Gvdwv/Gidwv);
Gcvwv=1/Tvuwv;

fzo=fv/3
fpo=3*fv
wzo=2*pi*fzo;
wpo=2*pi*fpo;

Gcv0=Gcvwv/abs((1+wzo/(i*wv))/(1+(i*wv)/wpo))
Gcv=tf([Gcv0,Gcv0*wzo],[1/wpo,1,0]);

R1v=500;
Ra=R1v/H
Rb=(H/(1-H))*Ra
R2v=Gcv0*R1v
C2v=1/(2*pi*R2v*fzo)
C3v=1/(2*pi*R2v*fpo)

%bode(Gcv)

Tv=Tvu*Gcv;
bode(Tv)






