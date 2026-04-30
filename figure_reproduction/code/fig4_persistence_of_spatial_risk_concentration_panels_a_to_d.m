function fig4_persistence_of_spatial_risk_concentration_panels_a_to_d()
%FIG4_PERSISTENCE_OF_SPATIAL_RISK_CONCENTRATION_PANELS_A_TO_D
% Reproduces the code-backed Fig. 4 panels:
%   a-b  top-ranked city-set overlap for APAP and AATD
%   c-d  top-10 current-city rank trajectories for APAP and AATD
%
% The latest caption refers to four alternative scenarios. The packaged
% script therefore uses the current climate plus scenarios 1-4, consistent
% with the latest overlap script variant in the repository.

paths = package_paths(mfilename('fullpath'), 'fig4_persistence_of_spatial_risk_concentration');
sheetName = "图5d-g 不同情形下的城市排名-APAP-AATD值";
workbookPath = fullfile(paths.data_dir, 'fig4abcd_city_rankings_current_and_future.xlsx');

numericBlock = readmatrix(workbookPath, 'Sheet', sheetName, 'Range', 'C4:N366');
cityNames = readcell(workbookPath, 'Sheet', sheetName, 'Range', 'B4:B366');

scenarioNames = {'Current scenario', 'Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4'};

apapMat = numericBlock(:, [1 3 5 7 9]);
aatdMat = numericBlock(:, [2 4 6 8 10]);
% Use the same nonzero-current subset for overlap, trajectories, and rho.
apapMask = apapMat(:, 1) > 0;
aatdMask = aatdMat(:, 1) > 0;
apapMatFiltered = apapMat(apapMask, :);
aatdMatFiltered = aatdMat(aatdMask, :);
apapCityNames = cityNames(apapMask);
aatdCityNames = cityNames(aatdMask);

[pctList, overlapMat, fig] = plot_topk_overlap(apapMatFiltered, ...
    'ScenarioNames', scenarioNames(2:end), ...
    'YLimits', [0.5 1]);
export_figure_bundle(fig, paths.output_dir, 'fig4a_apap_top_ranked_overlap');
writematrix([pctList(:), overlapMat], fullfile(paths.output_dir, 'fig4a_apap_top_ranked_overlap.csv'));

[pctList, overlapMat, fig] = plot_topk_overlap(aatdMatFiltered, ...
    'ScenarioNames', scenarioNames(2:end), ...
    'YLimits', [0.5 1]);
export_figure_bundle(fig, paths.output_dir, 'fig4b_aatd_top_ranked_overlap');
writematrix([pctList(:), overlapMat], fullfile(paths.output_dir, 'fig4b_aatd_top_ranked_overlap.csv'));

apapRanks = tiedrank_descending(apapMatFiltered);
aatdRanks = tiedrank_descending(aatdMatFiltered);

[fig, apapRhoTable] = plot_rank_trajectories(apapRanks, apapCityNames, scenarioNames, 'APAP rank trajectories');
export_figure_bundle(fig, paths.output_dir, 'fig4c_apap_rank_trajectories');
writetable(apapRhoTable, fullfile(paths.output_dir, 'fig4c_apap_rank_trajectories_spearman.csv'));

[fig, aatdRhoTable] = plot_rank_trajectories(aatdRanks, aatdCityNames, scenarioNames, 'AATD rank trajectories');
export_figure_bundle(fig, paths.output_dir, 'fig4d_aatd_rank_trajectories');
writetable(aatdRhoTable, fullfile(paths.output_dir, 'fig4d_aatd_rank_trajectories_spearman.csv'));

rhoTable = table( ...
    apapRhoTable.Scenario, ...
    apapRhoTable.SpearmanRho, ...
    aatdRhoTable.SpearmanRho, ...
    'VariableNames', {'Scenario', 'APAP_SpearmanRho', 'AATD_SpearmanRho'});
writetable(rhoTable, fullfile(paths.output_dir, 'fig4cd_spearman_rank_consistency.csv'));

end

function ranks = tiedrank_descending(valueMat)
[nCities, nScenarios] = size(valueMat);
ranks = nan(nCities, nScenarios);
for j = 1:nScenarios
    ranks(:, j) = tiedrank(-valueMat(:, j));
end
end

function [fig, rhoTable] = plot_rank_trajectories(rankMat, cityNames, scenarioNames, panelTitle)
topK = 10;
currentRanks = rankMat(:, 1);
[~, idxCurrent] = sort(currentRanks, 'ascend');
topIdx = idxCurrent(1:topK);
topNames = string(cityNames(topIdx));

trajectory = rankMat(topIdx, :);
trajectory(trajectory > topK) = topK + 1;

scenarioCount = size(rankMat, 2);
rho = nan(scenarioCount - 1, 1);
for j = 2:scenarioCount
    rho(j - 1) = corr(rankMat(:, 1), rankMat(:, j), 'Type', 'Spearman', 'Rows', 'complete');
end
rhoTable = table(string(scenarioNames(2:end)).', rho, ...
    'VariableNames', {'Scenario', 'SpearmanRho'});

fig = figure('Color', 'w', 'Position', [120 120 920 520]);
ax = axes('Parent', fig);
hold(ax, 'on');
colors = lines(topK);
for i = 1:topK
    plot(ax, 1:scenarioCount, trajectory(i, :), '-o', ...
        'LineWidth', 1.5, ...
        'MarkerSize', 5, ...
        'Color', colors(i, :), ...
        'MarkerFaceColor', colors(i, :), ...
        'DisplayName', topNames(i));
end

set(ax, 'XTick', 1:scenarioCount, 'XTickLabel', scenarioNames);
set(ax, 'YDir', 'reverse');
set(ax, 'YTick', [1 3 5 7 9 topK + 1], 'YTickLabel', {'1', '3', '5', '7', '9', 'Other'});
xlim(ax, [1 scenarioCount]);
ylim(ax, [1 topK + 1]);
ylabel(ax, 'Rank');
title(ax, panelTitle);
grid(ax, 'on');
box(ax, 'on');
legend(ax, 'Location', 'eastoutside');

rhoText = compose('%s: \\rho = %.3f', string(scenarioNames(2:end)).', rho);
text(ax, scenarioCount - 0.15, topK + 0.65, strjoin(cellstr(rhoText), newline), ...
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom', ...
    'FontSize', 9);
end
