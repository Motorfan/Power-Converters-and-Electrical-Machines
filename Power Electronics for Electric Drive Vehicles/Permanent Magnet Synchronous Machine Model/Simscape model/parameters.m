P=8; %(pole number)
Tmref=240;
lambda_m=0.125;
r=0.08;
L=0.5e-3;
Vdc=500;
wr=100*pi*(2/P);

% Equations for permanent magnet synchronous machine (PMSM)
% Vq = Vqref+w_r*L*id+lambda_m*w_r
% Vd = Vdref-w_r*L*iq
% Vqref =(r+s*L)*iq
% Vdref =(r+s*L)*id
% Giv=i^/V^ =1/(r+s*L)
s=tf('s');
Giv=1/(r+s*L);
wp=r/L
bode(Giv)
hold on
% Designing PI compensator to control voltage & current in q-d axis
% Gci= Kp+Ki/s = Kp*(1+(Ki/Kp)/s)
% wz=Ki/Kp
% Gci= Kp+Ki/s
wz=wp
% fc=10Hz
% Gci(f=1kHz)*Giv(f=1kHz)=1
% (To reduce amount of ripples for electromagnetic torque, q-d axis current
% (etc. the desired cut of frequency is increased from 10Hz to 1kHz)
Givabs= abs(1/(r+(2*pi*1000)*L))
Gciabs= 1/Givabs
Kp= Gciabs/abs(1+wz/(2*pi*1000))
Gci= Kp*(1+wz/s);
%bode(Gci)
hold on

T=Giv*Gci;
bode(T)
