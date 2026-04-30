function [pctList, overlapMat, fig] = plot_topk_overlap(dataMat, varargin)
%PLOT_TOPK_OVERLAP Plot overlap ratios for top-ranked cities.
% Set 'ExcludeZeroCurrent' to true to filter out zero-current rows first.

p = inputParser;
addParameter(p, 'PctList', 10:10:100, @(x) isnumeric(x) && all(x > 0) && all(x <= 100));
addParameter(p, 'CurrentCol', 1, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'ScenarioCols', [], @(x) isnumeric(x) && ~isempty(x));
addParameter(p, 'ScenarioNames', {}, @(x) iscell(x) || isstring(x));
addParameter(p, 'SortDirection', 'descend', @(x) ischar(x) || isstring(x));
addParameter(p, 'Colors', [], @(x) isnumeric(x) && size(x, 2) == 3);
addParameter(p, 'ExcludeZeroCurrent', false, @(x) islogical(x) && isscalar(x));
addParameter(p, 'YLimits', [0.5 1], @(x) isnumeric(x) && numel(x) == 2);
parse(p, varargin{:});
opt = p.Results;

pctList = opt.PctList(:).';
currentCol = opt.CurrentCol;
scenarioCols = opt.ScenarioCols;
scenarioNames = opt.ScenarioNames;
sortDir = char(opt.SortDirection);

[N, nCol] = size(dataMat);
if isempty(scenarioCols)
    scenarioCols = setdiff(1:nCol, currentCol);
end
S = numel(scenarioCols);

if isempty(scenarioNames)
    scenarioNames = arrayfun(@(k) sprintf('Scenario %d', k), 1:S, 'UniformOutput', false);
end

if opt.ExcludeZeroCurrent
    rowMask = dataMat(:, currentCol) > 0;
else
    rowMask = true(size(dataMat, 1), 1);
end
dataMat = dataMat(rowMask, :);
N = size(dataMat, 1);
if N == 0
    error('plot_topk_overlap:NoRowsRemaining', ...
        'No cities remain after applying the current-column row filter.');
end

[~, idxCurrentSorted] = sort(dataMat(:, currentCol), sortDir);
nPct = numel(pctList);
overlapMat = nan(nPct, S);

for ip = 1:nPct
    pct = pctList(ip);
    k = max(1, round(pct / 100 * N));
    topCurrent = idxCurrentSorted(1:k);
    for is = 1:S
        [~, idxScenSorted] = sort(dataMat(:, scenarioCols(is)), sortDir);
        topScenario = idxScenSorted(1:k);
        overlapMat(ip, is) = numel(intersect(topCurrent, topScenario)) / k;
    end
end

if isempty(opt.Colors)
    colors = [
        216 79 20
        236 171 16
        146 80 160
        125 176 57
    ] / 255;
else
    colors = opt.Colors;
end

fig = figure('Color', 'w', 'Position', [120 120 760 500]);
ax = axes('Parent', fig);
hold(ax, 'on');

for is = 1:S
    plot(ax, pctList, overlapMat(:, is), '-o', ...
        'LineWidth', 1.5, ...
        'MarkerSize', 5, ...
        'Color', colors(is, :), ...
        'MarkerFaceColor', colors(is, :));
end

xlabel(ax, 'Top x% of cities');
ylabel(ax, 'Overlap ratio with current');
xlim(ax, [min(pctList) max(pctList)]);
ylim(ax, opt.YLimits);
grid(ax, 'on');
box(ax, 'on');
legend(ax, scenarioNames, 'Location', 'southeast');

end
