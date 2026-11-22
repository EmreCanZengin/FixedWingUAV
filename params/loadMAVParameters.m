function MAV = loadMAVParameters()
    MAV.init_states = zeros(12,1);
    MAV.init_states(3) = -100;
    MAV.init_states(4) = 36.67;
    MAV.Jx = 0.824;
    MAV.Jy = 1.135;
    MAV.Jz = 1.759;
    MAV.Jxz = 0.120;
    MAV.J_B_B = [MAV.Jx 0 -MAV.Jxz;
                0  MAV.Jy  0 
                -MAV.Jxz 0  MAV.Jz];

    MAV.m = 13.5;
    MAV.g = 9.80665;

    MAV.rho = 1.2682;
    MAV.b = 2.90;
    MAV.c = 0.19;
    MAV.S = 0.55;

    %% Nonlinear and Linear Lift and Draft Coefficient
    MAV.M = 50;
    MAV.alpha_0 = 0.4712;
    MAV.epsilon = 0.1592;% nereye ait bulamadim.
    MAV.C_e = 0.9; % Oswald efficiency factor
    MAV.C_AR = MAV.b^2 / MAV.S;
    MAV.C_D_p = 0.0437; 
    %% Lift Coefficients
    MAV.C_L0_ = 0.28;
    MAV.C_L_alpha = 3.45;
    MAV.C_L_delta_e = -0.36;
    MAV.C_L_q = 0;

    %% Drag Coefficients
    MAV.C_D0_ = 0.03;
    MAV.C_D_alpha = 0.30;

    MAV.C_D_delta_e = 0;
    MAV.C_D_q = 0;

    %% Pitch Moment Coefficients
    MAV.C_M_delta_e = -0.50;
    MAV.C_M_alpha = -0.38;
    MAV.C_M_0 = -0.02338;
    MAV.C_M_q = -3.6;

    %% Force in Body Y Axis Coefficients
    MAV.C_Y_0 = 0;
    MAV.C_Y_delta_a = 0;
    MAV.C_Y_delta_r = -0.17;

    MAV.C_Y_beta = -0.98;

    MAV.C_Y_p = 0;
    MAV.C_Y_r = 0;

    %% Roll Moment Coefficients
    MAV.C_l_0 = 0;
    MAV.C_l_delta_a = 0.08;
    MAV.C_l_delta_r = 0.105;

    MAV.C_l_beta = -0.12;

    MAV.C_l_p = -0.26;
    MAV.C_l_r = 0.14;

    %% Yaw Moment Coefficients
    MAV.C_n_0 = 0;
    MAV.C_n_delta_a = 0.06;
    MAV.C_n_delta_r = -0.032;

    MAV.C_n_beta = 0.25;

    MAV.C_n_p = 0.022;
    MAV.C_n_r = -0.35;

    %% Propulsion System Coefficients

    MAV.K_motor = 80;
    MAV.K_t_prop = 0;
    MAV.K_omega = 0;
    MAV.S_prop = 0.2027;
    MAV.C_prop = 1;
end