function SNS = loadSensorParameters()
    SNS = struct();
    %% Accelerometer
    SNS.accel.SamplingRate = 50;
    SNS.accel.upper_limit_g = 6;
    SNS.accel.lower_limit_g = -6;

    SNS.accel.bandwith_Hz = 100;
    SNS.gyro.LPF_tau = 1 / (2 * pi * SNS.accel.bandwidth_Hz);
    SNS.accel.noise_density = 250 * 1e-6;


    SNS.accel.var_x = (SNS.accel.noise_density * sqrt(SNS.accel.LPF_tau))^2;
    SNS.accel.var_y = SNS.accel.var_x;
    SNS.accel.var_z = SNS.accel.var_x;

    SNS.accel.bias_x = 0.1;
    SNS.accel.bias_y = 0.1;
    SNS.accel.bias_z = 0.1;


    %% Rate Gyroscope
    SNS.gyro.SamplingRate = 100;
    
    SNS.gyro.upper_limit = 350 * pi / 180;
    SNS.gyro.lower_limit = -SNS.gyro.upper_limit;

    SNS.gyro.bandwith_Hz = 80;
    SNS.gyro.LPF_tau = 1 / (2 * pi * SNS.gyro.bandwidth_Hz);
    SNS.gyro.noise_density = 0.015 * pi / 180;
    
    SNS.gyro.var_x = (SNS.gyro.noise_density * sqrt(SNS.gyro.LPF_tau))^2;
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
    SNS.abs_press.var = 0.1;
    SNS.abs_press.bias = 0.0;
    
    %% Differential Pressure Sensor
    SNS.diff_press.var = 0.1;
    SNS.diff_press.bias = 0.1;
    SNS.diff_press.SamplingRate = 20;

    %% Magnetometer  or Digital Compass 
    SNS.mag.var = 0.1;
    SNS.mag.bias = 0.1;
    SNS.mag.SamplingRate = 10;

    SNS.mag.declination = deg2rad(5.5);

    %% GPS

    % Gauss - Markov Process
    SNS.gps.kgps_n = 1 / 1000;
    SNS.gps.kgps_e = 1 / 1000;
    SNS.gps.kgps_d = 1 / 1000;

    SNS.gps.var_n = 0.21^2;
    SNS.gps.var_e = 0.21^2;
    SNS.gps.var_d = 0.4^2;
    SNS.gps.SamplingRate = 5;
    SNS.gps.v0 = 3;
    
    % Velocity 
    SNS.gps.var_vg = 0.01^2;
    SNS.gps.var_chi = SNS.gps.var_vg / 25;

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