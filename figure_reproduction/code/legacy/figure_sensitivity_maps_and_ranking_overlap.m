function figure_sensitivity_maps_and_ranking_overlap()
%FIGURE_SENSITIVITY_MAPS_AND_RANKING_OVERLAP
% Clean package version derived from the latest sensitivity script:
% source: Fig5_1225.m

paths = package_paths(mfilename('fullpath'), 'sensitivity_maps_and_ranking_overlap');

load(fullfile(paths.data_dir, 'Fig5a_overall_sensi.mat'), 'overall_sensi');
relativeChange = (overall_sensi(:, 2:end) - overall_sensi(:, 1)) ./ overall_sensi(:, 1);
rowLabels = {'\Delta APAP', '\Delta AATD', '\Delta Economic loss', '\Delta 3hAL', '\Delta 2hAL', '\Delta 1hAL'};
colLabels = {'Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5'};
fig = bubble_signed_matrix(relativeChange', rowLabels, colLabels);
export_figure_bundle(fig, paths.output_dir, 'overall_sensitivity_bubble_matrix');

load(fullfile(paths.data_dir, 'Fig5bc_cities_X.mat'), 'X_cities_value');
[citiesShp, cityNames, nanhaiBoundary] = load_city_map_inputs(paths.data_dir);

cityMapColors = [
    0.97 0.97 0.97
    0.99 0.92 0.80
    0.99 0.82 0.60
    0.99 0.68 0.38
    0.94 0.39 0.26
    0.69 0.00 0.10
];

out = plot_regions_discrete(X_cities_value(:, 1), citiesShp, cityNames, ...
    'Units', '', ...
    'RegionValueEdges', [0 0.00001 1 1.5 2 3 Inf], ...
    'Colormap', cityMapColors, ...
    'FigTitle', 'X_{APAP} by city', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'x_apap_city_map');

out = plot_regions_discrete(X_cities_value(:, 2), citiesShp, cityNames, ...
    'Units', '', ...
    'RegionValueEdges', [0 0.00001 0.5 1 1.5 3 Inf], ...
    'Colormap', cityMapColors, ...
    'FigTitle', 'X_{AATD} by city', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'x_aatd_city_map');

load(fullfile(paths.data_dir, 'Fig5d-g_cities_values_sensi.mat'), 'cities_values_sensi');

[pctList, overlapMat, fig] = plot_topk_overlap( ...
    cities_values_sensi(:, [2 4 6 8 10]), ...
    'ExcludeZeroCurrent', true, ...
    'ScenarioNames', {'Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4'}, ...
    'YLimits', [0.5 1]);
export_figure_bundle(fig, paths.output_dir, 'apap_ranking_overlap_latest');
writematrix([pctList(:), overlapMat], fullfile(paths.output_dir, 'apap_ranking_overlap_latest.csv'));

[pctList, overlapMat, fig] = plot_topk_overlap( ...
    cities_values_sensi(:, [3 5 7 9 11]), ...
    'ExcludeZeroCurrent', true, ...
    'ScenarioNames', {'Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4'}, ...
    'YLimits', [0.5 1]);
export_figure_bundle(fig, paths.output_dir, 'aatd_ranking_overlap_latest');
writematrix([pctList(:), overlapMat], fullfile(paths.output_dir, 'aatd_ranking_overlap_latest.csv'));

end

function add_nanhai_boundary(gx, nanhaiBoundary)
for i = 1:numel(nanhaiBoundary)
    geoplot(gx, nanhaiBoundary(i).Y, nanhaiBoundary(i).X, '-k');
end

end

function fig = bubble_signed_matrix(M, rowLabels, colLabels)
[nRow, nCol] = size(M);
[xGrid, yGrid] = meshgrid(1:nCol, 1:nRow);
x = xGrid(:) + 0.5;
y = yGrid(:) + 0.5;
v = M(:);
valid = ~isnan(v);
x = x(valid);
y = y(valid);
v = v(valid);

maxAbs = max(abs(v));
if maxAbs == 0
    maxAbs = 1;
end
markerSizes = 40 + (abs(v) / maxAbs) * (600 - 40);

fig = figure('Color', 'w', 'Position', [100 100 820 360]);
ax = axes('Parent', fig);
scatter(ax, x, y, markerSizes, v, 'filled', 'MarkerEdgeColor', [0.3 0.3 0.3]);
set(ax, 'YDir', 'reverse', 'TickLength', [0 0], 'Box', 'off');
set(ax, 'XTick', [], 'YTick', []);

xLimits = xlim(ax);
yLimits = ylim(ax);
xpos = 0.5 + (1:nCol);
ypos = 0.5 + (1:nRow);

for c = 1:nCol
    text(ax, xpos(c), yLimits(2) + 0.5, colLabels{c}, ...
        'HorizontalAlignment', 'center', ...
        'Interpreter', 'tex', ...
        'FontSize', 9);
end
for r = 1:nRow
    text(ax, xLimits(1) - 0.2, ypos(r), rowLabels{r}, ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', ...
        'Interpreter', 'tex', ...
        'FontSize', 9);
end

colormap(ax, blue_white_red_7(256));
caxis(ax, [-maxAbs maxAbs]);
cb = colorbar(ax);
cb.Label.String = 'Relative change';
cb.Orientation = 'horizontal';

end

function cmap = blue_white_red_7(n)
anchors = [
      0   102 179
    102   170 207
    189   215 235
    255   255 255
    252   204 180
    241   138 119
    200    16  46
] / 255;

if nargin < 1
    cmap = anchors;
else
    tAnchors = linspace(0, 1, size(anchors, 1));
    t = linspace(0, 1, n);
    cmap = interp1(tAnchors, anchors, t, 'pchip');
end

end
