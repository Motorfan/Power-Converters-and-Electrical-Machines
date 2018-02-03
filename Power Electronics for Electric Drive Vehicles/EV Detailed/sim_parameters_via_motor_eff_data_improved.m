%% Simulation Parameters
tstop = 750;
tstep = .01;                    
vref_1 = 6.7;                       %[m/s]
vref_2 = 8.9;                       %[m/s]
%% Transmission Parameters
gratio = 7.94 ;
%% Wheel Parameters
rw = 0.4;
%% Battery Parameters
load batt_V_SOC.mat % Voc(SOC) look-up table

Mp=3;
Ns=100;
weight_cell=0.5;
etaC = 0.995; 

Rp=5e-3;  %[ohm]
Rn=5e-3;  %[ohm]
Cnom=10;    %[Ah]
SOC_0=0.75; %[Initial state of charge]
SOC_1=0.95; %[Final state of charge]
Crate=3*Mp*Cnom  % Max battery pack charge/discharge rate

Vm=15e-3;  %[V]

tauh=40;   %[s]
tau1=240;  %[s]

R1=5e-3;  %[ohm]

%% Electric Motor Parameters
P=8; %(pole number)
lambda_m=0.125;
r=0.04;
L1=0.5e-3;
Pout=5e3;

% Equations for permanent magnet synchronous machine (PMSM)
% Vq = Vqref+w_r*L*id+lambda_m*w_r
% Vd = Vdref-w_r*L*iq
% Vqref =(r+s*L)*iq
% Vdref =(r+s*L)*id
% Giv=i^/V^ =1/(r+s*L)
s=tf('s');
Giv=1/(r+s*L1);
wp=r/L1

figure(1)
bode(Giv)
hold on
% Designing PI compensator to control voltage & current in q-d axis
% Gci= Kp+Ki/s = Kp*(1+(Ki/Kp)/s)
% wz=Ki/Kp
% Gci= Kp+Ki/s
wz1=wp
% fc=10Hz
% Gci(f=10)*Giv(f=10)=1
Givabs= abs(1/(r+(2*pi*10)*L1))
Gciabs1= 1/Givabs
Kp= Gciabs1/abs(1+wz1/(2*pi*10))
Gci1= Kp*(1+wz1/s);
bode(Gci1)
hold on

T1=Giv*Gci1;
bode(T1)

legend('Giv','Gci1','T1')
%% DC-DC Converter Parameters
Vg=Ns*Vcell;
Vo=600;
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

figure(2)
bode(Gid)
hold on

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
bode(Gci)
hold on

Tc=Gid*Gci;
bode(Tc)
legend('Gid','Gci','Tc')

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

figure(3)
bode(Tvu)
hold on

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
bode(Gcv)
hold on

Tv=Tvu*Gcv;
bode(Tv)
legend('Tvu','Gcv','Tv')

%% Vehicle Physical and Controller Parameters
Mv = 1250 + 55 + 15 + Ns*Mp*weight_cell;  % Vehicle weight + 250 kg passengerand cargo weight  
Cd = 0.26;                            
Cr = 0.01;
Av = 2.16;                           %[m^2]
rho_air = 1.204;                     %[kg/m^3]
V = vref_1;
Te_max=200;
Fv_max = Te_max*gratio/rw;
%% Bode Plot Parameters
wphy = (rho_air*Cd*Av*V)/Mv;
Gphy0 = 1/(rho_air*Cd*Av*V)
fphy = wphy/(2*pi)
%Gphy = Gphy0*(1/(1+s/wphy))
Gphy = tf([Gphy0],[1/wphy,1]);

figure(4)
bode(Gphy)
hold on

Gcm = 1000;
fz2 = fphy;
wz2 = 2*pi*fz2;
%Gc = Gcm*(1+wz/s)
%T = Gphy*Gc
Gc = tf([Gcm, Gcm*wz2],[1,0]);
T = Gphy*Gc;
bode(T)
legend('Gphy','T')
