function SNS = loadSensorParameters()
    SNS = struct();
    %% Accelerometer
    SNS.accel.SamplingRate = 100;
    SNS.accel.Ts = 1 / SNS.accel.SamplingRate; % seconds
    
    SNS.accel.upper_limit_g = 6;
    SNS.accel.lower_limit_g = -6;

    SNS.accel.bandwidth_Hz = SNS.accel.SamplingRate / 2;
    SNS.accel.LPF_tau = 1 / (2 * pi * SNS.accel.bandwidth_Hz);
    SNS.accel.noise_density = 250 * 1e-6;


    SNS.accel.var_x = (SNS.accel.noise_density * 9.80665 * sqrt(SNS.accel.bandwidth_Hz))^2;
    SNS.accel.var_y = SNS.accel.var_x;
    SNS.accel.var_z = SNS.accel.var_x;

    SNS.accel.bias_x = 0.0;
    SNS.accel.bias_y = 0.0;
    SNS.accel.bias_z = 0.0;


    %% Rate Gyroscope
    SNS.gyro.SamplingRate = 100;
    SNS.gyro.Ts = 1 / SNS.gyro.SamplingRate; % seconds
    
    SNS.gyro.upper_limit = 350 * pi / 180;
    SNS.gyro.lower_limit = -SNS.gyro.upper_limit;

    SNS.gyro.bandwidth_Hz = SNS.gyro.SamplingRate / 2;
    SNS.gyro.LPF_tau = 1 / (2 * pi * SNS.gyro.bandwidth_Hz);
    SNS.gyro.noise_density = 0.015 * pi / 180;
    
    SNS.gyro.var_x = (SNS.gyro.noise_density * sqrt(SNS.gyro.bandwidth_Hz))^2;
    SNS.gyro.var_y = SNS.gyro.var_x;
    SNS.gyro.var_z = SNS.gyro.var_x;

    SNS.gyro.bias_x = 0;
    SNS.gyro.bias_y = 0;
    SNS.gyro.bias_z = 0;

    SNS.gyro.drift_x = 0;
    SNS.gyro.drift_y = 0;
    SNS.gyro.drift_z = 0;

    %% Absolute Pressure Sensor
    SNS.abs_press.SamplingRate = 20;
    SNS.abs_press.Ts = 1 / SNS.abs_press.SamplingRate; % seconds
    SNS.abs_press.upper_limit = 115e3;
    SNS.abs_press.lower_limit = 15e3;

    SNS.abs_press.var = (0.01e3)^2;
    SNS.abs_press.bias = 0.0;
    % SNS.abs_press.bias = 0.125e3;

    %% Differential Pressure Sensor
    SNS.diff_press.SamplingRate = 20;
    SNS.diff_press.Ts = 1 / SNS.diff_press.SamplingRate; % seconds

    SNS.diff_press.upper_limit = 4e3;
    SNS.diff_press.lower_limit = 0;

    SNS.diff_press.var = 2^2;
    % SNS.diff_press.bias = 0.02e3;
    SNS.diff_press.bias = 0;


    %% Magnetometer  or Digital Compass 
    SNS.mag.SamplingRate = 8;
    SNS.mag.Ts = 1 / SNS.mag.SamplingRate; % seconds

    SNS.mag.var = deg2rad(0.3)^2;
    SNS.mag.bias = 0.0;
    % SNS.mag.bias = deg2rad(1);

    SNS.mag.declination = deg2rad(5.5); % ?

    %% GPS
    SNS.gps.SamplingRate = 1;
    SNS.gps.Ts = 1 / SNS.gps.SamplingRate; % seconds
    % Gauss - Markov Process
    SNS.gps.kgps_n = 1 / 1100 ;
    SNS.gps.kgps_e = 1 / 1100 ;
    SNS.gps.kgps_d = 1 / 1100 ;

    SNS.gps.var_n = 0.21^2;
    SNS.gps.var_e = 0.21^2;
    SNS.gps.var_d = 0.4^2;

    SNS.gps.v0 = 0;
    
    % Velocity 
    SNS.gps.var_vg = 0.01^2;
    SNS.gps.var_chi = SNS.gps.var_vg / 25^2;

    %% Random Seeds: Written arbitrary numbers but making sure they all different
    SNS.accel.seed_x = 12;
    SNS.accel.seed_y = 9999;
    SNS.accel.seed_z = 2345;

    SNS.gyro.seed_x = 14;
    SNS.gyro.seed_y = 5209;
    SNS.gyro.seed_z = 3242;

    SNS.abs_press.seed = 676;
    SNS.diff_press.seed = 344;

    SNS.mag.seed = 46;
    
    SNS.gps.seed_n = 32;
    SNS.gps.seed_e = 543;
    SNS.gps.seed_d = 983;
    SNS.gps.seed_vg = 123;
    SNS.gps.seed_chi = 0;
    




end