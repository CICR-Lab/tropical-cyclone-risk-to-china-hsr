function out = plot_regions_discrete(regionSims, cityShps, cityNames, varargin)
%PLOT_REGIONS_DISCRETE Discrete polygon map for city-level or grouped results.
%
% regionSims can be:
%   1. [R x 1] deterministic values, or
%   2. [R x M] / [M x R] posterior draws, in which case the median is used.

p = inputParser;
addParameter(p, 'Basemap', 'grayland');
addParameter(p, 'FigTitle', '');
addParameter(p, 'Units', '');
addParameter(p, 'AdminEdgeColor', [0.82 0.82 0.82]);
addParameter(p, 'AdminLineWidth', 0.25, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'ShowLabels', false, @islogical);
addParameter(p, 'RegionValueEdges', [], @(x) isnumeric(x) && isvector(x));
addParameter(p, 'Colormap', parula(6), @(x) ischar(x) || isstring(x) || isnumeric(x));
addParameter(p, 'LatitudeLimits', [], @(x) isempty(x) || (isnumeric(x) && numel(x) == 2));
addParameter(p, 'LongitudeLimits', [], @(x) isempty(x) || (isnumeric(x) && numel(x) == 2));
parse(p, varargin{:});
opt = p.Results;

R = numel(cityNames);
if isvector(regionSims)
    medR = regionSims(:);
elseif size(regionSims, 1) == R
    medR = median(regionSims, 2, 'omitnan');
elseif size(regionSims, 2) == R
    medR = median(regionSims.', 2, 'omitnan');
else
    error('regionSims dimensions do not match the number of city polygons.');
end

centroids = nan(R, 2);
for i = 1:R
    xi = cityShps(i).X(:);
    yi = cityShps(i).Y(:);
    valid = ~isnan(xi) & ~isnan(yi);
    centroids(i, :) = [mean(xi(valid)), mean(yi(valid))];
end

if isempty(opt.RegionValueEdges)
    edges = prctile(medR, linspace(0, 100, 6));
    edges(1) = min(edges(1), min(medR));
    edges(end) = max(edges(end), max(medR));
else
    edges = sort(opt.RegionValueEdges(:).');
    if edges(1) > -Inf
        edges(1) = min(edges(1), min(medR));
    end
    if edges(end) < Inf
        edges(end) = max(edges(end), max(medR));
    end
end

edges = unique(edges, 'stable');
if numel(edges) < 2
    edges = [min(medR) max(medR)];
end
K = numel(edges) - 1;

if ischar(opt.Colormap) || isstring(opt.Colormap)
    cmap = feval(char(opt.Colormap), K);
else
    cmap = opt.Colormap;
    if size(cmap, 1) < K || size(cmap, 2) ~= 3
        error('Colormap must be a Kx3 array with at least K rows.');
    end
    cmap = cmap(1:K, :);
end

classIndex = nan(R, 1);
for i = 1:R
    v = medR(i);
    if isnan(v)
        continue
    end
    k = find(v >= edges(1:end-1) & v < edges(2:end), 1, 'last');
    if isempty(k)
        if v >= edges(end)
            k = K;
        else
            k = 1;
        end
    end
    classIndex(i) = k;
end

fig = figure('Color', 'w', 'Position', [80 80 760 620]);
gx = geoaxes('Parent', fig);
hold(gx, 'on');

try
    geobasemap(gx, string(opt.Basemap));
catch
    % Continue without a basemap if the environment does not support it.
end

try
    grid(gx, 'off');
catch
end

if ~isempty(opt.LatitudeLimits)
    geolimits(gx, opt.LatitudeLimits, opt.LongitudeLimits);
end

for i = 1:R
    poly = geopolyshape(cityShps(i).Y, cityShps(i).X);
    k = classIndex(i);
    if isnan(k)
        faceColor = 'none';
    else
        faceColor = cmap(k, :);
    end
    geoplot(gx, poly, ...
        'FaceColor', faceColor, ...
        'EdgeColor', opt.AdminEdgeColor, ...
        'LineWidth', opt.AdminLineWidth, ...
        'FaceAlpha', 1);
end

if opt.ShowLabels
    unitStr = '';
    if ~isempty(opt.Units)
        unitStr = [' ' opt.Units];
    end
    for i = 1:R
        label = sprintf('%s\n%s%s', string(cityNames{i}), local_numfmt(medR(i)), unitStr);
        text(gx, centroids(i, 1), centroids(i, 2), label, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 8, ...
            'BackgroundColor', 'w', ...
            'Margin', 1);
    end
end

legendHandles = gobjects(K, 1);
legendText = strings(K, 1);
for k = 1:K
    legendHandles(k) = plot(gx, nan, nan, 's', ...
        'MarkerSize', 10, ...
        'MarkerFaceColor', cmap(k, :), ...
        'MarkerEdgeColor', 'k');
    if k < K
        legendText(k) = sprintf('%s-%s %s', ...
            local_numfmt(edges(k)), local_numfmt(edges(k+1)), opt.Units);
    else
        legendText(k) = sprintf('>= %s %s', local_numfmt(edges(k)), opt.Units);
    end
end

legend(gx, legendHandles, strtrim(legendText), ...
    'Location', 'southwest', 'Orientation', 'vertical');
title(gx, string(opt.FigTitle));

out = struct();
out.figure_handle = fig;
out.geoaxes_handle = gx;
out.region_edges = edges;
out.region_median = medR;
out.class_index = classIndex;
out.centroids = centroids;
out.cmap = cmap;

function s = local_numfmt(x)
if isnan(x) || isinf(x)
    s = sprintf('%g', x);
    return;
end
if x == 0
    s = '0';
    return;
end
a = abs(x);
if a >= 100
    s = sprintf('%.0f', x);
elseif a >= 10
    s = sprintf('%.1f', x);
elseif a >= 1
    s = sprintf('%.2f', x);
elseif a >= 0.01
    s = sprintf('%.3f', x);
elseif a >= 0.001
    s = sprintf('%.4f', x);
else
    s = sprintf('%.2e', x);
end

end

end
