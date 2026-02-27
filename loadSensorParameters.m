function SNS = loadSensorParameters()
    SNS = struct();

    % TODO: MPU-6050 specs?
    SNS.accel.var_x = 0.1;
    SNS.accel.var_y = 0.1;
    SNS.accel.var_z = 0.1;
end