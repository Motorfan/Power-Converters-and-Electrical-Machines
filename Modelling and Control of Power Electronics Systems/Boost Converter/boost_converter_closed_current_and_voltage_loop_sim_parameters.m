Vg=200;
Vo=500;
Io=30;
L=150e-6;
C=500e-6;
D=1-Vg/Vo;
Rload=Vo/Io;
VM=1;        % Voltage of PWM
Rs=1;        % Current sensing resistance
fs=20e3;
H=1/100;
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
% Implementing PI compensator
% Gci=Gci0*(1+wzc/s)
fc=fs/10
fzc=fc/5
wc=2*pi*fc;
wzc=2*pi*fzc;
% Gid(s=wc)*Gci(s=wc)=1
Gidwc=abs((Gid0*(1+(i*wc)/wz))/(1+(i*wc)/(Q0*w0)+((i*wc)/w0)^2));
Gciwc=1/Gidwc;
Gci0=Gciwc/abs(1+wzc/(i*wc))
Gci=tf([Gci0,Gci0*wzc],[1,0]);
%bode(Gci)
Tc=Gid*Gci;
bode(Tc)
hold on
% To design voltage compensator loop, closed-loop response should 
% approximately be
% Tv=H*Gcv*(1/Rs)*(Gvd/Gid) 
% Uncompensated loop gain is
% Tvu=H*(1/Rs)*(Gvd/Gid)
% Gvd=(v^/d^)=(Gvd0*(1-s/wzv))/(1+s/(Q0*w0)+(s/w0)^2)
% Implementing PI comp. for voltage loop:
% Gcv= Gcv0*(1+wzo/s)
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
wzo=2*pi*fzo;
Gcv0=Gcvwv/abs(1+wzo/(i*wv))
Gcv=tf([Gcv0,Gcv0*wzo],[1,0]);
%bode(Gcv)
Tv=Tvu*Gcv;
bode(Tv)






