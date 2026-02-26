function TRIM = findTrim(TRIM_MODEL, Va_trim, R_trim, gamma_trim, TRIM_DATA_FILE)
    TRIM = struct();
    if isempty(TRIM_DATA_FILE)
        TRIM_DATA_FILE = "trim.mat";
    end
    if (~isfile(which(TRIM_DATA_FILE)))
        op = findOp(TRIM_MODEL, Va_trim, gamma_trim, R_trim);
        
        TRIM.x = [op.States(1).x;op.States(2).x; op.States(3).x;op.States(4).x];
        TRIM.u = op.Inputs.u;
        trim_vel = TRIM.x(4:6);
        
        TRIM.Va = norm(trim_vel);
        TRIM.alpha = atan2(trim_vel(3), trim_vel(1));
        TRIM.beta = asin(trim_vel(2) / (TRIM.Va + 1e-5));
        
        fprintf('\n--------------------------------------------------------\n');
        fprintf('An operating point has found.\n');
        fprintf('Please, Check whether the final error is small enough.\n');
        fprintf('--------------------------------------------------------\n');
        
        user_response = input("Are the simulation results satisfactory? (y/n): ", 's');
        if strcmpi(user_response, 'n')
            error('Op:VerificationFailed', ...
                    "Optimization failed to find a satisfactory solution. Check their warnings and fix the result (Good Luck)")
        end
        save(TRIM_DATA_FILE, 'TRIM')
    else
        load(TRIM_DATA_FILE, 'TRIM');
    end
end 