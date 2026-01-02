function op = findOp(model, Va, gamma, R)
    % Finds an operating point according to the values of parameters Va, gamma, R
    % regarding the trim points equation derived in the book.
    % [ASSUME] Va_3x1 = Vg_3x1

    % [WARN] I think there should be a limit for R due to the capability of
    % the aircraft. there should also be a limit for Va but
    % The book haven't taught how to consider this and I couldn't derive 
    % them from the formulas i have learned.

    % [WARN] If you change an integrator blocks name you gotta make sure
    % your function is defining operation specific because the order of
    % states might be changed.

    disp("Finding an operating point...");

    %% Define operation specification
    opspec = operspec(model);
    opspec = setStateOperSpec(opspec, Va, gamma, R);
    opspec = setInputOperSpec(opspec);
    opspec = setOutputOperSpec(opspec, Va);

    %% Optimization Options
    opt = findopOptions('DisplayReport', 'iter', ...
                    'OptimizerType', 'graddescent-elim');
    %% Run Optimization
    [op, op_report] = findop(model, opspec, opt);

    if (~contains(op_report.TerminationString, "successfully"))
        warning("`graddescent-elim` was unsuccessful. Trying `lsqnonlin` optimization...")
        opt = findopOptions('DisplayReport', 'iter', ...
                            'OptimizerType', 'lsqnonlin', ...
                            'OptimizationOptions', optimoptions('lsqnonlin', 'MaxIterations',2000));
        [op, op_report] = findop(model, opspec, opt);
        
        if (~contains(op_report.TerminationString, "successfully"))
            warning("`lsqnonlin` was unsuccessful. Loosing Va...")
            opspec.Outputs(1).Known = false;
            [op, op_report] = findop(model, opspec, opt);

            if(~contains(op_report.TerminationString, "successfully"))
                disp("The proposed options for finding operating point didn't work. Think something else...");
            else
                disp("`lsqnonlin` with loosen Va found an operating point.")
            end
        else
           disp("`lsqnonlin` found an operating point.")

        end
    else
        disp("`graddescent-elim` found an operating point.")
    end
    disp("Test the operating point.")
    
end

function opspec = setStateOperSpec(opspec, Va, gamma, R)
    % Steady state conditions

    % p_n, p_e: don't care, p_d: can have constant acceleration (handled later)
    opspec.States(1).SteadyState = [0;0;0];  
    opspec.States(2).SteadyState = [1;1;1];
    % roll rate can have constant acceleration (handled later)
    opspec.States(3).SteadyState = [1;1;0];
    opspec.States(4).SteadyState = [1;1;1];

    % Initial guesses: from the book
    opspec.States(2).x = [Va; 0; 0];
    opspec.States(3).x = [0;gamma;0];

    % States with range constraints
    opspec.States(3).Min = [-pi; -80 * pi / 180; -pi];
    opspec.States(3).Max = [pi; 80 * pi / 180; pi];

    % Derivative constraints
    opspec.States(2).dxMin = [-1e-6; -1e-6; -1e-6];
    opspec.States(2).dxMax = [ 1e-6;  1e-6;  1e-6];

    % Handling the cordinated-turn logic
    if (isinf(R))
        opspec.States(3).SteadyState(3) = 1;
    elseif (R == 0)
        warning("R can't be 0, It is assumed that the aircraft is not turning.")
        opspec.States(3).SteadyState(3) = 1;
    else
        opspec.States(3).dxMin(3) = Va / R * cos(gamma) - 1e-6;
        opspec.States(3).dxMax(3) = Va / R * cos(gamma) + 1e-6;
    end

    if (Va * sin(gamma) == 0)
        opspec.States(1).SteadyState(3) = 1;
    else
        opspec.States(1).dxMin(3) = -Va * sin(gamma) - 1e-6;
        opspec.States(1).dxMax(3) = -Va * sin(gamma) + 1e-6;
    end

end

function opspec = setInputOperSpec(opspec)
    opspec.Inputs(1).u = [0;0;0;1];
    opspec.Inputs(1).Min = [-20;-20;-20;0]*pi / 180;
    opspec.Inputs(1).Max = -opspec.Inputs(1).Min;
    opspec.Inputs(1).Max(4) = 1;
end

function opspec = setOutputOperSpec(opspec, Va)
    opspec.Outputs(1).Known = true;
    opspec.Outputs(1).y = Va;

    opspec.Outputs(2).Known = false;
    opspec.Outputs(2).Min = -pi/2;
    opspec.Outputs(2).Max = pi/2;

    opspec.Outputs(3).Known = true;
    opspec.Outputs(3).y = 0; % beta 
end