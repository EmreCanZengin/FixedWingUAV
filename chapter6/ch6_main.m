clear;clc;
run("Setup.m");

%% 
LNG_MODEL = 2; % Nonlinear Drag - Lift
TRIM_MODEL = "Trim_model";
TRIM_DATA_FILE = "ch6.mat";
SIMULATION_FILE = "Chapter6.slx";
ENVELOPE_DATA_FILE = "envelope.mat";
FIND_ENVELOPE = false;
Va_trim = 25;
R_trim = Inf;
gamma_trim = 0 * pi / 180;

TRIM = findTrim(TRIM_MODEL, Va_trim, R_trim, gamma_trim, TRIM_DATA_FILE);
MAV.init_states = TRIM.x;
TFS = computeTransferFunctions(TRIM);
DES = loadDesignParams();
AP = computeAutopilotGains(MAV, TRIM, TFS, DES);
disp("Autopilot gains are computed.")

CMD = struct();
CMD.Course = MAV.init_states(9);
CMD.Sideslip = TRIM.beta;
CMD.Airspeed = TRIM.Va;
CMD.Altitude = -TRIM.x(3);
LIM = loadSafetyLimits();
WIND = loadWindParameters();

% MAV.init_states(3) = -100;
% MAV.init_states(4) = 25;
% 
% CMD.Altitude = 500;
% CMD.Airspeed = 40;

%% Notes
%The autopilot fails when there are large differences between current and 
% commanded speed/altitude. The main problem is in the Climb Zone. To reach 
% a high target speed, the controller forces the UAV to dive. The UAV loses
% too much altitude while speeding up and hits the ground before it can 
% recover.

if FIND_ENVELOPE
    %% 
    Data.TRIM = TRIM;
    Data.MAV = MAV;
    Data.DES = DES;
    Data.AP = AP;
    Data.CMD = CMD;
    Data.LIM = LIM;
    Data.LNG_MODEL = LNG_MODEL;
    Data.SIM = SIM;
    
    Experiment.params = Data;
    
    Experiment.spaces.Va = 5:1:30;
    Experiment.spaces.h = 2:0.5:10;
    Experiment.spaces.phi = [-5, 5] * pi / 180;
    Experiment.spaces.theta = [-10, 10] * pi / 180;
    Experiment.spaces.psi = [-15, 15] * pi / 180;
    Experiment.ratio.u_outof_Va = [0.75, 0.9];
    Experiment.ratio.v_outof_Va = [0.15, 0.05];
    Experiment.ratio.w_outof_Va = [0.1, 0.05];
    
    Experiment.all_space = true;
    Experiment.model = SIMULATION_FILE;
    
    
    if ~isfile(which(ENVELOPE_DATA_FILE))
        Result = findEnvelope(Experiment);
        save(ENVELOPE_DATA_FILE, "Result")
    else
        disp("Loading variable Result from " + ENVELOPE_DATA_FILE)
        load(ENVELOPE_DATA_FILE, "Result");
    end
    
    if ~Experiment.all_space
        Va_all = Result.Va_grid(:);
        h_all = Result.h_grid(:);
        safe_indices = [Result.out.safe];
        
        fig = figure("Name", 'Va-H Launch Envelope Scatter', "Color", 'w');
        hold on; 
        scatter(Va_all(safe_indices), h_all(safe_indices), 80, 'g', 'filled', ...
            "o", "MarkerFaceAlpha", 0.6, "DisplayName", "Passed")
        scatter(Va_all(~safe_indices), h_all(~safe_indices), 80, 'r',...
            "x", "MarkerFaceAlpha", 0.6, "DisplayName", "Failed")
        grid on;
        xlabel('Launch Airspeed (V_a) [m/s]');
        ylabel('Launch Height (h) [m]');
        title('Aerosonde Launch Safety Map');
        legend('Location', 'best');
        hold off;
        xlim([min(Experiment.spaces.Va)-0.2,max(Experiment.spaces.Va)+0.2]);
        ylim([min(Experiment.spaces.h)-0.1, max(Experiment.spaces.h)+0.1])
    else
        Va_data = Result.Va_grid(:);
        h_data = Result.h_grid(:);
        safety_mask = [Result.out.safe]';
        
        Va_axis = unique(Va_data);
        h_axis = unique(h_data);
        n_h = length(h_axis);
        n_Va = length(Va_axis);
        
        Z = zeros(n_h, n_Va);
        for i=1:n_Va
            for j=1:n_h
                mask = (Va_data == Va_axis(i)) & (h_data == h_axis(j));
        
                Z(j, i) = mean(double(safety_mask(mask)));
            end
        end
        
        figure('Color', 'w', 'Name', 'Launch Robustness');
        imagesc(Va_axis, h_axis, Z);
        set(gca, 'YDir', 'normal');
        colorbar;
        colormap("parula")
        xlabel('Launch Speed (Va) [m/s]');
        ylabel('Launch Height (h) [m]')
        title ("UAV Launch Robustness Map")
        grid on;
    end
end