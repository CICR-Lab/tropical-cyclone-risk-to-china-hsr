function figure_spatial_impacts_and_accessibility()
%FIGURE_SPATIAL_IMPACTS_AND_ACCESSIBILITY
% Clean package version derived from:
%   Fig4.m       (current-climate maps and accessibility maps)
%   Fig4_1225.m  (available scenario-1 and scenario-5 map blocks)

paths = package_paths(mfilename('fullpath'), 'spatial_impacts_and_accessibility');
[citiesShp, cityNames, nanhaiBoundary] = load_city_map_inputs(paths.data_dir);

load(fullfile(paths.data_dir, 'Fig4ab_cities_results_2shp.mat'), 'city_values_2shp');

cityMapColors = [
    0.97 0.97 0.97
    0.99 0.92 0.80
    0.99 0.82 0.60
    0.99 0.68 0.38
    0.94 0.39 0.26
    0.69 0.00 0.10
];

mapSpec = {
    'current_pap_map',      city_values_2shp(:, 1), '%',  [0 0.000001 0.0100 0.0300 0.0500 0.1000 Inf], 'Current climate PAP'
    'current_atd_map',      city_values_2shp(:, 2), 'min',[0 0.000001 5 10 15 30 Inf],                   'Current climate ATD'
    'scenario1_pap_map',    city_values_2shp(:, 3), '%',  [0 0.000001 0.0100 0.0300 0.0500 0.1000 Inf], 'Future scenario 1 PAP'
    'scenario1_atd_map',    city_values_2shp(:, 4), 'min',[0 0.000001 5 10 15 30 Inf],                   'Future scenario 1 ATD'
    'scenario5_pap_map',    city_values_2shp(:, 5), '%',  [0 0.000001 0.0100 0.0300 0.0500 0.1000 Inf], 'Future scenario 5 PAP'
    'scenario5_atd_map',    city_values_2shp(:, 6), 'min',[0 0.000001 5 10 15 30 Inf],                   'Future scenario 5 ATD'
};

for i = 1:size(mapSpec, 1)
    out = plot_regions_discrete(mapSpec{i, 2}, citiesShp, cityNames, ...
        'Units', mapSpec{i, 3}, ...
        'RegionValueEdges', mapSpec{i, 4}, ...
        'Colormap', cityMapColors, ...
        'FigTitle', mapSpec{i, 5}, ...
        'Basemap', 'darkwater');
    add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
    export_figure_bundle(out.figure_handle, paths.output_dir, mapSpec{i, 1});
end

load(fullfile(paths.data_dir, 'Fig4ef_city_metros_groups_acc_dec.mat'), ...
    'city_groups_acc_dec', 'city_metros_acc_dec');
load(fullfile(paths.data_dir, 'city_metros.mat'), 'city_metros');
load(fullfile(paths.data_dir, 'city_groups_checked.mat'), 'city_groups');

metroValues = nan(size(city_values_2shp(:, 2)));
metroNames = city_metros_acc_dec.name;
for i = 1:numel(city_metros)
    [~, idx] = ismember(city_metros(i).name, metroNames);
    metroValues(city_metros(i).cityID367) = city_metros_acc_dec.value(idx);
end

accessibilityColors1 = [
    0.97 0.97 0.97
    0.99 0.92 0.80
    0.99 0.68 0.38
    0.94 0.39 0.26
    0.69 0.00 0.10
];

out = plot_regions_discrete(metroValues, citiesShp, cityNames, ...
    'Units', '%', ...
    'RegionValueEdges', [0 0.000001 0.00001 0.0001 0.001 Inf], ...
    'Colormap', accessibilityColors1, ...
    'FigTitle', 'Metropolitan accessibility losses', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'metro_accessibility_loss_map');

groupValues = nan(size(city_values_2shp(:, 2)));
groupNames = city_groups_acc_dec.name;
for i = 1:numel(city_groups)
    [~, idx] = ismember(city_groups(i).name, groupNames);
    groupValues(city_groups(i).cityID367) = city_groups_acc_dec.value(idx);
end

accessibilityColors2 = [
    0.97 0.97 0.97
    0.99 0.92 0.80
    0.94 0.39 0.26
    0.69 0.00 0.10
];

out = plot_regions_discrete(groupValues, citiesShp, cityNames, ...
    'Units', '%', ...
    'RegionValueEdges', [0 0.000001 0.001 0.002 0.003], ...
    'Colormap', accessibilityColors2, ...
    'FigTitle', 'Megaregional and national accessibility losses', ...
    'Basemap', 'darkwater');
add_nanhai_boundary(out.geoaxes_handle, nanhaiBoundary);
export_figure_bundle(out.figure_handle, paths.output_dir, 'megaregion_accessibility_loss_map');

end

function add_nanhai_boundary(gx, nanhaiBoundary)
for i = 1:numel(nanhaiBoundary)
    geoplot(gx, nanhaiBoundary(i).Y, nanhaiBoundary(i).X, '-k');
end

end
