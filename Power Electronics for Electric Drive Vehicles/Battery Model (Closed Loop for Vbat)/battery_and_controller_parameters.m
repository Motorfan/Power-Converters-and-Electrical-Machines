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
Vcell_max=3.7 %[V] (at SOC=80%)

% ---------------------------------------------------------------------------
% Charge Controller Design (for charging case)

% Gbat=vbat^/ibat^
s = tf('s');
K=(-100*etaC)/(Mp*Cnom*3600)

% From perturbation and linerization analysis of Voc vs SOC characteristics
% around SOC=50%, two points near the point at SOC=50% are determined:
% p1=(49.99%,3.602638254257941 V) & p2=(50.01%,3.602691596298336 V)
x1=49.99;
x2=50.01;
y1=3.602638254257941;
y2=3.602691596298336;
m=(y2-y1)/(x2-x1)

Rs=Rp;
Gbat=Ns*((K*m)/s-((R1/Mp)*(1/(tau1*s+1)))-(Rs/Mp));
bode(Gbat)
hold on

% Compensation for charge controller circuit can be achieved by the 
% transfer function: Gc = Gc0/((1/wcp)*s^2+s)
% Gbat(s=wc)*Gc(s=wc)*(-1)=1

fc=1;
wc=2*pi*fc
Gbatwc = abs(Ns*((K*m)/(i*wc)-((R1/Mp)*(1/(tau1*(i*wc)+1)))-(Rs/Mp)))
Gcwc=1/Gbatwc

wcp=2.5*wc;

Gc0=Gcwc*abs(((1/wcp)*(i*wc)^2+(i*wc)))
Gc= Gc0/((1/wcp)*s^2+s);
%bode(Gc)

Tc=(-1)*Gc*Gbat;
bode(Tc)