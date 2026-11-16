% Bus definitions for the Inputs and MEAS ports of Sensors.slx.
% Run this script from the MATLAB Command Window to load the bus objects.

SensorsInputsBus = createSensorBus({
    'p_neh_inI_3x1',          [3 1], 'double';
    'eta_I2B_rad_3x1',        [3 1], 'double';
    'omega_inB_rad_s_3x1',    [3 1], 'double';
    'Va',                    1, 'double';
    'Force_inB_N_3x1',        [3 1], 'double';
    'wind_steady_inI_m_s_3x1', [3 1], 'double'
});

SensorsImuDataBus = createSensorBus({
    'meas_accel_inB_3x1_m_s2',    [3 1], 'double';
    'meas_ang_rate_inB_3x1_rad_s', [3 1], 'double';
    'meas_mag_yaw_1x1_rad',       1, 'double'
});

% The ready signals come from Pulse Generator blocks with amplitude 1.
SensorsImuReadyBus = createSensorBus({
    'is_accel_ready', 1, 'double';
    'is_gyro_ready',  1, 'double';
    'is_mag_ready',   1, 'double'
});

SensorsImuBus = createSensorBus({
    'sensor_data_BUS',  1, 'Bus: SensorsImuDataBus';
    'sensor_ready_BUS', 1, 'Bus: SensorsImuReadyBus'
});

SensorsAbsPressBus = createSensorBus({
    'meas_abs_press_1x1_Pa', 1, 'double';
    'is_abs_press_ready',    1, 'double'
});

SensorsDiffPressBus = createSensorBus({
    'meas_diff_press_1x1_Pa', 1, 'double';
    'is_diff_press_ready',    1, 'double'
});

SensorsGpsBus = createSensorBus({
    'meas_p_ned_inI_3x1', [3 1], 'double';
    'meas_Vg_inI_1x1',    1, 'double';
    'meas_chi_1x1',       1, 'double';
    'is_gps_press_ready', 1, 'double'
});

SensorsMeasBus = createSensorBus({
    'IMU',        1, 'Bus: SensorsImuBus';
    'ABS_PRESS',  1, 'Bus: SensorsAbsPressBus';
    'DIFF_PRESS', 1, 'Bus: SensorsDiffPressBus';
    'GPS',        1, 'Bus: SensorsGpsBus'
});

function bus = createSensorBus(definitions)
    for idx = size(definitions, 1):-1:1
        elements(idx) = Simulink.BusElement;
        elements(idx).Name = definitions{idx, 1};
        elements(idx).Dimensions = definitions{idx, 2};
        elements(idx).DataType = definitions{idx, 3};
    end

    bus = Simulink.Bus;
    bus.Elements = elements;
end
