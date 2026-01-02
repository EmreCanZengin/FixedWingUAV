function tfs = computeTransferFunctions(op) 
    MAV = loadMAVParameters();
    tfs = struct();
    pos = op.States(1).x;
    vel = op.States(2).x;
    eta = op.States(3).x;
    ang_rate = op.States(4).x;

    u = op.Inputs(1).u;
    Va = norm(vel);

    %% Lateral Motion Transfer Functions

    % Roll - Aileron Deflections
    a_phi1 = -0.25 * MAV.rho * Va * MAV.S * MAV.b^2 *MAV.C_l_p; % eq 5.23
    a_phi2 = 0.5 * MAV.rho * Va ^2 * MAV.S * MAV.b*MAV.C_l_delta_a;

    tfs.G_phi_delta_a = tf([a_phi2], [1 a_phi2 0]);

    % Course - Roll 
    tfs.G_chi_phi = tf([MAV.g / Va], [1 0]);

    % Yaw - Roll
    tfs.G_psi_phi = tf([MAV.g / Va], [1 0]);
    
    % Sideslip - Rudder Deflection
    a_beta1 = -0.5 * (MAV.rho * Va * MAV.S * MAV.C_Y_beta)/(MAV.m);
    a_beta2 = 0.5 * (MAV.rho * Va * MAV.S * MAV.C_Y_delta_r)/(MAV.m);

    tfs.G_beta_delta_r = tf([a_beta2], [1 a_beta1]);

    %% Longitidinal Motion Transfer functions
    % Pitch - Elevator Deflection
    a_theta1 = -0.25 * (Va*MAV.rho * MAV.c^2 * MAV.S*MAV.C_M_q) / (MAV.Jy);
    a_theta2 = -0.5 * (Va^2 * MAV.rho * MAV.c * MAV.S * MAV.C_M_alpha) / (MAV.Jy);
    a_theta3 = 0.5 * (Va^2 * MAV.rho * MAV.c * MAV.S * MAV.C_M_delta_e) / (MAV.Jy);

    tfs.G_theta_delta_e = tf([a_theta3], [1 a_theta1, a_theta2]);
    tfs.G_q_delta_e = tf("s") * tfs.G_theta_delta_e;

    % Altitude - Va
    % [Warn]:  I am using pd as a state.
    tfs.G_h_theta = tf(Va, [1 0]);
    tfs.G_h_Va = tf(eta(2), [1 0]);

    % Airspeed - Thrust & Theta
    alpha = atan2(vel(3), vel(1)); 
    a_Va1 = ((MAV.rho * Va * MAV.S * (MAV.C_D0_ + MAV.C_D_alpha * alpha + MAV.C_D_delta_e * u(2))) ...
        +(MAV.rho*MAV.S_prop * MAV.C_prop*Va)) / (MAV.m);
    a_Va2 = (MAV.rho * MAV.S_prop * MAV.C_prop * MAV.K_motor^2 * u(4))/(MAV.m);
    a_Va3 = MAV.g * cos(eta(2) - eta(3));

    tfs.G_dVa_ddelta_t = tf(a_Va2, [1, a_Va1]);
    tfs.G_dVa_dtheta = tf(-a_Va3, [1, a_Va1]);

end