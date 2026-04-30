function figure_validation_predictive_checks()
%FIGURE_VALIDATION_PREDICTIVE_CHECKS
% Clean package version derived from the latest validation script:
% source: Fig1_260403.m

paths = package_paths(mfilename('fullpath'), 'validation_predictive_checks');
load(fullfile(paths.data_dir, 'fig2_overall.mat'), 'overall_modeled', 'overall_observed');
load(fullfile(paths.data_dir, 'route_err.mat'), 'new_route_err');

dateLabels = {'28 July', '29 July', '30 July'};

fig = plot_violin_vertical_distribution( ...
    overall_modeled(:, 1:3), overall_observed(1:3), dateLabels, ...
    'YLim', [0 420]);
ylabel('Numbers of interrupted trains');
export_figure_bundle(fig, paths.output_dir, 'interrupted_trains_predictive_check');

fig = plot_violin_vertical_distribution( ...
    overall_modeled(:, 4:6), overall_observed(4:6), dateLabels, ...
    'YLim', [0 7]);
ylabel('PAP (%)');
export_figure_bundle(fig, paths.output_dir, 'pap_predictive_check');

fig = plot_violin_vertical_distribution( ...
    overall_modeled(:, 7:9), overall_observed(7:9), dateLabels, ...
    'YLim', [0 110]);
ylabel('ATD (min)');
export_figure_bundle(fig, paths.output_dir, 'atd_predictive_check');

fig = plot_route_deviation_ecdf(new_route_err);
export_figure_bundle(fig, paths.output_dir, 'route_deviation_ecdf');

end

function fig = plot_route_deviation_ecdf(routeErrors)
x = max(routeErrors(:), 0);
x = x(~isnan(x));

[F, xs] = ecdf(x);
meanDeviation = mean(x, 'omitnan');
p0 = mean(x == 0);

fig = figure('Color', 'w', 'Position', [120 100 820 560]);
ax = axes('Parent', fig);
hold(ax, 'on');

plot(ax, xs, F, 'k-', 'LineWidth', 1.5);
ylim(ax, [max(0, p0 - 0.08) 1]);
plot(ax, [meanDeviation meanDeviation], ylim(ax), 'k--', 'LineWidth', 1);
text(ax, meanDeviation + 3, 0.88, sprintf('Mean deviation = %.2f km', meanDeviation), ...
    'Color', 'k', 'FontSize', 10);

xlabel(ax, 'Maximum route deviation (km)');
ylabel(ax, 'F(deviation)');
box(ax, 'off');
xlim(ax, [0 100]);

end

function fig = plot_violin_vertical_distribution(samplesMat, obsVec, labels, varargin)
p = inputParser;
addParameter(p, 'YLim', [], @(x) isempty(x) || (isnumeric(x) && isequal(size(x), [1 2])));
addParameter(p, 'HalfWidth', 0.38, @(x) isscalar(x) && x > 0);
addParameter(p, 'AlphaFill', 0.7, @(x) isscalar(x) && x >= 0 && x <= 1);
addParameter(p, 'Color', [0.75 0.83 0.98], @(x) isnumeric(x) && numel(x) == 3);
addParameter(p, 'LineWidthPI', 1, @(x) isscalar(x) && x > 0);
addParameter(p, 'MedianMarkerSize', 4, @(x) isscalar(x) && x > 0);
addParameter(p, 'ScalePercentile', 95, @(x) isscalar(x) && x > 0 && x <= 100);
addParameter(p, 'QRange', [0.5 99.5], @(x) isnumeric(x) && numel(x) == 2);
addParameter(p, 'PaddingFrac', 0.10, @(x) isscalar(x) && x >= 0 && x <= 0.5);
addParameter(p, 'NGrid', 256, @(x) isscalar(x) && x >= 64);
addParameter(p, 'AutoJitter', true, @islogical);
addParameter(p, 'JitterSigma', 0.12, @(x) isscalar(x) && x >= 0);
parse(p, varargin{:});
opt = p.Results;

samplesMat = double(samplesMat);
obsVec = double(obsVec(:)).';
labels = cellstr(labels);
K = size(samplesMat, 2);

Xcell = cell(1, K);
S = repmat(struct('med', NaN, 'lo95', NaN, 'hi95', NaN, 'obs', NaN), 1, K);
for i = 1:K
    xi = samplesMat(:, i);
    xi = xi(~isnan(xi));
    xi = max(xi, 0);
    Xcell{i} = xi;
    if ~isempty(xi)
        S(i).med = median(xi);
        S(i).lo95 = prctile(xi, 2.5);
        S(i).hi95 = prctile(xi, 97.5);
        S(i).obs = max(obsVec(i), 0);
    end
end

if isempty(opt.YLim)
    ymax = max([S.hi95, obsVec], [], 'omitnan');
    opt.YLim = [0, max(ymax, 1)];
end

fig = figure('Color', 'w', 'Position', [120 100 980 520]);
ax = axes('Parent', fig);
hold(ax, 'on');

xpos = 1:K;
for i = 1:K
    xi = Xcell{i};
    if isempty(xi)
        continue
    end
    draw_violin_vertical(ax, xi, xpos(i), opt);
end

piColor = [31 119 180] / 255;
capWidth = 0.06;
for i = 1:K
    if isnan(S(i).med)
        continue
    end
    x0 = xpos(i);
    line(ax, [x0 x0], [S(i).lo95 S(i).hi95], 'Color', piColor, 'LineWidth', opt.LineWidthPI);
    line(ax, [x0-capWidth x0+capWidth], [S(i).lo95 S(i).lo95], 'Color', piColor, 'LineWidth', opt.LineWidthPI);
    line(ax, [x0-capWidth x0+capWidth], [S(i).hi95 S(i).hi95], 'Color', piColor, 'LineWidth', opt.LineWidthPI);
    plot(ax, x0, S(i).med, 'o', ...
        'MarkerSize', opt.MedianMarkerSize, ...
        'MarkerFaceColor', piColor, ...
        'MarkerEdgeColor', piColor);
    plot(ax, x0, S(i).obs, 'rx', 'MarkerSize', opt.MedianMarkerSize + 4, 'LineWidth', 1);
end

set(ax, 'XTick', xpos, 'XTickLabel', labels, 'Box', 'off');
xlim(ax, [0.5 K + 0.5]);
ylim(ax, opt.YLim);

end

function draw_violin_vertical(ax, x, x0, opt)
x = x(:);
x = x(~isnan(x));
x = max(x, 0);
if isempty(x)
    return
end

if numel(unique(x)) == 1
    v = x(1);
    epsx = max(opt.HalfWidth * 0.03, 1e-6);
    epsy = max((opt.YLim(2) - opt.YLim(1)) * 0.002, 1e-6);
    patch('Parent', ax, ...
        'XData', [x0-epsx; x0+epsx; x0+epsx; x0-epsx], ...
        'YData', [v-epsy; v-epsy; v+epsy; v+epsy], ...
        'FaceColor', opt.Color, 'EdgeColor', 'none', 'FaceAlpha', opt.AlphaFill);
    return
end

if opt.AutoJitter
    isIntLike = all(abs(x - round(x)) < 1e-10);
    tieRatio = numel(unique(x)) / max(numel(x), 1);
    if (isIntLike || tieRatio < 0.25) && opt.JitterSigma > 0
        x = max(x + opt.JitterSigma * randn(size(x)), 0);
    end
end

qlo = prctile(x, opt.QRange(1));
qhi = prctile(x, opt.QRange(2));
if ~(isfinite(qlo) && isfinite(qhi)) || qhi <= qlo
    qlo = min(x);
    qhi = max(x);
end

pad = opt.PaddingFrac * max(qhi - qlo, eps);
yl = max(opt.YLim(1), max(0, qlo - pad));
yh = min(opt.YLim(2), qhi + pad);
if yh <= yl
    return
end

z = log1p(x);
zg = linspace(log1p(yl), log1p(yh), opt.NGrid);
fz = ksdensity(z, zg);
yg = exp(zg) - 1;
fy = fz ./ max(1 + yg, eps);

scale = prctile(fy, opt.ScalePercentile);
if ~(isfinite(scale) && scale > 0)
    scale = max(fy);
end
if scale <= 0
    return
end

half = opt.HalfWidth * (fy / scale);
half(half > opt.HalfWidth) = opt.HalfWidth;
patch('Parent', ax, ...
    'XData', [x0 - half(:); x0 + flipud(half(:))], ...
    'YData', [yg(:); flipud(yg(:))], ...
    'FaceColor', opt.Color, ...
    'EdgeColor', 'none', ...
    'FaceAlpha', opt.AlphaFill);

end
