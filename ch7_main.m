clear;clc;
run("Setup.m");

%% 
LNG_MODEL = 2; % Nonlinear Drag - Lift
TRIM_MODEL = "Trim_model";
TRIM_DATA_FILE = "ch7.mat";
SIMULATION_FILE = "Chapter6.slx";
ENVELOPE_DATA_FILE = "envelope.mat";
FIND_ENVELOPE = false;
Va_trim = 25;
R_trim = Inf;
gamma_trim = 0 * pi / 180;

TRIM = findTrim(TRIM_MODEL, Va_trim, R_trim, gamma_trim, TRIM_DATA_FILE);
MAV.init_states = TRIM.x;
TFS = computeTransferFunctions(TRIM);
DES = loadDesignParams();
AP = computeAutopilotGains(MAV, TRIM, TFS, DES);
disp("Autopilot gains are computed.")

CMD = struct();
CMD.Course = MAV.init_states(9);
CMD.Sideslip = TRIM.beta;
CMD.Airspeed = TRIM.Va;
CMD.Altitude = -TRIM.x(3);

LIM = loadSafetyLimits();
WIND = loadWindParameters();
SNS = loadSensorParameters();
