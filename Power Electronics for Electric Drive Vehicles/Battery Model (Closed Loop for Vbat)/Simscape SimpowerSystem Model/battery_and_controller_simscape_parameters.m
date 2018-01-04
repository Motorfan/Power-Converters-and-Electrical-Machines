load batt_V_SOC.mat % Voc(SOC) look-up table

Mp=3;
Ns=100;

etaC = 0.995; 

Rp=5e-3;  %[ohm]
Rn=5e-3;  %[ohm]
Cnom=10;    %[Ah]
SOC_0=0.2; %[Initial state of charge]
SOC_1=0.8; %[Final state of charge]
Crate=1.5*Mp*Cnom  % Max battery pack charge/discharge rate

Vm=15e-3;  %[V]

tauh=40;   %[s]
tau1=240;  %[s]
%R1*C1=tau1;
R1=1e-3;  %[ohm]
C1=tau1/R1
%Rh*Ch=tauh;
Rh=1e-3;
Ch=tauh/Rh

Vcell_max=3.7 %[V] (at SOC=80%)

% ---------------------------------------------------------------------------
% Charge Controller Design (for charging case)

% Gbat=vbat^/ibat^
s = tf('s');

% Transfer function for battery voltage to battery current (Vbat^/ibat^) 
% is determined by linear analysis of the main Li-ion battery model, taking
% ibat as input perturbation and vbat as output measurement.

Rs=Rp;
Gbat=(-0.1667*s^2 - 0.08417*s - 0.0003472)/(s^2 + 0.004167*s);
bode(Gbat)
hold on

% Compensation for charge controller circuit can be achieved by the 
% transfer function: Gc = Gc0/((1/wcp)*s^2+s+1), that can be assumed as 
% a transfer function of second order low-pass filter.
% H(s)=k/((s^2/wn^2)+(s/(Q*wn))+1) is the general form of second order
% low-pass filter.

% Gbat(s=wc)*Gc(s=wc)*(-1)=1

fc=100;
wc=2*pi*fc
Gbatwc = abs((-0.1667*(i*wc)^2 - 0.08417*(i*wc) - 0.0003472)/((i*wc)^2 + 0.004167*(i*wc)))
Gcwc=1/Gbatwc

wcp=2*wc;

Gc0=Gcwc*abs((1/wcp)*(i*wc)^2+(i*wc)+1)
Gc=Gc0/((1/wcp)*s^2+s+1);
bode(Gc)
hold on

Tc=(-1)*Gc*Gbat;

wn=sqrt(wcp)
Q=1/wn
Rc=5e3;
Cc=1/(Q*wn*Rc)
Lc=1/(wn^2*Cc)

bode(Tc)
legend('Gbat','Gc','Tc')