function AP = computeAutopilotGains(MAV, TRIM, TFS, DES)
    AP = struct(); % AP: Autopilot

    %% Lateral AutoPilot

    %% Roll Attitude Hold Control Loop
    a_phi2 = TFS.lat.a_phi2;
    a_phi1 = TFS.lat.a_phi1;

    scaling_fac = DES.delta_a_max / DES.Roll.error_max ;
    AP.Roll.Kp = scaling_fac * sign(a_phi2);
    AP.Roll.wn = sqrt( scaling_fac * abs(a_phi2));
    AP.Roll.Kd = (2 * DES.Roll.zeta * AP.Roll.wn - a_phi1) / a_phi2;
    
    % Book suggested root-locus based design for Ki.
    % Routh's Criterion + BW Seperation
    % this refers to how aggressive the integral action is
    zero_location = AP.Roll.wn / DES.Roll.integrator_split; 
    Ki_cand = AP.Roll.Kp * zero_location;
    
    % Routh's criterion.
    stability_limit = AP.Roll.Kp * 2 * DES.Roll.zeta * AP.Roll.wn;
    if Ki_cand > stability_limit
        warning("Roll Loop: Ki violates stability criterion. Default value has chose.")
        AP.Roll.Ki = stability_limit * 0.5;
    else
        AP.Roll.Ki = Ki_cand;
    end
    AP.Roll.zeta = DES.Roll.zeta;

    %% Course Hold Control Loop
    Vg = TRIM.Va; % Assumption
    wn_x = AP.Roll.wn / DES.Course.Wx_phi;

    AP.Course.Kp = 2 * DES.Course.zeta * wn_x * Vg / MAV.g;
    AP.Course.Ki = wn_x ^ 2 * Vg / MAV.g;
    AP.Course.wn = wn_x;
    AP.Course.zeta = DES.Course.zeta;
  
    %% SideSlip Hold Control Loop
    AP.Sideslip.Kp = DES.delta_r_max * sign(TFS.lat.a_beta2) / DES.Sideslip.error_max;
    AP.Sideslip.Ki = ((TFS.lat.a_beta1 + TFS.lat.a_beta2*AP.Sideslip.Kp) / (2*DES.Sideslip.zeta))^2 ...
                    / TFS.lat.a_beta2;
    AP.Sideslip.zeta = DES.Sideslip.zeta;
    AP.Sideslip.wn = sqrt(TFS.lat.a_beta2 * AP.Sideslip.Ki);
       
    
    %% Longitudinal AutoPilot

    %% Pitch Hold Control Loop
    a_theta1 = TFS.lon.a_theta1;
    a_theta2 = TFS.lon.a_theta2;
    a_theta3 = TFS.lon.a_theta3;

    AP.Pitch.Kp = DES.delta_e_max * sign(a_theta3) / DES.Altitude.Pitch.error_max;
    AP.Pitch.wn = sqrt(a_theta2 + AP.Pitch.Kp * a_theta3);
    AP.Pitch.Kd = (2 * DES.Pitch.zeta * AP.Pitch.wn - a_theta1)/ a_theta3;
    AP.Pitch.zeta = DES.Pitch.zeta;
    AP.Pitch.KDC = AP.Pitch.Kp * a_theta3 / (a_theta2 + AP.Pitch.Kp * a_theta3);
    % No integral action for pitch hold in this design because of bandwith consern.

    %% Altitude Hold Control Loop
    KDC = AP.Pitch.KDC;
    Va = TRIM.Va; 
    wn_h = AP.Pitch.wn / DES.Altitude.Wx_theta;

    AP.Altitude.Kp = (2*DES.Altitude.zeta * wn_h)/ (Va * KDC);
    AP.Altitude.Ki = (wn_h^2) / (Va * KDC);
    AP.Altitude.wn = wn_h;
    AP.Altitude.zeta = DES.Altitude.zeta;

    %% Airspeed Hold Control Loop
    a_Va1 = TFS.lon.a_Va1;
    a_Va2 = TFS.lon.a_Va2;
    a_Va3 = TFS.lon.a_Va3;

    % Airspeed Hold Control Loop (By Pitch Command)
    wn_Va = AP.Pitch.wn / DES.Airspeed.Pitch.Wx;
    AP.Airspeed.Pitch.Kp = (a_Va1 - 2*DES.Airspeed.Pitch.zeta * wn_Va) / (KDC * a_Va3);
    AP.Airspeed.Pitch.Ki = -(wn_Va^2) / (KDC * a_Va3);
    AP.Airspeed.Pitch.wn = wn_Va;
    AP.Airspeed.Pitch.zeta = DES.Airspeed.Pitch.zeta;

    % Airspeed Hold Control Loop (By Throttle Command)
    wn_Va = AP.Pitch.wn / DES.Airspeed.Throttle.Wx;
    AP.Airspeed.Throttle.Kp = (2*DES.Airspeed.Throttle.zeta*wn_Va - a_Va1) / (a_Va2);
    AP.Airspeed.Throttle.Ki = (wn_Va^2) / (a_Va2);
    AP.Airspeed.Throttle.wn = wn_Va;
    AP.Airspeed.Throttle.zeta = DES.Airspeed.Throttle.zeta;
end

