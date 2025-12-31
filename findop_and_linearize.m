%% SETUP
clear;clc;
run("Setup.m")
MODEL_NAME = "Trim_model";
Va_trim = 25;
R_trim = Inf;

gamma_trim = 0 * pi / 180;
disp("Running findop_and_linearize script...");
%% Find an operating point
op = findOp(MODEL_NAME, Va_trim, gamma_trim, R_trim);

MAV.init_states(3:12) = [op.States(1).x(3);op.States(2).x; op.States(3).x;op.States(4).x];
u_trim = op.Inputs.u;

%% Ask the user to test the found point. VERIFICATION STEP

fprintf('\n--------------------------------------------------------\n');
fprintf('An operating point has found.\n');
fprintf('Please Run the Simulation file about 10-20 seconds to verify\n');
fprintf('--------------------------------------------------------\n');

user_response = input("Are the simulation results satisfactory? (y/n): ", 's');
if strcmpi(user_response, 'n')
    error('Op:VerificationFailed', ...
            "Optimization failed to find a satisfactory solution. Check their warnings and fix the result (Good Luck)")
end
%% Find transfer functions
Gss = computeTransferFunctions(op);

%% Linearize Model According to operating point
[A_long, B_long, A_lat, B_lat] = computeSSModel(op);
%% Characteristic Verification
printInfoOfSSModel(A_long, B_long, A_lat, B_lat)