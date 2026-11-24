
function info = ctrlEffortInfo(uUnsat, uSat, ...
                              scale, actuatorNames, tol)
% CTRLEFFORTINFO Calculate control effort and saturation metrics.
%
% Inputs:
%   uUnsat        : unsaturated command timeseries
%   uSat          : saturated command timeseries
%   scale         : scalar or channel-wise scaling (default: 1)
%   actuatorNames : names of actuator channels (optional)
%   tol           : saturation detection tolerance (default: 1e-8)
%                   expressed in scaled command units
%
% Output:
%   info          : table of control effort metrics
%
% Assumption:
%   Commands are held constant between samples (ZOH).

    %% Extract time and command data
    [t1, Uunsat] = extractData(uUnsat);
    [t2, Usat]   = extractData(uSat);

    %% Validate inputs
    assert(isequal(size(Uunsat), size(Usat)), ...
        'Command dimensions must match.');

    assert(isequal(t1, t2), ...
        'Time vectors must match.');

    assert(all(isfinite(Uunsat(:))) && ...
           all(isfinite(Usat(:))), ...
        'Command data must be finite.');

    t = t2;

    assert(numel(t) >= 2, ...
        'At least two time samples are required.');

    dt = diff(t);

    assert(all(isfinite(t)) && all(dt > 0), ...
        'Time must be finite and strictly increasing.');

    T = t(end) - t(1);

    [~, M] = size(Usat);

    %% Default arguments
    if nargin < 3 || isempty(scale)
        scale = 1;
    end

    if nargin < 4 || isempty(actuatorNames)
        actuatorNames = compose("u%d", 1:M);
    end

    if nargin < 5 || isempty(tol)
        tol = 1e-8;
    end

    if isscalar(scale)
        scale = repmat(scale, 1, M);
    end

    if isscalar(tol)
        tol = repmat(tol, 1, M);
    end

    assert(numel(scale) == M && ...
           all(isfinite(scale(:))) && all(scale(:) > 0), ...
        'Scale must contain positive finite values.');

    assert(numel(tol) == M && ...
           all(isfinite(tol(:))) && all(tol(:) >= 0), ...
        'Tolerance must contain nonnegative finite values.');

    assert(numel(actuatorNames) == M, ...
        'Actuator name count must match channel count.');

    %% Apply scaling
    Uunsat = Uunsat .* reshape(scale, 1, []);
    Usat   = Usat   .* reshape(scale, 1, []);

    %% Initialize results
    metrics = zeros(M, 8);

    %% Calculate metrics for each actuator
    for i = 1:M

        u = Usat(:, i);

        % Saturation residual
        residual = Uunsat(:, i) - u;

        % Use left-hand samples for ZOH intervals
        upperSat = residual(1:end-1) >  tol(i);
        lowerSat = residual(1:end-1) < -tol(i);

        %% Control effort
        controlEffort = sum(u(1:end-1).^2 .* dt);

        %% Total variation
        totalVariation = sum(abs(diff(u)));

        %% Maximum absolute command
        maxAbsCommand = max(abs(u));

        %% Saturation percentages
        upperSatPercentage = ...
            100 * sum(dt(upperSat)) / T;

        lowerSatPercentage = ...
            100 * sum(dt(lowerSat)) / T;

        %% Continuous saturation events
        [maxUpperDuration, upperCount] = ...
            saturationEvents(upperSat, t);

        [maxLowerDuration, lowerCount] = ...
            saturationEvents(lowerSat, t);

        satEventCount = upperCount + lowerCount;

        %% Store results
        metrics(i, :) = [
            controlEffort, ...
            totalVariation, ...
            maxAbsCommand, ...
            upperSatPercentage, ...
            lowerSatPercentage, ...
            maxUpperDuration, ...
            maxLowerDuration, ...
            satEventCount
        ];
    end

    %% Create output table
    info = array2table(metrics, ...
        'VariableNames', {
            'ControlEffort', ...
            'TotalVariation', ...
            'MaxAbsCommand', ...
            'UpperSatPercentage', ...
            'LowerSatPercentage', ...
            'MaxUpperSatDuration', ...
            'MaxLowerSatDuration', ...
            'SatEventCount'
        }, ...
        'RowNames', cellstr(string(actuatorNames(:))));
end


%% Extract timeseries data
function [t, data] = extractData(signal)

    assert(isa(signal, 'timeseries'), ...
        'Inputs must be timeseries objects.');

    t = signal.Time(:);
    N = numel(t);

    if signal.IsTimeFirst
        data = reshape(signal.Data, N, []);
    else
        data = reshape(signal.Data, [], N).';
    end
end


%% Detect continuous saturation events
function [maxDuration, eventCount] = ...
    saturationEvents(mask, t)

    mask = logical(mask(:));

    transitions = diff([false; mask; false]);

    startIdx = find(transitions == 1);
    endIdx   = find(transitions == -1);

    eventCount = numel(startIdx);

    if eventCount == 0
        maxDuration = 0;
        return;
    end

    durations = t(endIdx) - t(startIdx);

    maxDuration = max(durations);
end
