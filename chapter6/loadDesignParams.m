function DES = loadDesignParams()
    % This function is used to define design requirements and
    % their specifications.
    % DES is short for design.
    D2R = pi / 180;
    DES = struct();

    % Control Surfaces
    DES.delta_a_max = 45 * D2R; % Roll Hold
    DES.delta_r_max = 45 * D2R; % Sideslip Hold
    DES.delta_e_max = 45 * D2R; % Pitch Hold
    DES.delta_t_max = 1.0;      % Throttle
    DES.delta_t_climb_or_takeoff = 0.5 * DES.delta_t_max; % TODO: It's too simple and why would i use half of my power when I am taking off.

    %% ROLL ANGLE
    DES.Roll.max = 15 * D2R;
    DES.Roll.error_max = 2 * DES.Roll.max;
    DES.Roll.zeta = 0.85;
    % Roll Loop Integrator Design. Integrator induced zero (-Ki / Kp)
    % How many times slower the integrator effect than the natural
    % frequency of PD? -> AI suggestion. But, It seems logical to me.
    DES.Roll.integrator_split = 15;
    
    %% COURSE ANGLE
    DES.Course.Wx_phi = 20;
    DES.Course.zeta = 1;

    %% SIDESLIP Angle
    DES.Sideslip.max = 10 * D2R;
    DES.Sideslip.error_max = 2 * DES.Sideslip.max;
    DES.Sideslip.zeta = 1;

    %% Pitch Angle 
    DES.Pitch.zeta = 1;
    DES.Pitch.Takeoff = 15 * D2R;

    %% Altitude Hold Loop By Pitch Angle Command
    DES.Altitude.Wx_theta = 15;
    DES.Altitude.zeta = 1;
    DES.Altitude.Threshold = 10     ; % [m]
    DES.Altitude.Takeoff = 5; % [m]
    DES.Altitude.Pitch.error_max = 10 * D2R;
    DES.Altitude.Pitch.max = DES.Altitude.Pitch.error_max / 2;

    %% Airspeed Hold Loop By Pitch Angle Command
    DES.Airspeed.Pitch.Wx = 15;
    DES.Airspeed.Pitch.zeta = 1;
    DES.Airspeed.Pitch.max = 45 * D2R;

    %% Airspeed Hold Loop By Throttle Command
    DES.Airspeed.Throttle.Wx = 10;
    DES.Airspeed.Throttle.zeta = 1;


    
end