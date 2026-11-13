MODEL_NAME = "Trim_model";
TRIM = struct();
Va_trim = 25;
R_trim = Inf;

gamma_trim = 0 * pi / 180;
disp("Running findop_and_linearize script...");
%% Find an operating point
op = findOp(MODEL_NAME, Va_trim, gamma_trim, R_trim);

TRIM.x = [op.States(1).x;op.States(2).x; op.States(3).x;op.States(4).x];
TRIM.u = op.Inputs.u;
trim_vel = TRIM.x(4:6);

TRIM.Va = norm(trim_vel);
TRIM.alpha = atan2(trim_vel(3), trim_vel(1));
TRIM.beta = asin(trim_vel(2) / (TRIM.Va + 1e-5));

MAV.init_states = TRIM.x; % Need for simulation.
u_trim = TRIM.u;

%% Ask the user to test the found point. VERIFICATION STEP

fprintf('\n--------------------------------------------------------\n');
fprintf('An operating point has found.\n');
fprintf('Please Run the Chapter5.slx file about 10-20 seconds to verify\n');
fprintf('--------------------------------------------------------\n');

user_response = input("Are the simulation results satisfactory? (y/n): ", 's');
if strcmpi(user_response, 'n')
    error('Op:VerificationFailed', ...
            "Optimization failed to find a satisfactory solution. Check their warnings and fix the result (Good Luck)")
end
%% Find transfer functions
Gss = computeTransferFunctions(TRIM);

%% Linearize Model According to operating point
[A_long, B_long, A_lat, B_lat] = computeSSModel(op);
%% Characteristic Verification
printInfoOfSSModel(A_long, B_long, A_lat, B_lat)

save("oper_point.mat", "A_long", "B_long", "A_lat", "B_lat", "TRIM")

