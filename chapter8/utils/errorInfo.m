
function T = estInfo(err, scale, stateNames)
% estInfo - State estimation error statistics
%
% Usage:
%   estInfo(err)
%   estInfo(err, scale)
%   estInfo(err, scale, stateNames)
%   T = estInfo(...)
%
% Input:
%   err        : timeseries or numeric vector/matrix
%   scale      : scalar or per-state vector (default = 1)
%   stateNames : cell array or string array (optional)
%
% Numeric matrix convention:
%   Rows = samples, columns = states.
%   If rows < columns, the matrix is transposed.
%
% Example:
%   estInfo(out.att_err, 180/pi, {'Roll','Pitch'});

    if nargin < 2 || isempty(scale)
        scale = 1;
    end

    if isa(err, 'timeseries')
        data = squeeze(err.Data);
        nTime = numel(err.Time);

        if isvector(data)
            data = data(:);
        elseif size(data, 1) == nTime
            % Already samples x states
        elseif size(data, 2) == nTime
            data = data.';
        else
            error('Cannot identify the time dimension.');
        end

    elseif isnumeric(err)
        data = squeeze(err);

        if isvector(data)
            data = data(:);
        elseif size(data, 1) < size(data, 2)
            data = data.';
        end
    else
        error('Input must be numeric or timeseries.');
    end

    data = double(data);
    nStates = size(data, 2);

    % Apply scale
    if isscalar(scale)
        scale = repmat(scale, 1, nStates);
    else
        scale = scale(:).';
        if numel(scale) ~= nStates
            error('Scale must be scalar or have one value per state.');
        end
    end

    data = data .* scale;

    % State names
    if nargin < 3 || isempty(stateNames)
        stateNames = arrayfun( ...
            @(i) sprintf('x(%d)', i), ...
            1:nStates, 'UniformOutput', false);
    else
        stateNames = cellstr(stateNames);
        if numel(stateNames) ~= nStates
            error('Number of state names must match state count.');
        end
    end

    % Allocate
    N      = zeros(nStates, 1);
    Mean   = zeros(nStates, 1);
    Median = zeros(nStates, 1);
    Std    = zeros(nStates, 1);
    Min    = zeros(nStates, 1);
    Max    = zeros(nStates, 1);
    P90    = zeros(nStates, 1);
    P99    = zeros(nStates, 1);
    MAE    = zeros(nStates, 1);
    RMSE   = zeros(nStates, 1);
    AbsP90 = zeros(nStates, 1);
    AbsP99 = zeros(nStates, 1);
    MaxAbs = zeros(nStates, 1);

    for i = 1:nStates
        e = data(:, i);
        e = e(isfinite(e));

        N(i) = numel(e);

        if isempty(e)
            Mean(i) = NaN;
            Median(i) = NaN;
            Std(i) = NaN;
            Min(i) = NaN;
            Max(i) = NaN;
            P90(i) = NaN;
            P99(i) = NaN;
            MAE(i) = NaN;
            RMSE(i) = NaN;
            AbsP90(i) = NaN;
            AbsP99(i) = NaN;
            MaxAbs(i) = NaN;
            continue
        end

        ae = abs(e);

        Mean(i)   = mean(e);
        Median(i) = median(e);
        Std(i)    = std(e);
        Min(i)    = min(e);
        Max(i)    = max(e);

        P90(i) = localPercentile(e, 90);
        P99(i) = localPercentile(e, 99);

        MAE(i)    = mean(ae);
        RMSE(i)   = sqrt(mean(e.^2));
        AbsP90(i) = localPercentile(ae, 90);
        AbsP99(i) = localPercentile(ae, 99);
        MaxAbs(i) = max(ae);
    end

    State = string(stateNames(:));

    T = table(State, N, Mean, Median, Std, ...
        Min, Max, P90, P99, MAE, RMSE, ...
        AbsP90, AbsP99, MaxAbs);

    disp(' ');
    disp('=== State Estimation Error Statistics ===');
    disp(T);
end

function value = localPercentile(x, pct)
% Linear interpolation, no toolbox required.
    x = sort(x(:));
    n = numel(x);

    if n == 1
        value = x(1);
        return
    end

    pos = 1 + (n - 1) * pct / 100;
    lo = floor(pos);
    hi = ceil(pos);
    weight = pos - lo;

    value = x(lo) + weight * (x(hi) - x(lo));
end
