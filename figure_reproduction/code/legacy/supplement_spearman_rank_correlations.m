function resultsTable = supplement_spearman_rank_correlations()
%SUPPLEMENT_SPEARMAN_RANK_CORRELATIONS
% Compute the current-vs-future Spearman rank correlations for APAP and AATD
% from the packaged city-ranking workbook.

paths = package_paths(mfilename('fullpath'), 'supplementary_analysis');
sheetName = "图5d-g 不同情形下的城市排名-APAP-AATD值";
numericBlock = readmatrix( ...
    fullfile(paths.data_dir, 'fig4abcd_city_rankings_current_and_future.xlsx'), ...
    'Sheet', sheetName, ...
    'Range', 'C4:N366');

scenarioNames = {'Scenario 1'; 'Scenario 2'; 'Scenario 3'; 'Scenario 4'; 'Scenario 5'};

apapCurrent = numericBlock(:, 1);
aatdCurrent = numericBlock(:, 2);
apapFuture = numericBlock(:, [3 5 7 9 11]);
aatdFuture = numericBlock(:, [4 6 8 10 12]);
apapMask = apapCurrent > 0;
aatdMask = aatdCurrent > 0;

apapRho = nan(5, 1);
aatdRho = nan(5, 1);
for i = 1:5
    apapRho(i) = corr(apapCurrent(apapMask), apapFuture(apapMask, i), ...
        'Type', 'Spearman', 'Rows', 'complete');
    aatdRho(i) = corr(aatdCurrent(aatdMask), aatdFuture(aatdMask, i), ...
        'Type', 'Spearman', 'Rows', 'complete');
end

resultsTable = table(scenarioNames, apapRho, aatdRho, ...
    'VariableNames', {'Scenario', 'APAP_SpearmanRho', 'AATD_SpearmanRho'});

writetable(resultsTable, fullfile(paths.output_dir, 'spearman_rank_correlations_current_vs_future.csv'));
disp(resultsTable);

end
