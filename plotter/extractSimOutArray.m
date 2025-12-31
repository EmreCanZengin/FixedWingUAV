function uu_nxt = extractSimOutArray(simout)
% Extracts the matrix of stored values in simulation
% Rows represent stored variables 
% Cols values at each time step. Data2plots in Simulation.slx
    uu_nxt = squeeze(simout);
end