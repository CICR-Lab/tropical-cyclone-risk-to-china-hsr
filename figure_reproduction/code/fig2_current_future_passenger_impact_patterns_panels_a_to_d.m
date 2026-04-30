function fig2_current_future_passenger_impact_patterns_panels_a_to_d()
%FIG2_CURRENT_FUTURE_PASSENGER_IMPACT_PATTERNS_PANELS_A_TO_D
% Reproduces the code-backed Fig. 2 panels:
%   a-b  event-level PAP and ATD distributions under current vs SSP5-8.5
%   c-d  city-level annual APAP and AATD maps under the current climate
%
% This helper retains the original a-d implementation. The authoritative
% Fig. 2 runner is fig2_current_future_passenger_impact_patterns_panels_a_to_f.

paths = package_paths(mfilename('fullpath'), 'fig2_current_future_passenger_impact_patterns');

load(fullfile(paths.data_dir, 'fig2ab_current_vs_ssp585_event_windows.mat'), ...
    'comparison_current_future');

[fig, summaryTable] = plot_group_comparison( ...
    comparison_current_future(:, 1) * 100, ...
    comparison_current_future(:, 3) * 100, ...
    'PAP (%)', [0 5], ...
    [2.60 0.93], {'Doksuri', 'In-Fa'});
export_figure_bundle(fig, paths.output_dir, 'fig2a_event_level_pap_current_vs_ssp585');
writetable(summaryTable, fullfile(paths.output_dir, 'fig2a_event_level_pap_current_vs_ssp585_summary.csv'));

[fig, summaryTable] = plot_group_comparison( ...
    comparison_current_future(:, 2), ...
    comparison_current_future(:, 4), ...
    'ATD (min)', [0 80], ...
    [30.07 8.43], {'Doksuri', 'In-Fa'});
export_figure_bundle(fig, paths.output_dir, 'fig2b_event_level_atd_current_vs_ssp585');
writetable(summaryTable, fullfile(paths.output_dir, 'fig2b_event_level_atd_current_vs_ssp585_summary.csv'));

load(fullfile(paths.data_dir, 'fig2_fig3_city_level_current_and_future_impacts.mat'), 'city_values_2shp');
[citiesShp, cityNames, nanhaiBoundary] = load_city_map_inputs(paths.data_dir);

mapColors = [
    0.97 0.97 0.97
    0.99 0.92 0.80
    0.99 0.82 0.60
    0.99 0.68 0.38
    0.94 0.39 0.26
    0.69 0.00 0.10
];

out = plot_regions_discrete(city_values_2shp(:, 1), citiesShp, cityNames, ...
    'Units', '%', ...
    'RegionValueEdges', [0 0.000001 0.0100 0.0300 0.0500 0.1000 Inf], ...
    'Colormap', mapColors, ...
    'FigTitle', 'Current-climate APAP', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'fig2c_city_level_apap_current_climate');

out = plot_regions_discrete(city_values_2shp(:, 2), citiesShp, cityNames, ...
    'Units', 'min', ...
    'RegionValueEdges', [0 0.000001 5 10 15 30 Inf], ...
    'Colormap', mapColors, ...
    'FigTitle', 'Current-climate AATD', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'fig2d_city_level_aatd_current_climate');

end

function [fig, summaryTable] = plot_group_comparison(yCurrent, yFuture, yLabelText, yLimits, eventValues, eventNames)
[fig, stats] = half_violin_boxplot(yCurrent(:), yFuture(:), yLimits);
ax = findobj(fig, 'Type', 'Axes');
ax = ax(1);
ylabel(ax, yLabelText);
xticks(ax, [1 2]);
xticklabels(ax, {'Current scenario', 'SSP5-8.5'});

eventColor = [192 0 0] / 255;
for i = 1:numel(eventValues)
    plot(ax, 1, eventValues(i), 'o', ...
        'Color', eventColor, ...
        'MarkerFaceColor', eventColor);
    add_text_arrow(ax, [1.03, eventValues(i)], [1.13, eventValues(i)], eventNames{i});
end

summaryTable = table( ...
    ["Current scenario"; "SSP5-8.5"], ...
    [stats.median1; stats.median2], ...
    [stats.lo95_1; stats.lo95_2], ...
    [stats.hi95_1; stats.hi95_2], ...
    'VariableNames', {'Group', 'Median', 'PI95_Lower', 'PI95_Upper'});
summaryTable.PValue = [stats.p; stats.p];
end

function [fig, S] = half_violin_boxplot(y1, y2, yRange)
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

function add_nanhai_boundary(gx, nanhaiBoundary)
for i = 1:numel(nanhaiBoundary)
    geoplot(gx, nanhaiBoundary(i).Y, nanhaiBoundary(i).X, '-k');
end
end
