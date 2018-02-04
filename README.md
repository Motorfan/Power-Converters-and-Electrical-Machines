# Power-Converters-and-Electrical-Machines
Simulink models of power electronics and electric motor drive circuits

----------------------------------------------------------------------------------------------------------------------------------------
# Other Models
# Single phase inverter 

Single phase inverter model including;
- RLC output filter to obtain sine wave
- IGBTs with RC snubbers for switching
- internal resistance of the battery
- line reactance

----------------------------------------------------------------------------------------------------------------------------------------
Update Read.me

PI controller block is added to the inverter model for
stabilization of output voltage waveform.

----------------------------------------------------------------------------------------------------------------------------------------

# Single phase diode rectifier

A single phase uncontrolled full bridge diode rectifier 
with output LCR filter is modelled in MATLAB-Simulink. 
Ripple factor of output voltage and current is measured 
as 1-2% .


-------------------------------------------------------------------------------------------------------------------

 # Electric vehicle drive
 
 Electric vehicle model including dc motor, motor controller, 
 battery, PI controller subsystem block in MATLAB/Simulink.
 The input for the electric vehicle is vector data of road
 torque and speed values of the vehicle as following:
 
 % Load Speed values and times
Svals = [ 0 2000 3000 1000 1000 ]
Stime = [ 0 5 50 85 100 ] 
 % Load Torque values and times
Tvals = [ 0 330 330 160 160 -220 -220 0 0 ]
Ttime = [ 0 5 10 15 50 55 80 85 100 ]

The model is also constructed using following equations;

Developed Torque is proportional to armature current:
Equation 1: Td(Nm) = Km*IA(Amp) Developed motor torque

Developed Voltage is proportional to armature speed:
Equation 2: VD(Volt) = WD (rad/sec)* Km Developed motor voltage

Internal Motor Voltage referred to High Side
Equation 3: VH(Volt) = IH(Amp)*RA(Ohm) + LH(Henry)*di(t)/dt(A/s) + VD(V) Motor Voltage

High side voltage is equal to K times the low side voltage:
Equation 4: VH = K*VL Controller High Side Current

High side current is equal to 1/K times the low side voltage:
Equation 5: IH = (1/K)*VL Controller High Side Voltage

The battery terminal voltage,VB , is equal to the sum of the internal voltage and resistance
voltage drop. The battery voltage and battery current are equal to the controller low side voltage
and current.
Equation 6: VB (Volt) = IA(Amp) *RA(Ohm) + EB(Volt). Battery model calculation
VL (Volt) = IL(Amp) *RA(Ohm) + EB(Volt). Assuming: VB = VL and IA = IL

Equation 7: BERR = EB (actual) - EB (calculated) Error Voltage Calculation

The PI controller accepts the BERR signal from the Battery Model and uses proportional (Kp) and
integral (Ki) to calculate the gain K value that is used by the Motor Controller.
Equation 8: K = ( Kp + s*KI)*BERR PI Calculation

----------------------------------------------------------------------------------------------------------------------------------------

# 3-Phase Diode Rectifier

- Three phase full bridge diode rectifier models, with and without input broadband filter, are added. 
- The models are made as realistic (practical) as possible by modelling ac line reactors, input & output filter inductors and capacitors with corresponding internal resistors. 
- Snubbers are also modelled for diodes in the diode rectifier, modelled with input filter in such a way that voltage and current spikes corresponding to each diode in the rectifier are reduced compared to those in the one, modelled without input filter.

----------------------------------------------------------------------------------------------------------------------------------------

# Power Electronics for Electric Drive Vehicles
# Electric Vehicle Model (More detailed)

- More detailed electric vehicle model, containing vehicle system, environment forces and vehicle controller subsystems, is added.
- Simulink blocks are selected and connected by also considering the characteristic of speed of vehicle vs force (or torque) acting on it.
- Vehicle system includes battery pack (and its controller), DC-DC converter, motor drive inverter (and their controller circuits), PMAC motor, gear and tire.
- Compensated closed loop system is created for control of the vehicle, as well.

SOURCE: Lecture notes of "Power Electronics for Electric Vehicle" course provided by Colorado University.

UPDATE!
- Compensation system for vehicle controller is improved. One of the feedback controller parameters is changed in the script file.

ADDITION!
- Motor efficiency data is inserted to the same vehicle models so the efficiency value would vary according to vehicle speed-torque values.

----------------------------------------------------------------------------------------------------------------------------------------

# Battery Model

- Open loop Simulink model for battery pack is constructed based on mathematical expressions for standard Li-ion battery.
- Pa-rameters for single battery cell and battery pack model is determined via script file, also inserted. 

UPDATE!
- Closed-loop model of the battery pack and charge controller is inserted.
- This closed-loop battery model includes control of battery output voltage via charge controller.
- The related open and closed loop transfer functions as well as controller transfer functions are determined and plotted in script file, which is also included.

UPDATE 2!
- Closed-loop structure for the Li-ion battery pack model is modified by taking SOC signal as reference instead of Vbat voltage.
- The script file is modifed and updated according to new closed-loop structure, as well.
- Battery is charged up more quickly in this modified model compared to the previous standard one. 

UPDATE 3!
- Simulink blocks, constituted for the closed-loop battery model before and representing mathematical equations for Li-ion battery pack, are replaced by equivalent SimpowerSystem blocks,representing physical electrical & electronics components for the battery pack.
- The related script file is modified to determine and analyze transfer function for the main Li-ion battery model and determine the necessary parameters for the compensation filter, as well. 

-- SOURCE: CU‐Boulder ECEN5017/USU ECE6930 (Course) - Charge Controller Design and Battery System Simulation (Homework)

----------------------------------------------------------------------------------------------------------------------------------------

# Permanent Magnet Synchronous Machine Model

- Simulink model for Permanent Magnet Synchronous Motor (PMSM) is constructed with necessary control loop structures to adjust voltage & current values of q-d axis components of the motor within desired interval.
- Based on mathematical electrical equations of AC PMSM, Simulink blocks are utilized while developing the model. Also, a script file is generated for inserting parameters of PMSM, feedback loop structures and creating bode plots. 

UPDATE!
- Physical blocks (IGBT/Diode, switching wave generator for the inverter, PMSM model in Simscape library) are replaced by Simulink blocks, representing mainly mathematical equations for inverter, PMSM and control structure in the model created previously.
- Cut-off frequency for the closed-loop system of d-q axis voltage & current to adjust critical parameters in PMSM block is increased from 10Hz to 1kHz to decrease amount of ripple in torque, d-q axis current etc. for PMSM. However, responses to sudden changes in input parameters would be quite quick so this situation may cause undesired issues in real cases such as burning out of motor terminals.

UPDATE 2!
- Variable rotational speed block in addition to the constant speed block is inserted at input to the model created with Simscape blocks via manual switch, providing switch between constant and variable rotational speed for PMSM.
- This is to observe how output parameters of PMSM (Torque, phase voltages & currents, d-q axis currents etc) respond to sudden changes in the rotational speed value at input side since closed-loop control structure is already created to stabilize those parameters.



# Modelling and Control of Power Electronics Systems
# DC-DC Buck Converter Model

- Mathematical model of open loop buck converter is added.
- Script file for parameters and bode plot of the converter is included.

UPDATE!
- Closed-loop DC-DC buck converter model is added in addition to open-loop one, already added before.
- Script file for closed-loop one is also added, including bode plots of transfer functions of compensators designed and the closed-loop system.

UPDATE 2!
- Simulink blocks, representing mathematical model of DC-DC boost converter is replaced with equivalent Simscape/SimpowerSystem blocks.
- Control with current peak modulation (CPM) is implemented for the open loop buck converter model and the related Simulink model of open loop DC-DC buck converter with CPM control is inserted.
- Also, the script file for the converter is updated with new parameters and modifications.

UPDATE 3!
- Closed loop model is designed for CPM controlled DC-DC buck converter model, created previously.
- Feedback controller is achieved by voltage loop compensator, for which the required parameters are calculated by expressions given in the updated script file for the closed-loop converter model.
- Artificial ramp is added for CPM control to avoid undesired oscillations and stabilize the output current and voltage waveforms for the converter. Also, variable output model is inserted to the converter to observe the response of the closed loop system to changes at output.
- Two models of DC-DC buck converter with CPM, each based on Simulink blocks and SimPowerSystem blocks, are added. 
----------------------------------------------------------------------------------------------------------------------------------------

# DC-DC Boost Converter Model

- Boost converter model, including averaged mathematical equations for the converter, is added.
- Closed-loop current compensator is included in the model as well as script file for parameters and bode plots of both uncompensated and compensated current loop of the converter.
- Output voltage is not stabilized in this model. For stabilization a voltage compensator should be designed for the converter in addition to the current compensator.

UPDATE!
- Voltage loop compensator is inserted to the closed-loop converter model with current compensator.
- Modification of the model is achieved by adding voltage PI compensator so the both input current and output voltage is highly stabilized in a short time in simulation.
- Script file is updated by adding transfer function of voltage compensator and calculations for some added parameters.

UPDATE 2!
- The closed-loop DC-DC boost converter model is modified in a way output current varies in time.
- Change in output during time is made by adding some step responses in the model.
- The purpose of this modification is testing the response of the converter system to sudden changes that could occur in the output.

UPDATE 3!
- Equivalent Simscape/SimpowerSystem blocks are inserted to the converter model instead of Simulink blocks used to model mathematical 
equations of the DC-DC boost converter, already modelled before.
- The model includes two type output models, which are constant output load and variable output load. The switch is inserted to the model for determining load type before simulation is performed.
- The script file is also updated to define or calculate new added parameters, added to the converter model.
- This model is thought to be probably the most complicated boost converter model that could be modelled in MATLAB/Simulink.


----------------------------------------------------------------------------------------------------------------------------------------

# Final Highly Detailed Electric Vehicle Model
- Simulink model of electric vehicle(EV) including corresponding subsystems, which are created in detailed based on mathematical dynamics equations, is added.  
- The model contains mechanical driving force subsystems such as force & torque blocks, gear and motion ratio systems; power electronics subsystems such as DC battery, boost converter, AC electrical machine blocks. Closed control loops are also modelled wherever necessary for stabilization of the whole system.
- While simulation is run, it is observed that voltage and current values corresponding to the subsystems regarding power electronics have relatively high surges as vehicle speed changes suddenly. This situation may cause damage for electrical/electronic components in the vehicle so snubber circuits for power electronics switching devices must be inserted in practical case.  
