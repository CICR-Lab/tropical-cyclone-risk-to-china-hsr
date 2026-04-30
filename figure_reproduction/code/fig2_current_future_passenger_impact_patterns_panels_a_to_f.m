function fig2_current_future_passenger_impact_patterns_panels_a_to_f()
%FIG2_CURRENT_FUTURE_PASSENGER_IMPACT_PATTERNS_PANELS_A_TO_F
% Reproduces the code-backed Fig. 2 panels:
%   a-b  event-level PAP and ATD distributions under current vs SSP5-8.5
%   c-d  city-level annual APAP and AATD maps under the current climate
%   e-f  income-ranked cumulative affected-passenger share and delay curves
%
% Panels e-f are derived from the logic in equality_analysis.m and depend on
% method-model source_data/result_data files when those inputs are available.

fig2_current_future_passenger_impact_patterns_panels_a_to_d();

paths = package_paths(mfilename('fullpath'), 'fig2_current_future_passenger_impact_patterns');
[curveInputs, isReady, detailText] = load_fig2ef_inputs(paths);
if ~isReady
    warning('fig2_current_future_passenger_impact_patterns_panels_a_to_f:MissingInputs', ...
        'Skipping Fig. 2e-f because required method-model files are missing: %s', detailText);
    return
end

[fig, curveTable] = plot_cumulative_affected_passenger_share(curveInputs);
export_figure_bundle(fig, paths.output_dir, ...
    'fig2e_income_ranked_cumulative_share_of_affected_passengers');
writetable(curveTable, fullfile(paths.output_dir, ...
    'fig2e_income_ranked_cumulative_share_of_affected_passengers.csv'));

[fig, curveTable] = plot_cumulative_average_travel_delay(curveInputs);
export_figure_bundle(fig, paths.output_dir, ...
    'fig2f_income_ranked_average_travel_delay_among_affected_passengers');
writetable(curveTable, fullfile(paths.output_dir, ...
    'fig2f_income_ranked_average_travel_delay_among_affected_passengers.csv'));

end

function [curveInputs, isReady, detailText] = load_fig2ef_inputs(paths)
repoRoot = fileparts(paths.package_root);
methodRoot = fullfile(repoRoot, 'method_model');
sourceDir = fullfile(methodRoot, 'source_data');
resultDir = fullfile(methodRoot, 'result_data');

[currentRlPath, currentLabel] = first_existing_file(resultDir, ...
    {'current_city_RL.mat', 'current_city_RL_OD.mat'});
[futureRlPath, futureLabel] = first_existing_file(resultDir, ...
    {'future_city_RL.mat', 'future_city_RL_OD_585_7010_sim_2000.mat'});

requiredPaths = {
    currentRlPath, sprintf('%s or %s', 'current_city_RL.mat', 'current_city_RL_OD.mat')
    futureRlPath, sprintf('%s or %s', 'future_city_RL.mat', 'future_city_RL_OD_585_7010_sim_2000.mat')
    fullfile(sourceDir, 'city_Income.mat'), 'city_Income.mat'
    fullfile(sourceDir, 'city_pop.mat'), 'city_pop.mat'
    fullfile(sourceDir, 'rail_city.mat'), 'rail_city.mat'
    };

missingLabels = {};
for i = 1:size(requiredPaths, 1)
    if isempty(requiredPaths{i, 1}) || ~exist(requiredPaths{i, 1}, 'file')
        missingLabels{end + 1} = requiredPaths{i, 2}; %#ok<AGROW>
    end
end

curveInputs = struct();
if ~isempty(missingLabels)
    isReady = false;
    detailText = strjoin(missingLabels, ', ');
    return
end

load(currentRlPath, 'city_RL');
currentCityRl = city_RL;
load(futureRlPath, 'city_RL');
futureCityRl = city_RL;
load(fullfile(sourceDir, 'city_Income.mat'), 'city_Income');
load(fullfile(sourceDir, 'city_pop.mat'), 'city_pop');
load(fullfile(sourceDir, 'rail_city.mat'), 'rail_city');

cityIncome = city_Income;
cityIncome(~isfinite(cityIncome)) = 0;
citySet = unique(rail_city(:, 1));
cityIncome = cityIncome(citySet);
cityPopulation = city_pop(citySet);

currentPap = currentCityRl(:, 2);
futurePap = futureCityRl(:, 2);
currentAtd = currentCityRl(:, 10);
futureAtd = futureCityRl(:, 10);

nCommon = min([ ...
    numel(cityIncome), ...
    numel(cityPopulation), ...
    numel(currentPap), ...
    numel(futurePap), ...
    numel(currentAtd), ...
    numel(futureAtd)]);
if any([ ...
        numel(cityIncome), ...
        numel(cityPopulation), ...
        numel(currentPap), ...
        numel(futurePap), ...
        numel(currentAtd), ...
        numel(futureAtd)] ~= nCommon)
    warning('fig2_current_future_passenger_impact_patterns_panels_a_to_f:LengthMismatch', ...
        ['Fig. 2e-f inputs have inconsistent lengths. ', ...
        'Truncating all vectors to the first %d shared city entries.'], nCommon);
end

curveInputs = struct();
curveInputs.income = cityIncome(1:nCommon);
curveInputs.population = cityPopulation(1:nCommon);
curveInputs.current_pap = currentPap(1:nCommon);
curveInputs.future_pap = futurePap(1:nCommon);
curveInputs.current_atd = currentAtd(1:nCommon);
curveInputs.future_atd = futureAtd(1:nCommon);
curveInputs.current_rl_file = currentLabel;
curveInputs.future_rl_file = futureLabel;

isReady = true;
detailText = '';
end

function [filePath, fileLabel] = first_existing_file(folderPath, candidateNames)
filePath = '';
fileLabel = '';
for i = 1:numel(candidateNames)
    candidatePath = fullfile(folderPath, candidateNames{i});
    if exist(candidatePath, 'file')
        filePath = candidatePath;
        fileLabel = candidateNames{i};
        return
    end
end
end

function [fig, curveTable] = plot_cumulative_affected_passenger_share(curveInputs)
[sortIncome, sortIdx] = sort(curveInputs.income, 'ascend'); %#ok<ASGLU>
affectedCurrent = curveInputs.population .* curveInputs.current_pap;
affectedFuture = curveInputs.population .* curveInputs.future_pap;
affectedCurrent = affectedCurrent(sortIdx);
affectedFuture = affectedFuture(sortIdx);

nCity = numel(sortIdx);
xCurve = (0:nCity)' ./ nCity;
yCurrent = [0; cumsum(affectedCurrent) ./ max(sum(affectedCurrent), eps)];
yFuture = [0; cumsum(affectedFuture) ./ max(sum(affectedFuture), eps)];

fig = figure('Color', 'w', 'Position', [200 200 560 420]);
ax = axes('Parent', fig);
hold(ax, 'on');
plot(ax, xCurve, yCurrent, '-', ...
    'LineWidth', 2, ...
    'Color', [0.00 0.4470 0.7410], ...
    'DisplayName', 'Current scenario');
plot(ax, xCurve, yFuture, '-', ...
    'LineWidth', 2, ...
    'Color', [0.8500 0.3250 0.0980], ...
    'DisplayName', 'SSP5-8.5');

xlabel(ax, 'Cumulative city share (income-ranked)');
ylabel(ax, 'Cumulative share of affected passengers');
xlim(ax, [0 1]);
ylim(ax, [0 1]);
grid(ax, 'on');
box(ax, 'on');
legend(ax, 'Location', 'northwest');

curveTable = table( ...
    xCurve, ...
    yCurrent, ...
    yFuture, ...
    'VariableNames', {'CumulativeCityShare', 'CurrentScenario', 'SSP585'});
end

function [fig, curveTable] = plot_cumulative_average_travel_delay(curveInputs)
[sortIncome, sortIdx] = sort(curveInputs.income, 'ascend'); %#ok<ASGLU>
affectedCurrent = curveInputs.population .* curveInputs.current_pap;
affectedFuture = curveInputs.population .* curveInputs.future_pap;
affectedCurrent = affectedCurrent(sortIdx);
affectedFuture = affectedFuture(sortIdx);
delayCurrent = curveInputs.current_atd(sortIdx);
delayFuture = curveInputs.future_atd(sortIdx);

nCity = numel(sortIdx);
xCurve = (1:nCity)' ./ nCity;
yCurrent = nan(nCity, 1);
yFuture = nan(nCity, 1);
for i = 1:nCity
    currentWeight = affectedCurrent(1:i);
    futureWeight = affectedFuture(1:i);
    if sum(currentWeight) > 0
        yCurrent(i) = sum(delayCurrent(1:i) .* currentWeight) / sum(currentWeight);
    end
    if sum(futureWeight) > 0
        yFuture(i) = sum(delayFuture(1:i) .* futureWeight) / sum(futureWeight);
    end
end

fig = figure('Color', 'w', 'Position', [200 200 560 420]);
ax = axes('Parent', fig);
hold(ax, 'on');
plot(ax, xCurve, yCurrent, '-', ...
    'LineWidth', 2, ...
    'Color', [0.00 0.4470 0.7410], ...
    'DisplayName', 'Current scenario');
plot(ax, xCurve, yFuture, '-', ...
    'LineWidth', 2, ...
    'Color', [0.8500 0.3250 0.0980], ...
    'DisplayName', 'SSP5-8.5');

yAll = [yCurrent(isfinite(yCurrent)); yFuture(isfinite(yFuture))];
if isempty(yAll)
    yLimits = [0 1];
else
    yRange = max(yAll) - min(yAll);
    if yRange == 0
        yRange = max(abs(yAll(1)), 1);
    end
    yPad = 0.08 * yRange;
    yLimits = [min(yAll) - yPad, max(yAll) + yPad];
end

xlabel(ax, 'Cumulative city share (income-ranked)');
ylabel(ax, 'Average travel delay (min)');
xlim(ax, [0 1]);
ylim(ax, yLimits);
grid(ax, 'on');
box(ax, 'on');
legend(ax, 'Location', 'northeast');

curveTable = table( ...
    xCurve, ...
    yCurrent, ...
    yFuture, ...
    'VariableNames', {'CumulativeCityShare', 'CurrentScenario', 'SSP585'});
end
