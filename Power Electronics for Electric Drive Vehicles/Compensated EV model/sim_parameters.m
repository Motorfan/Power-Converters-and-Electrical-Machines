%% Simulation Parameters
tstop = 40;
tstep = .01;                    
vref_1 = 6.7;                       %[m/s]
vref_2 = 8.9;                       %[m/s]
%% Transmission Parameters
gratio = 7.94 ;
%% Wheel Parameters
rw = 0.4;
%% Battery Model Parameters
n_cells = 48;                        % # of cells in battery pack 
Capacity_cell = 33.1*2*3.8*2*3600;   %[J]
V_cell = 3.8*2;                      %[V]
weight_cell = 3.75;                  %[kg]
Capacity = Capacity_cell*n_cells;    %[J]
SOC_0 = 100;                         %[%]
Vbat = V_cell*n_cells;               %[V]
%% Electric Motor Parameters
eta_m = .95;
Ke = 0.407;                          %[Nm/A]
Pe_max = 80e3;                       %[W]
Te_max = 280;                        %[Nm]
Vbase = Pe_max/Te_max/gratio*rw      %[m/s]
%% DC-DC Converter Parameters
eta_DC = .98;                        % DC-DC converter efficiency
Vbus_ref = 500;                      %[V]
%% Inverter Parameters
eta_inv = .95;                       % Inverter efficiency
%% Vehicle Physical and Controller Parameters
Mv = 1250 + 55 + 15 + n_cells*weight_cell;  % Vehicle weight + 250 kg passengerand cargo weight  
Cd = 0.26;                            
Cr = 0.01;
Av = 2.16;                           %[m^2]
rho_air = 1.204;                     %[kg/m^3]
V = vref_1;
Fv_max = Te_max*gratio/rw;
%% Bode Plot Parameters
wphy = (rho_air*Cd*Av*V)/Mv;
Gphy0 = 1/(rho_air*Cd*Av*V)
fphy = wphy/(2*pi)
%Gphy = Gphy0*(1/(1+s/wphy))
Gphy = tf([Gphy0],[1/wphy,1]);
%bode(Gphy)

Gcm = 1000;
fz = 0.2;
wz = 2*pi*fz;
%Gc = Gcm*(1+wz/s)
%T = Gphy*Gc
Gc = tf([Gcm, Gcm*wz],[1,0]);
T = Gphy*Gc;
bode(T)
