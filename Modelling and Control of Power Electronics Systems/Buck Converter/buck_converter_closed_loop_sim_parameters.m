Vg=12;
L=4.1e-6;
C=376e-6
RL=80e-3;
Resr=5e-3
D=0.42;
Rload=1;

%% Bode plot and feedback controller parameters (Neglecting RL and Resr values)
Gd0=Vg;
f0=1/(2*pi*sqrt(L*C));
w0=2*pi*f0;
Q0=Rload*sqrt(C/L);
% Gvd=Gd0/(1+s/((Q0*w0)+(s/w0)^2))
Gvd= tf([Gd0],[1/w0^2,1/(Q0*w0),1]);
bode(Gvd)
hold on
% Phase margin of the open-loop system is almost zero so lead compensator
% is needed to increase phase margin
% Phase margin of the lead compensator is selected as 52 degree
% fc is selected as 10kHz, which is tenth of switching freq, for compensated 
% closed-loop system
fc=10e3;
wc=2*pi*fc;
fz=fc*sqrt((1-sin(52*2*pi/360))/(1+sin(52*2*pi/360))) % zero of PD
fp=fc*sqrt((1+sin(52*2*pi/360))/(1-sin(52*2*pi/360))) % pole of PD
wz=2*pi*fz;
wp=2*pi*fp;
% Gc=Gc0*((1+s/wz)/(1+s/wp))
% |Gvd(s=wc)*Gc(s=wc)|=1
Gvdwc=Gd0/(1+i*wc/(Q0*w0)+(i*wc/w0)^2);
% Gcwc=Gc0*((1+i*wc/wz)/(1+i*wc/wp))
Gcwcabs=1/abs(Gvdwc);
Gc0=Gcwcabs/abs((1+i*wc/wz)/(1+i*wc/wp))
Gc= tf([Gc0/wz,Gc0],[1/wp,1]);
% bode(Gc)
T=Gvd*Gc;
bode(T)
hold on
% Low frequency gain of the PD compensator is quite low so output voltage 
% is below the desired value(almost 5 V)
% To increase low freq. gain, inverted zero should be added to PD comp:
% Gi=(1+wL/s)
wL=wc/50
Gi= tf([1,wL],[1,0]);
Tall=Gi*T;
bode(Tall)
