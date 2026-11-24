function info = errorInfo(err, scale, signalNames)
% ERRORINFO Calculate statistical metrics for error signals.
%
% Inputs:
%   err         : timeseries or numeric matrix (N x M)
%   scale       : scalar or 1 x M scaling vector (default: 1)
%   signalNames : names of error channels (optional)
%
% Output:
%   info        : table of error statistics
%
% N: number of samples
% M: number of channels

    %% Extract data
    if isa(err, 'timeseries')
        N = numel(err.Time);
        data = squeeze(err.Data);

        if err.IsTimeFirst
            data = reshape(err.Data, N, []);
        else
            data = reshape(err.Data, [], N).';
        end
    elseif isnumeric(err)
        data = squeeze(err);

        if isvector(data)
            data = data(:);
        end
    else
        error('Input must be a timeseries or numeric matrix.');
    end

    [~, M] = size(data);

    %% Default arguments
    if nargin < 2 || isempty(scale)
        scale = 1;
    end

    if nargin < 3 || isempty(signalNames)
        signalNames = compose("e%d", 1:M);
    end

    if isscalar(scale)
        scale = repmat(scale, 1, M);
    end

    assert(numel(scale) == M, ...
        'Scale must be scalar or match the channel count.');

    assert(numel(signalNames) == M, ...
        'Signal name count must match the channel count.');

    data = data .* reshape(scale, 1, []);

    %% Initialize results
    metrics = nan(M, 13);

    %% Calculate statistics
    for i = 1:M

        e = data(:, i);
        e = e(isfinite(e));

        metrics(i, 1) = numel(e);

        if isempty(e)
            continue;
        end

        absE = abs(e);

        metrics(i, :) = [
            numel(e), ...
            mean(e), ...
            median(e), ...
            std(e), ...
            min(e), ...
            max(e), ...
            prctile(e, 90), ...
            prctile(e, 99), ...
            mean(absE), ...
            sqrt(mean(e.^2)), ...
            prctile(absE, 90), ...
            prctile(absE, 99), ...
            max(absE)
        ];
    end

    %% Create output table
    info = array2table(metrics, ...
        'VariableNames', {
            'N', 'Mean', 'Median', 'Std', ...
            'Min', 'Max', 'P90', 'P99', ...
            'MAE', 'RMSE', ...
            'AbsP90', 'AbsP99', 'MaxAbs'
        }, ...
        'RowNames', cellstr(string(signalNames(:))));
end
