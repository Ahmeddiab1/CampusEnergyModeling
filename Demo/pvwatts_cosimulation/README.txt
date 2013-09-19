This demonstration executes a PVWatts cosimulation within Simulink using the MATLAB-SSC interface.
The simulation uses weather data at NREL for June 2012, either from a TMY3-formatted text file or
downloaded directly from DataBus.

Features:
•   Executes PVWatts SSC module within Simulink using the MATLAB-SSC interface
•   Demonstrates cosimulation of PVWatts and Simulink
•   Demonstrates Simulink blocks for PV array smoothing and modeling a PV inverter

Requirements:
•   MATLAB/Simulink (R2013a)
•   Campus Energy Modeling project MATLAB/Simulink library
•   SimPowerSystems
•   SSC SDK

Instructions: 
1.  Open MATLAB and set the working directory to the folder that contains this README file.
2.  Ensure the MATLAB interface folder for the SSC SDK is in the MATLAB path.
3.  Run the script 'pvwatts_cosimulation_init.m' to initialize the weather data.
4.  Run the Simulink model and examine the results in the scope.

Comments:
1.  In 'pvwatts_cosimulation_init.m', you can select either a short-term or a long-term simulation.
    The two simulations use different weather data; see the comments in the initialization script
	for details.
2.  The help for the 'PVWatts Cosimulation', 'PV Smoothing', and 'Generic Inverter' Simulink blocks
    contain additional information about how the various PV models are implemented.