run('Setup.m');
disp("Running main file for chapter 5");

FINDOP_AND_LINEARIZE_SCRIPT_NAME = "findop_and_linearize.m";
FINDOP_AND_LINEARIZE_WS_DATA_NAME = "oper_point.mat";

% LNG_MODEL = 1; % 1: Linear Drag and Lift, 2: Nonlinear Drag and Lift.
PLOTTING_MODEL = 2; % 1: Online, 2: Post
POST_PLOTTING = 0; % 0: not animation, 1: animated

SIMULATION_NAME = "Chapter5.slx";
SIMOUT = "simout";

IMPULSE_ACTIVE = 0;

if (~isfile(which(FINDOP_AND_LINEARIZE_WS_DATA_NAME)))
    run(FINDOP_AND_LINEARIZE_SCRIPT_NAME);
else
    load(FINDOP_AND_LINEARIZE_WS_DATA_NAME)
end

t_sim = (0:SIM.FixedStepSize:SIM.StopTime)';
n_steps = length(t_sim);

u_impulse = zeros(n_steps, 4);
if IMPULSE_ACTIVE
% This function is written a little bad
% you need to define impulse signal in it manually.
    u_impulse = createImpulseForInputs(); 
end

out = sim(SIMULATION_NAME);


if PLOTTING_MODEL == 2
    is_anim = false;
    if POST_PLOTTING
        is_anim = true;
    end
    postPlotter(out.(SIMOUT), is_anim);
end