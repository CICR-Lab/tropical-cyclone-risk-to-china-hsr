function fig3_downstream_accessibility_and_economic_losses_panels_a_to_c()
%FIG3_DOWNSTREAM_ACCESSIBILITY_AND_ECONOMIC_LOSSES_PANELS_A_TO_C
% Reproduces the code-backed Fig. 3 panels:
%   a  one-hour metropolitan accessibility loss
%   b  two-hour megaregional accessibility loss
%   c  sectoral economy-wide losses through the rail passenger channel

paths = package_paths(mfilename('fullpath'), 'fig3_downstream_accessibility_and_economic_losses');
[citiesShp, cityNames, nanhaiBoundary] = load_city_map_inputs(paths.data_dir);

load(fullfile(paths.data_dir, 'fig3ab_accessibility_loss_values.mat'), ...
    'city_groups_acc_dec', 'city_metros_acc_dec');
load(fullfile(paths.data_dir, 'fig3a_metropolitan_area_lookup.mat'), 'city_metros');
load(fullfile(paths.data_dir, 'fig3b_megaregion_lookup.mat'), 'city_groups');
load(fullfile(paths.data_dir, 'fig2_fig3_city_level_current_and_future_impacts.mat'), 'city_values_2shp');

metroValues = nan(size(city_values_2shp(:, 2)));
metroNames = city_metros_acc_dec.name;
for i = 1:numel(city_metros)
    [~, idx] = ismember(city_metros(i).name, metroNames);
    metroValues(city_metros(i).cityID367) = city_metros_acc_dec.value(idx);
end

metroColors = [
    0.97 0.97 0.97
    0.99 0.92 0.80
    0.99 0.68 0.38
    0.94 0.39 0.26
    0.69 0.00 0.10
];

out = plot_regions_discrete(metroValues, citiesShp, cityNames, ...
    'Units', '%', ...
    'RegionValueEdges', [0 0.000001 0.00001 0.0001 0.001 Inf], ...
    'Colormap', metroColors, ...
    'FigTitle', 'One-hour metropolitan accessibility loss', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'fig3a_metropolitan_accessibility_loss');

groupValues = nan(size(city_values_2shp(:, 2)));
groupNames = city_groups_acc_dec.name;
for i = 1:numel(city_groups)
    [~, idx] = ismember(city_groups(i).name, groupNames);
    groupValues(city_groups(i).cityID367) = city_groups_acc_dec.value(idx);
end

groupColors = [
    0.97 0.97 0.97
    0.99 0.92 0.80
    0.94 0.39 0.26
    0.69 0.00 0.10
];

out = plot_regions_discrete(groupValues, citiesShp, cityNames, ...
    'Units', '%', ...
    'RegionValueEdges', [0 0.000001 0.001 0.002 0.003], ...
    'Colormap', groupColors, ...
    'FigTitle', 'Two-hour megaregional accessibility loss', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'fig3b_megaregional_accessibility_loss');

load(fullfile(paths.data_dir, 'fig3c_sectoral_economywide_losses.mat'), 'sector_AEL');
sectorOrder = [1:7, 9, 12, 13, 8, 10, 11, 14:211];
[fig, sectorSummary] = plot_top_stacked_bar( ...
    sector_AEL.annualEconomicLoss_million_, sector_AEL.sector, 10, ...
    'idx', sectorOrder, ...
    'Title', 'Sectoral economy-wide losses', ...
    'XLabel', 'Sectoral losses (million CNY)');
export_figure_bundle(fig, paths.output_dir, 'fig3c_sectoral_economywide_losses');
writetable(sectorSummary, fullfile(paths.output_dir, 'fig3c_sectoral_economywide_losses_summary.csv'));

end

function add_nanhai_boundary(gx, nanhaiBoundary)
for i = 1:numel(nanhaiBoundary)
    geoplot(gx, nanhaiBoundary(i).Y, nanhaiBoundary(i).X, '-k');
end
end

function [fig, summary] = plot_top_stacked_bar(vals, labels, nTop, varargin)
if isstring(labels)
    labels = cellstr(labels);
end
vals = vals(:);
labels = labels(:);

p = inputParser;
addParameter(p, 'Title', '', @(x) ischar(x) || isstring(x));
addParameter(p, 'XLabel', 'Sectoral losses (million CNY)', @(x) ischar(x) || isstring(x));
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
    legendLabels = [topLabels; {'Other'}];
else
    dataPlot = topVals.';
    legendLabels = topLabels;
end

summary = table(legendLabels, dataPlot.', 'VariableNames', {'Sector', 'Value_MillionCNY'});

fig = figure('Color', 'w', 'Position', [120 120 1080 240]);
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
