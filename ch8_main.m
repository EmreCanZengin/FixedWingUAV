clear;clc;
run(fullfile(fileparts(mfilename("fullpath")), "Setup.m"));

%% 
LNG_MODEL = 2; % Nonlinear Drag - Lift
TRIM_MODEL = "Trim_model";
TRIM_DATA_FILE = fullfile(fileparts(mfilename("fullpath")), "trim_straight_level.mat");

Va_trim = 25;
R_trim = Inf;
gamma_trim = 0 * pi / 180;

TRIM = findTrim(TRIM_MODEL, Va_trim, R_trim, gamma_trim, TRIM_DATA_FILE);
MAV.init_states = TRIM.x;
TFS = computeTransferFunctions(TRIM);
DES = loadDesignParams();
AP = computeAutopilotGains(MAV, TRIM, TFS, DES);

CMD = struct();
CMD.Course = MAV.init_states(9);
CMD.Sideslip = TRIM.beta;
CMD.Airspeed = TRIM.Va;
CMD.Altitude = -TRIM.x(3);

LIM = loadSafetyLimits();
WIND = loadWindParameters();
SNS = loadSensorParameters();
loadSensorBusDefs;
EST = loadEstimationParameters(SNS);

assert(EST.SamplingTime >= SIM.FixedStepSize, "Simulation fixed step size can't cover the sampling time of the Estimation Block !!!")
% Autopilot sampling time vs integrator sampling time.

disp("Simulation settings are done. Go run it!")