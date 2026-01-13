function sim_impulse = createImpulseForInputs()
    SIM = loadSIMParameters();
    delta_a_idx= 1;
    delta_e_idx = 2;
    delta_r_idx = 3;
    delta_t_idx = 4;
    t_sim = (0:SIM.FixedStepSize:SIM.StopTime)';
    n_steps = length(t_sim);

    u_impulse = zeros(n_steps, 4);

    % Impulse Indexes
    t_start = 2; % Must be smaller than SIM.StopTime
    duration = SIM.FixedStepSize * 5;

    start_idx = find(t_sim >= t_start, 1);
    end_idx = find(t_sim >= t_start + duration, 1);
    impulse_idx = delta_t_idx;

    % Impulse Amplitudes
    doublet_amp = 5 * pi / 180; % 25% deviation.

    u_impulse(start_idx:end_idx, impulse_idx) = doublet_amp; % 4 x N matrix. 

    sim_impulse = timeseries(u_impulse, t_sim);
end

