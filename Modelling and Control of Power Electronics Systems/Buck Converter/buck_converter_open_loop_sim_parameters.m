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


