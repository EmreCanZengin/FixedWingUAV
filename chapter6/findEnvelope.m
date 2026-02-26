% This function evaluates the UAV's initial conditions across a defined search space 
% to detect safety-critical simulation terminations. It is primarily developed 
% to analyze the sensitivity of launch conditions and to determine the necessary 
% procedures and operational envelopes for a safe launch.
% Inputs:
%   Experiment - Struct containing model name, search spaces, and MAV parameters.
% Outputs:
%   Result     - Struct containing simulation outputs, safety flags, and success statistics.
% Example:
% 
% Data.TRIM = TRIM;
% Data.MAV = MAV;
% Data.Des = DES;
% Data.AP = AP;
% Data.CMD = CMD;
% Data.LIM = LIM;
% Data.LNG_MODEL = LNG_MODEL;
% Data.SIM = SIM;
% 
% Experiment.params = Data;
% 
% Experiment.spaces.Va = 5:1:30;
% Experiment.spaces.h = 2:0.5:10;
% Experiment.spaces.phi = [-5, 5] * pi / 180;
% Experiment.spaces.theta = [-10, 10] * pi / 180;
% Experiment.spaces.psi = [-15, 15] * pi / 180;
% Experiment.ratio.u_outof_Va = [0.75, 0.9];
% Experiment.ratio.v_outof_Va = [0.15, 0.05];
% Experiment.ratio.w_outof_Va = [0.1, 0.05];
% 
% Experiment.all_space = false;
% Experiment.model = model_name


function Result = findEnvelope(Experiment)
    Data = Experiment.params;

    % Main Search Space
    Va_test_space = Experiment.spaces.Va;
    h_test_space = Experiment.spaces.h;
    baseSimIn = Simulink.SimulationInput(Experiment.model);
    baseSimIn = baseSimIn.setVariable('AP', Data.AP);
    baseSimIn = baseSimIn.setVariable('DES', Data.DES);
    baseSimIn = baseSimIn.setVariable('SIM', Data.SIM);
    baseSimIn = baseSimIn.setVariable('TRIM', Data.TRIM);
    baseSimIn = baseSimIn.setVariable('LNG_MODEL', Data.LNG_MODEL);
    baseSimIn = baseSimIn.setVariable('CMD', Data.CMD);
    baseSimIn = baseSimIn.setVariable('LIM', Data.LIM);
    baseSimIn = baseSimIn.setModelParameter("SignalLogging", "off");
    %% Simulation Setting Up
    
    % Parpoll Setup
    cp = gcp("nocreate");
    if isempty(cp) 
        parpool("local", 4);
    elseif cp.NumWorkers ~= 4
        delete(cp)
        parpool("local", 4);
    else
    end
    
    if ~Experiment.all_space
        [Va_grid, h_grid] = meshgrid(Va_test_space, h_test_space);
        n_sims = numel(h_grid); % number of simulation 
        n_Va = length(Va_test_space);
        n_h = length(h_test_space);
        Result.Va_grid = Va_grid;
        Result.h_grid = h_grid;
  
        %%
        simin(1:n_sims) = baseSimIn;
        for i = 1:n_sims          
            tempMAV = Data.MAV; 
            tempMAV.init_states(3) = -h_grid(i);
            tempMAV.init_states(4) = Va_grid(i);
        
            simin(i) = simin(i).setVariable('MAV', tempMAV);
        end

    else
        % Secondory Search Space (Worst-cases)
        u_outof_Va = Experiment.ratio.u_outof_Va;
        v_outof_Va = Experiment.ratio.v_outof_Va;
        w_outof_Va = Experiment.ratio.w_outof_Va;
        norm_ratios = norm([u_outof_Va, v_outof_Va, w_outof_Va]);

        u_outof_Va = u_outof_Va / norm_ratios;
        v_outof_Va = v_outof_Va / norm_ratios;
        w_outof_Va = w_outof_Va / norm_ratios;

        Va_ratio_idx = 1:length(u_outof_Va);
    
        psi_test_space = Experiment.spaces.psi;
        theta_test_space = Experiment.spaces.theta;
        phi_test_space = Experiment.spaces.phi;
        
        [Va_g, h_g, r_idx_g, psi_g, theta_g, phi_g] = ndgrid(Va_test_space, ...
            h_test_space, Va_ratio_idx, psi_test_space, theta_test_space, phi_test_space);
        Result.Va_grid = Va_g;
        Result.h_grid = h_g;
        n_sims = numel(Va_g);
        simin(1:n_sims) = baseSimIn;
        for i = 1:n_sims
            tempMAV = Data.MAV;
    
            % Skewed Va
            tempMAV.init_states(4) = Va_g(i) * u_outof_Va(r_idx_g(i));
            tempMAV.init_states(5) = Va_g(i) * v_outof_Va(r_idx_g(i));
            tempMAV.init_states(6) = Va_g(i) * w_outof_Va(r_idx_g(i));
    
            % Skewed Attitude
            tempMAV.init_states(7) = phi_g(i);
            tempMAV.init_states(8) = theta_g(i);
            tempMAV.init_states(9) = psi_g(i);
    
            tempMAV.init_states(3) = - h_g(i);
            simin(i) = simin(i).setVariable('MAV', tempMAV);
        end     
    end           
            
    out = parsim(simin, 'ShowProgress', 'on');
    n_passed = 0;
    n_error = 0;
    n_tout = Data.SIM.StopTime / Data.SIM.FixedStepSize + 1; 
    Result.error_out = Simulink.SimulationOutput;
    warn_user = false;
    for i=1:n_sims
        if (~isempty(out(i).ErrorMessage))
            out(i).safe = false;
            out(i).has_error = true;
            warn_user = true;
            n_error = n_error + 1;
            continue;
        end
        n_sim_tout = length(out(i).tout);
        if n_sim_tout < n_tout
            out(i).safe = false;
        elseif n_sim_tout == n_tout
            out(i).safe = true;
            n_passed = n_passed + 1;
        else
            error("There is an inconsistency of variable SIM usage")
        end
    
    end
    if warn_user
        warning("There are errors in some simulations. You can check them with <Return_Name>.out.has_error")
    end
    Result.out = out;
    Result.n_passed = n_passed;
    Result.n_sims = n_sims;
    Result.n_error = n_error;
end