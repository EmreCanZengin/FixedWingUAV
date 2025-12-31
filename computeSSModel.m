function [A_long, B_long, A_lat, B_lat] = computeSSModel(op)
    % I think this is not a good way of writing this funciton.
    MODEL_NAME = "Trim_model";
    lin_opt = linearizeOptions("BlockReduction", "off");
    io(1) = linio(MODEL_NAME + "/u", 1, "input");
    io(2) = linio(MODEL_NAME + "/Plant", 1, "openoutput");
    
    stateorder = [
        "Trim_model/Plant/Subsystem1/Integrator", ...
        "Trim_model/Plant/Subsystem1/Integrator1", ...
        "Trim_model/Plant/Subsystem1/Integrator2", ...
        "Trim_model/Plant/Subsystem1/Integrator3"
        ];

    linsys = linearize(MODEL_NAME, io, op, lin_opt, "StateOrder", stateorder);
    
    %% Separating Longitudinal and Lateral 
    A_sys = linsys.A;
    B_sys = linsys.B;
    
    % Longitudinal
    long_rows = [4, 6, 11, 8, 3]; % Defined by the book
    long_cols_x = long_rows;
    long_cols_u = [2, 4];
    
    A_long = A_sys(long_rows, long_cols_x);
    B_long = B_sys(long_rows, long_cols_u);
    
    % [Warn] the third state is pd in my simulation. 
    A_long(end, :) = -A_long(end, :);
    B_long(end, :) = -B_long(end, :);
    
    % Lateral
    lat_rows = [5, 10, 12, 7, 9];
    lat_cols_x = lat_rows;
    lat_cols_u = [1, 3];
    
    A_lat = A_sys(lat_rows, lat_cols_x);
    B_lat = B_sys(lat_rows, lat_cols_u);
end