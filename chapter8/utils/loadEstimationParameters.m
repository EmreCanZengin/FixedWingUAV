function EST = loadEstimationParameters(SNS)
    EST = struct();
    EST.SamplingTime = SNS.gyro.Ts; 
    %% Attitude EKF
    EST.attitude_ekf.init_states = [0; 0]; % phi; theta
    EST.attitude_ekf.init_P = eye(2, 2);
    EST.attitude_ekf.Q = diag([SNS.gyro.var_x; SNS.gyro.var_y; SNS.gyro.var_z]) * SNS.gyro.Ts;
    EST.attitude_ekf.R = eye(3, 3) .* [SNS.accel.var_x; SNS.accel.var_y; SNS.accel.var_z];

    % Adaptation Parameters
    EST.attitude_ekf.gamma = 3 * sqrt(SNS.accel.var_x);
    EST.attitude_ekf.alpha = 0.025 ^ (EST.SamplingTime / 0.1);
    EST.attitude_ekf.beta = 0.1;
    EST.attitude_ekf.R_max = EST.attitude_ekf.R * 1e2;
    
    %% GPS EKF
    % EST.gps_ekf.init_states = [0;0;0;0;0]; % p_3x1; vg_1x1; chi_1x1

    %% Airspeed
    EST.airspeed.lpf_tau = 0.05;             % cut-off freq approx 3 Hz
    %% Gyroscope
    EST.gyro.lpf_tau = 0.005 * ones(3, 1);                % cut-off freq approx 32 Hz
end