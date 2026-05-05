function EST = loadEstimationParameters(SNS)
    EST = struct();
    EST.SamplingTime = 1 / SNS.gyro.SamplingRate; % (second) TODO: 100Hz, Try gyro sampling rate also
    %% Attitude EKF
    EST.attitude_ekf.init_states = [0; 0]; % phi; theta
    EST.attitude_ekf.init_P = ones(2, 2);
    % EST.attitude_ekf.Q = 
    % EST.attitude_ekf.R = 
    
    %% GPS EKF
    EST.gps_ekf.init_states = [0;0;0;0;0]; % p_3x1; vg_1x1; chi_1x1

    %% Airspeed
    EST.airspeed.lpf_tau = 0.05;             % cut-off freq approx 3 Hz
    %% Gyroscope
    EST.gyro.lpf_tau = 0.005 * ones(3, 1);                % cut-off freq approx 32 Hz
end