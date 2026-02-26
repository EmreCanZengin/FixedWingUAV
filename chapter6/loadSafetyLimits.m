function LIM = loadSafetyLimits()
% This parameters are used to check the results in allowable limits.
% They are also used to stop the simulation in case of violation of these
% limits.
    LIM.Altitude.min = 1;   % [m] com altitude.
    LIM.Altitude.max = 500; % [m]

    LIM.Airspeed.max = 45;  % [m/s]

    LIM.Pitch.max = pi/2 * 0.95;    % rad
end