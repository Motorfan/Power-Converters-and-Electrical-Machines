load batt_V_SOC.mat % Voc(SOC) look-up table

Mp=3;
Ns=100;

etaC = 0.995; 

Rp=5e-3;  %[ohm]
Rn=5e-3;  %[ohm]
Cnom=10;    %[Ah]
SOC_0=0.2; %[Initial state of charge]
SOC_1=0.8; %[Final state of charge]
Crate=3*Mp*Cnom  % Max battery pack charge/discharge rate

Vm=15e-3;  %[V]

tauh=40;   %[s]
tau1=240;  %[s]

R1=5e-3;  %[ohm]

% -------------------------------------------------------------------------
% Charge Controller Design (for charging case with SOC(%) reference)

% Gsoc=SOC^/ibat^
s = tf('s');
K=(-100*etaC)/(Mp*Cnom*3600)

Gsoc=K/s;
bode(Gsoc)
hold on

% Compensation for charge controller circuit can be achieved by the 
% transfer function: Gc = Gc0/((1/wcp)*s^2+s)
% Gsoc(s=wc)*Gc(s=wc)*(-1)=1

fc=1;
wc=2*pi*fc
Gsocwc = abs(K/(i*wc))
Gcwc=1/Gsocwc

wcp=10*wc;

Gc0=Gcwc*abs((1/wcp)*(i*wc)^2+(i*wc))
Gc=Gc0/((1/wcp)*s^2+s);

% Lead compensator could be designed to increase phase margin to desired 
% value. Otherwise, phase margin would be too low!
% Glead=Glead0*((1+s/wz)/(1+s/wp))

fz=fc*sqrt((1-sin(0.4*pi))/(1+sin(0.4*pi)))
fp=fc*sqrt((1+sin(0.4*pi))/(1-sin(0.4*pi)))
wz=2*pi*fz
wp=2*pi*fp

% T=Gc*Gsoc*(-1)
% T(s=wc)*Glead(s=wc)=1
Gleadabs=1/(Gsocwc*Gcwc)
Glead0=Gleadabs/abs((1+(i*wc)/wz)/(1+(i*wc)/wp))
Glead=Glead0*((1+s/wz)/(1+s/wp));
%bode(Glead)

Tc=(-1)*Gc*Gsoc*Glead;
bode(Tc)