function figure_current_future_comparison_and_sector_losses()
%FIGURE_CURRENT_FUTURE_COMPARISON_AND_SECTOR_LOSSES
% Clean package version derived from:
%   Fig3_0108.m  (current vs scenario comparison)
%   Fig3.m       (sector-loss stacked bar helper)

paths = package_paths(mfilename('fullpath'), 'current_future_comparison_and_sector_losses');

load(fullfile(paths.data_dir, 'Fig3a_sector_annual_economic_loss_english.mat'), 'sector_AEL');
sectorOrder = [1:7, 9, 12, 13, 8, 10, 11, 14:211];
[fig, sectorSummary] = plot_top_stacked_bar( ...
    sector_AEL.annualEconomicLoss_million_, sector_AEL.sector, 10, ...
    'idx', sectorOrder, ...
    'Title', 'Annual economic loss by sector', ...
    'XLabel', 'Annual economic loss (million)');
export_figure_bundle(fig, paths.output_dir, 'sector_loss_stacked_bar');
writetable(sectorSummary, fullfile(paths.output_dir, 'sector_loss_top10_summary.csv'));

load(fullfile(paths.data_dir, 'Fig3bc_comparison_current_future.mat'), 'comparison_current_future');

[fig, summaryTable] = plot_group_comparison( ...
    comparison_current_future(:, 1) * 100, ...
    comparison_current_future(:, 3) * 100, ...
    'PAP (%)', [0 5], ...
    [2.60 0.93], {'Doksuri', 'In-Fa'});
export_figure_bundle(fig, paths.output_dir, 'pap_current_vs_scenario1');
writetable(summaryTable, fullfile(paths.output_dir, 'pap_current_vs_scenario1_summary.csv'));

[fig, summaryTable] = plot_group_comparison( ...
    comparison_current_future(:, 2), ...
    comparison_current_future(:, 4), ...
    'ATD (min)', [0 80], ...
    [30.07 8.43], {'Doksuri', 'In-Fa'});
export_figure_bundle(fig, paths.output_dir, 'atd_current_vs_scenario1');
writetable(summaryTable, fullfile(paths.output_dir, 'atd_current_vs_scenario1_summary.csv'));

end

function [fig, summaryTable] = plot_group_comparison(yCurrent, yScenario1, yLabelText, yLimits, eventValues, eventNames)
yCurrent = yCurrent(:);
yScenario1 = yScenario1(:);
[fig, stats] = half_violin_boxplot(yCurrent, yScenario1, yLimits);
ax = findobj(fig, 'Type', 'Axes');
ax = ax(1);
ylabel(ax, yLabelText);
xticks(ax, [1 2]);
xticklabels(ax, {'Current scenario', 'Scenario 1'});

eventColor = [192 0 0] / 255;
for i = 1:numel(eventValues)
    plot(ax, 1, eventValues(i), 'o', ...
        'Color', eventColor, ...
        'MarkerFaceColor', eventColor);
    add_text_arrow(ax, [1.03, eventValues(i)], [1.13, eventValues(i)], eventNames{i});
end

summaryTable = table( ...
    ["Current scenario"; "Scenario 1"], ...
    [stats.median1; stats.median2], ...
    [stats.lo95_1; stats.lo95_2], ...
    [stats.hi95_1; stats.hi95_2], ...
    'VariableNames', {'Group', 'Median', 'PI95_Lower', 'PI95_Upper'});
summaryTable.PValue = [stats.p; stats.p];

end

function [fig, S] = half_violin_boxplot(y1, y2, yRange)
y1 = y1(:);
y2 = y2(:);
fig = figure('Color', 'w', 'Position', [200 200 520 520]);
ax = axes('Parent', fig);
hold(ax, 'on');

halfWidth = 0.25;
draw_half_violin(ax, y1, 1.13, halfWidth, [0.80 0.85 0.95], yRange);
draw_half_violin(ax, y2, 2.13, halfWidth, [0.80 0.85 0.95], yRange);

jitter = 0.18;
scatter(ax, 1 + (rand(size(y1)) - 0.5) * jitter, y1, 16, ...
    'filled', 'MarkerFaceColor', [0.20 0.45 0.85], ...
    'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.10);
scatter(ax, 2 + (rand(size(y2)) - 0.5) * jitter, y2, 16, ...
    'filled', 'MarkerFaceColor', [0.20 0.45 0.85], ...
    'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.10);

b1 = boxchart(ax, ones(size(y1)), y1);
b1.BoxWidth = 0.25;
b1.BoxFaceColor = 'none';
b1.BoxEdgeColor = [0.2 0.2 0.2];
b1.WhiskerLineColor = [0.2 0.2 0.2];
b1.MarkerStyle = 'none';

b2 = boxchart(ax, 2 * ones(size(y2)), y2);
b2.BoxWidth = 0.25;
b2.BoxFaceColor = 'none';
b2.BoxEdgeColor = [0.2 0.2 0.2];
b2.WhiskerLineColor = [0.2 0.2 0.2];
b2.MarkerStyle = 'none';

xlim(ax, [0.5 2.5]);
ylim(ax, yRange);
ax.XTick = [1 2];
ax.LineWidth = 1;
grid(ax, 'off');

[p, ~, stats] = ranksum(y1, y2);
S = struct();
S.p = p;
S.z = stats.zval;
S.median1 = median(y1);
S.median2 = median(y2);
S.lo95_1 = prctile(y1, 2.5);
S.hi95_1 = prctile(y1, 97.5);
S.lo95_2 = prctile(y2, 2.5);
S.hi95_2 = prctile(y2, 97.5);

yLine = yRange(1) + 0.87 * (yRange(2) - yRange(1));
yText = yRange(1) + 0.89 * (yRange(2) - yRange(1));
plot(ax, [1 2], [yLine yLine], 'k-', 'LineWidth', 1.3);
text(ax, 1.5, yText, sprintf('P = %.4g', p), ...
    'HorizontalAlignment', 'center', ...
    'Color', 'k', 'FontSize', 11, 'FontWeight', 'bold');

text(ax, 1.13, S.median1, sprintf('MD = %.2f', S.median1), ...
    'HorizontalAlignment', 'left', ...
    'Color', 'k', 'FontSize', 10);
text(ax, 2.13, S.median2, sprintf('MD = %.2f', S.median2), ...
    'HorizontalAlignment', 'left', ...
    'Color', 'k', 'FontSize', 10);

end

function draw_half_violin(ax, y, x0, width, faceColor, yRange)
y = y(:);
y = y(isfinite(y));
yIn = y(y >= yRange(1) & y <= yRange(2));
if numel(unique(yIn)) < 3
    return
end

gridY = linspace(yRange(1), yRange(2), 200);
[f, ygrid] = ksdensity(yIn, gridY);
f = f ./ max(f) * width;
patch(ax, [x0 + f, x0 * ones(size(f))], [ygrid, fliplr(ygrid)], faceColor, ...
    'EdgeColor', 'none', 'FaceAlpha', 0.85);

end

function add_text_arrow(ax, pointXY, textXY, labelText)
fig = ancestor(ax, 'figure');
ax.Units = 'normalized';
axPos = ax.Position;
xl = xlim(ax);
yl = ylim(ax);
xNorm = @(x) axPos(1) + axPos(3) * (x - xl(1)) / (xl(2) - xl(1));
yNorm = @(y) axPos(2) + axPos(4) * (y - yl(1)) / (yl(2) - yl(1));

annotation(fig, 'textarrow', ...
    [xNorm(textXY(1)) xNorm(pointXY(1))], ...
    [yNorm(textXY(2)) yNorm(pointXY(2))], ...
    'String', labelText, ...
    'HeadLength', 8, ...
    'HeadWidth', 8, ...
    'Color', 'k', ...
    'FontSize', 10, ...
    'HorizontalAlignment', 'left');

end

function [fig, summary] = plot_top_stacked_bar(vals, labels, nTop, varargin)
if isstring(labels)
    labels = cellstr(labels);
end
vals = vals(:);
labels = labels(:);

p = inputParser;
addParameter(p, 'Title', '', @(x) ischar(x) || isstring(x));
addParameter(p, 'XLabel', 'Annual economic loss (million)', @(x) ischar(x) || isstring(x));
addParameter(p, 'idx', [], @(x) isempty(x) || isnumeric(x));
parse(p, varargin{:});
opt = p.Results;

if isempty(opt.idx)
    [~, idx] = sort(vals, 'descend');
else
    idx = opt.idx;
end

valsSorted = vals(idx);
labelsSorted = labels(idx);

nTop = max(1, min(nTop, numel(valsSorted)));
topVals = valsSorted(1:nTop);
topLabels = labelsSorted(1:nTop);

if nTop < numel(valsSorted)
    otherVal = sum(valsSorted(nTop + 1:end));
    dataPlot = [topVals; otherVal].';
    legendLabels = [topLabels; {'Others'}];
else
    dataPlot = topVals.';
    legendLabels = topLabels;
end

summary = table(legendLabels, dataPlot.', 'VariableNames', {'Sector', 'Value'});

fig = figure('Color', 'w', 'Position', [120 120 980 220]);
ax = axes('Parent', fig);
hold(ax, 'on');
hBar = barh(ax, 1, dataPlot, 'stacked');
colormap(ax, parula(numel(dataPlot)));
set(ax, 'YTick', []);
xlabel(ax, opt.XLabel);
title(ax, opt.Title);
xlim(ax, [0, sum(dataPlot) * 1.05]);
box(ax, 'off');
legend(hBar, legendLabels, 'Location', 'eastoutside');

end
