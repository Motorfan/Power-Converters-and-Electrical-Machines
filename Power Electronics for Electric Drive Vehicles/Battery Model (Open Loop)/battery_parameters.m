load batt_V_SOC.mat % Voc(SOC) look-up table

Mp=2;
Ns=100;

etaC = 0.93; 

Rp=10e-3;  %[ohm]
Rn=10e-3;  %[ohm]
Cnom=5;    %[Ah]
SOC_0=0.5; %[Initial state of charge]

Vm=20e-3;  %[V]

tauh=50;   %[s]
tau1=100;  %[s]

R1=10e-3;  %[ohm]