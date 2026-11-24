
%% Benchmark analysis
% Run after simulation. AP_SRC must belong to the simulation being analysed.
% Requires existing errorInfo.m and ctrlEffortInfo.m on the MATLAB path.

%% Benchmark Configuration

SAVE_REPORTS = true;

EST_NAME = "ATT_EKF_001";
BENCHMARK_NAME = "Attitude_Feedback";

BENCHMARK_DESCRIPTION = ...
    "Attitude estimation feedback with unit delay (Ts: SIM.FixedStepSize).";

SCRIPT_DIRECTORY = fileparts(mfilename('fullpath'));

SAVE_DIRECTORY = fullfile( ...
    SCRIPT_DIRECTORY, '..', 'results', EST_NAME);

raw = extractBenchmarkSignals(out.logsout);
S = synchronizeSignals(raw);

%% Estimation performance
estReport = errorInfo(calculateEstimationErrors(S), ...
    180/pi, {'Roll','Pitch'});

%% True tracking performance
[err, names, scale] = calculateTrackingErrors(S);
trackingReport = errorInfo(err, scale, names);

%% Feedback tracking performance
feedbackReport = table();

if AP_SRC.USE_ATT_EST
    feedbackReport = errorInfo(calculateFeedbackErrors(S), ...
        180/pi, {'Roll','Pitch'});
end

%% Control effort
U = reconstructControlCommands(S);

effortReport = ctrlEffortInfo(U.actuatorUnsat, U.actuatorSat, ...
    [180/pi,180/pi,180/pi,1], ...
    {'Aileron','Rudder','Elevator','Throttle'});

outerLoopReport = ctrlEffortInfo(U.outerUnsat, U.outerSat, ...
    180/pi, {'RollCommand','PitchCommand'});

%% Display reports
fprintf('\n--- Estimation ---\n');
disp(estReport)

fprintf('\n--- True tracking ---\n');
disp(trackingReport)

if ~isempty(feedbackReport)
    fprintf('\n--- Attitude feedback tracking ---\n');
    disp(feedbackReport)
end

fprintf('\n--- Physical actuator effort ---\n');
disp(effortReport)

fprintf('\n--- Outer-loop commands ---\n');
disp(outerLoopReport)

BenchmarkResult = struct();
BenchmarkResult.Name = BENCHMARK_NAME;
BenchmarkResult.Description = BENCHMARK_DESCRIPTION;
BenchmarkResult.Date = datetime('now');

BenchmarkResult.Config.AP_SRC = AP_SRC;
BenchmarkResult.Config.Duration = S.t(end) - S.t(1);
BenchmarkResult.Config.SampleCount = numel(S.t);
BenchmarkResult.Config.EstimatorID = EST_NAME;

BenchmarkResult.Reports.Estimation = estReport;
BenchmarkResult.Reports.Tracking = trackingReport;
BenchmarkResult.Reports.Feedback = feedbackReport;
BenchmarkResult.Reports.ActuatorEffort = effortReport;
BenchmarkResult.Reports.OuterLoop = outerLoopReport;

%% Save Reports

if SAVE_REPORTS

    saveBenchmarkResults(BenchmarkResult, SAVE_DIRECTORY);

    estFile = fullfile(SAVE_DIRECTORY, "estimatorConfig.mat");

    save(estFile, 'EST');

    fprintf('Estimator configuration saved: %s\n', estFile);

end


%% Local functions

function S = extractBenchmarkSignals(logs)

    %% Extract buses
    plant = getSignal(logs,'all_states');
    latCmd = getSignal(logs,'Lat_CMD_BUS');
    lonCmd = getSignal(logs,'Lon_CMD_BUS');
    latEst = getSignal(logs,'Lat_EST_BUS');
    lonEst = getSignal(logs,'Lon_EST_BUS');

    %% Plant states
    S.eta = plant.toSensors.eta_I2B_rad_3x1;
    S.position = plant.toSensors.p_neh_inI_3x1;
    S.Va = plant.toSensors.Va;
    S.course = plant.course;
    S.beta = plant.beta;

    %% Reference commands
    S.courseCmd = latCmd.chi_cmd;
    S.betaCmd = latCmd.beta_cmd;
    S.hCmd = lonCmd.h_cmd;
    S.VaCmd = lonCmd.Va_cmd;

    S.phiCmd = getSignal(logs,'phi_cmd');
    S.thetaCmd = getSignal(logs,'theta_cmd');

    %% Estimator and selected feedback
    S.attEst = getSignal(logs,'attitude_ekf');

    S.phiFb = latEst.phi_hat;
    S.thetaFb = lonEst.theta_hat;

    %% Physical actuator commands
    S.ctrlSrf = getSignal(logs,'CTRL_SRF');

    S.daSat = getSignal(logs,'delta_a_sat');
    S.daUnsat = getSignal(logs,'delta_a_unsat');

    S.drSat = getSignal(logs,'delta_r_sat');
    S.drUnsat = getSignal(logs,'delta_r_unsat');

    S.deSat = getSignal(logs,'delta_e');
    S.deUnsat = getSignal(logs,'delta_e_unsat');

    S.dtSat2 = getSignal(logs,'delta_t_sat2');
    S.dtUnsat2 = getSignal(logs,'delta_t_unsat2');

    %% Outer-loop commands
    S.phiUnsat = getSignal(logs,'phi_unsat');

    S.pitchSat13 = getSignal(logs,'pitch_cmd_sat13');
    S.pitchUnsat13 = getSignal(logs,'pitch_cmd_unsat13');

    S.pitchSat2 = getSignal(logs,'pitch_cmd_sat2');
    S.pitchUnsat2 = getSignal(logs,'pitch_cmd_unsat2');

    S.thetaTakeoff = getSignal(logs,'theta_takeoff_cmd');

    %% Flight mode
    S.zone = getSignal(logs,'zone');

end


function value = getSignal(logs,name)

    element = logs.getElement(name);
    value = element.Values;

end


function S = synchronizeSignals(raw)

    % Use final actuator command timestamps as the common time grid.

    t = unique(raw.ctrlSrf.Time(:),'last');

    assert(numel(t)>=2 && ...
           all(isfinite(t)) && all(diff(t)>0), ...
        'Invalid CTRL_SRF time grid.');

    S.t = t;

    names = fieldnames(raw);

    for k = 1:numel(names)

        name = names{k};

        S.(name) = resampleZOH(raw.(name),t,name);

    end

end


function y = resampleZOH(ts,tQuery,name)

    assert(isa(ts,'timeseries'), ...
        'Expected timeseries: %s',name);

    t = double(ts.Time(:));
    N = numel(t);

    assert(N>0 && ...
           all(isfinite(t)) && all(diff(t)>=0), ...
        'Invalid timestamps: %s',name);

    %% Convert to N x M format
    if ts.IsTimeFirst
        data = reshape(ts.Data,N,[]);
    else
        data = reshape(ts.Data,[],N).';
    end

    data = double(data);

    %% Handle repeated timestamps
    [t,idx] = unique(t,'last');
    data = data(idx,:);

    %% Check initial time coverage
    % Allow roundoff at the initial timestamp only.
    % Do not fill earlier timestamps with future information.

    timeTol = 32*eps(max([1;abs(t);abs(tQuery)]));

    assert(tQuery(1)>=t(1)-timeTol, ...
        'Signal %s starts after the benchmark time grid.',name);

    %% Handle constant signals
    if numel(t)==1

        y = repmat(data,numel(tQuery),1);
        return

    end

    %% Zero-order hold
    % Hold the last known sample to the end.

    q = max(t(1),min(t(end),tQuery));

    % 'previous' implements ZOH, not linear interpolation.

    y = interp1(t,data,q,'previous');

end


function err = calculateEstimationErrors(S)

    % Estimated minus true.
    % Independent of selected feedback source.

    err = S.attEst(:,1:2)-S.eta(:,1:2);

end


function [err,names,scale] = calculateTrackingErrors(S)

    % Reference minus physical plant state.
    % Course remains linear, matching the current autopilot.
    % No angle wrapping.

    err = [
        S.courseCmd-S.course, ...
        S.hCmd-S.position(:,3), ...
        S.VaCmd-S.Va, ...
        S.betaCmd-S.beta, ...
        S.phiCmd-S.eta(:,1), ...
        S.thetaCmd-S.eta(:,2)
    ];

    names = {
        'Course', ...
        'Altitude', ...
        'Airspeed', ...
        'Sideslip', ...
        'Roll', ...
        'Pitch'
    };

    scale = [180/pi,1,1,180/pi,180/pi,180/pi];

end


function err = calculateFeedbackErrors(S)

    % Actual selected controller inputs,
    % including any estimator delay.

    err = [
        S.phiCmd-S.phiFb, ...
        S.thetaCmd-S.thetaFb
    ];

end


function U = reconstructControlCommands(S)

    %% Flight mode masks

    takeoff = S.zone==0;
    climbDescend = S.zone==1 | S.zone==3;
    hold = S.zone==2;

    assert(all(takeoff | climbDescend | hold), ...
        'Unknown flight zone.');

    %% Physical actuator commands
    % CTRL_SRF order:
    % Aileron, Rudder, Elevator, Throttle.

    assert(size(S.ctrlSrf,2)==4, ...
        'CTRL_SRF must have four channels.');

    actuatorSat = S.ctrlSrf(:, [1 3 2 4]);

    %% Reconstruct unsaturated throttle
    % Outside altitude hold, fixed throttle
    % is assumed not clipped.

    throttleUnsat = actuatorSat(:,4);

    throttleUnsat(hold) = S.dtUnsat2(hold);

    actuatorUnsat = [
        S.daUnsat, ...
        S.drUnsat, ...
        S.deUnsat, ...
        throttleUnsat
    ];

    %% Reconstruct active pitch commands

    pitchUnsat = S.thetaCmd;
    pitchSat = S.thetaCmd;

    % Zone 0: Takeoff

    pitchUnsat(takeoff) = S.thetaTakeoff(takeoff);
    pitchSat(takeoff) = S.thetaTakeoff(takeoff);

    % Zones 1 and 3: Climb and Descend

    pitchUnsat(climbDescend) = ...
        S.pitchUnsat13(climbDescend);

    pitchSat(climbDescend) = ...
        S.pitchSat13(climbDescend);

    % Zone 2: Altitude Hold

    pitchUnsat(hold) = S.pitchUnsat2(hold);
    pitchSat(hold) = S.pitchSat2(hold);

    %% Validate selected command paths
    % Tolerance in native command units.

    tol = 1e-6;

    validateCommand( ...
        [S.daSat,S.drSat,S.deSat], ...
        actuatorSat(:,1:3), ...
        tol,'Control surfaces');

    validateCommand( ...
        S.dtSat2(hold), ...
        actuatorSat(hold,4), ...
        tol,'Altitude-hold throttle');

    validateCommand( ...
        pitchSat,S.thetaCmd, ...
        tol,'Selected pitch command');

    %% Convert to timeseries

    U.actuatorUnsat = timeseries(actuatorUnsat,S.t);
    U.actuatorSat = timeseries(actuatorSat,S.t);

    U.outerUnsat = timeseries( ...
        [S.phiUnsat,pitchUnsat],S.t);

    U.outerSat = timeseries( ...
        [S.phiCmd,S.thetaCmd],S.t);

end


function validateCommand(expected,actual,tol,name)

    assert(isequal(size(expected),size(actual)), ...
        'Command size mismatch: %s',name);

    if isempty(expected)
        return
    end

    difference = abs(expected-actual);

    assert(all(isfinite(difference(:))) && ...
           all(difference(:)<=tol), ...
        ['%s mismatch (max difference %.6g). ' ...
         'Check signal paths and timestamps.'], ...
        name,max(difference(:)));

end

function saveBenchmarkResults(BenchmarkResult, saveDirectory)

%% Validate save directory
assert(isfolder(saveDirectory), ...
    'Save directory does not exist: %s', saveDirectory);

%% Generate file path
fileName = BenchmarkResult.Name + ".mat";
filePath = fullfile(saveDirectory, fileName);

%% Prevent accidental overwrite
if isfile(filePath)
    warning('Benchmark already exists: %s', filePath);
    fprintf('Existing benchmark was not overwritten.\n');
    return;
end

%% Save benchmark results
save(filePath, 'BenchmarkResult');

fprintf('\nBenchmark results saved successfully:\n');
fprintf('%s\n', filePath);

end