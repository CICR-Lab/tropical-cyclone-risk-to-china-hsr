%% ==============================
%  Input
%  city_PAP : N x 1; city_RL(:,2)
%  city_ATD: N x 1; city_RL(:,10)
%  city_Income: N x 1
%  city_pop: N x 1
% ===============================
clc;clear;
source_path='.\source_data\';
result_path='.\result_data\';
load(strcat(result_path,'current_city_RL.mat'),'city_RL');
current_city_RL=city_RL;
load(strcat(result_path,'future_city_RL.mat'),'city_RL');
future_city_RL=city_RL;
load(strcat(result_path,'future_city_RL_245_7010.mat'),'city_RL');
future_city_RL_2=city_RL;
load(strcat(result_path,'future_city_RL_585_7010_sim_rule2.mat'),'city_RL');
future_city_RL_3=city_RL;
load(strcat(result_path,'future_city_RL_585_7010_sim_rule1.mat'),'city_RL');
future_city_RL_4=city_RL;
load(strcat(source_path,'city_gdp.mat'),'city_gdp');
load(strcat(source_path,'city_Income.mat'),'city_Income');city_Income(isnan(city_Income))=0;
load(strcat(source_path,'city_pop.mat'),'city_pop');
load(strcat(source_path,'city_TF_mat.mat'),'city_TF_mat');
load(strcat(source_path,'rail_city.mat'),'rail_city');
city_set=unique(rail_city(:,1));
city_pop=city_pop(city_set);

current_PAP=current_city_RL(:,2)*100;
current_ATD=current_city_RL(:,10);

future_PAP=future_city_RL(:,2)*100;
future_ATD=future_city_RL(:,10);

future_PAP_2=future_city_RL_2(:,2)*100;
future_ATD_2=future_city_RL_2(:,10);

future_PAP_3=future_city_RL_3(:,2)*100;
future_ATD_3=future_city_RL_3(:,10);

future_PAP_4=future_city_RL_4(:,2)*100;
future_ATD_4=future_city_RL_4(:,10);

GDP = city_Income(city_set);

%% -------------------------------
% Weighted Gini function (GDP-weighted)
% -------------------------------
weighted_gini = @(x,w) ...
    sum(sum(w .* w' .* abs(x - x'))) / ...
    (2 * sum(w)^2 * (sum(w.*x)/sum(w)));


Gini_PAP_GDP  = weighted_gini(future_PAP.*city_pop,  GDP)
Gini_AATD_GDP = weighted_gini(future_ATD, GDP)

Gini_PAP_GDP_2  = weighted_gini(future_PAP_2.*city_pop,  GDP)
Gini_AATD_GDP_2 = weighted_gini(future_ATD_2, GDP)

Gini_PAP_GDP_3  = weighted_gini(future_PAP_3.*city_pop,  GDP)
Gini_AATD_GDP_3 = weighted_gini(future_ATD_3, GDP)

Gini_PAP_GDP_4  = weighted_gini(future_PAP_4.*city_pop,  GDP)
Gini_AATD_GDP_4 = weighted_gini(future_ATD_4, GDP)


%% ==============================
N = length(GDP);
% sort by GDP
[a, idx] = sort(GDP);
Num=20;
q = floor((0:Num) * N / Num);

quintile = cell(Num,1);
for i = 1:Num
    quintile{i} = idx(q(i)+1 : q(i+1));
end

% 计算 top-income-quintile 与 bottom-two-quintiles 的受影响乘客份额
total_PAP = sum(current_PAP.*city_pop);

% Top income quintile：最高 GDP 的 20% 城市（第 5 五分位）
top_ids = quintile{Num};
% Bottom two quintiles：最低 40% GDP 城市（第 1 + 第 2 五分位）
bottom_ids = quintile{1};

% 计算份额（百分比）
P_future=zeros(1,Num);
D_future=zeros(1,Num);
for n=1:Num
    P_future(n) = 100 * sum(current_PAP(quintile{n}).*city_pop(quintile{n}))/ total_PAP;
    D_future(n) = sum(current_ATD(quintile{n}).*current_PAP(quintile{n}).*city_pop(quintile{n}))/sum(current_PAP(quintile{n}).*city_pop(quintile{n}));
end

figure
bar(flip(P_future,2));
fprintf('\nShare of affected passengers by income group (current climate):\n');
fprintf('  Top income quintile cities:     %.2f%% of all affected passengers\n', P_now);
fprintf('  Bottom two income quintiles:    %.2f%% of all affected passengers\n', Q_now);
mean(current_ATD(top_ids))/mean(current_ATD(bottom_ids))

xlabel('Income ventile (cities ranked high \rightarrow low)');
ylabel('Share of affected passengers (%)');
xticks(1:20);
xticklabels(compose('%d',1:20));
xlim([0.5, 20+0.5]);

% reference line: equal share = 1/G
yline(100/G, '--', sprintf('Equal-share baseline (%.1f%%)',100/G), ...
      'LabelVerticalAlignment','bottom','LabelHorizontalAlignment','left');

%% ==============================
% 6. 累积概率分布图-PAP
% ==============================
A_now = city_pop .* current_PAP;
A_fut = city_pop .* future_PAP;
A_fut_2 = city_pop .* future_PAP_2;
A_fut_3 = city_pop .* future_PAP_3;
A_fut_4 = city_pop .* future_PAP_4;

[GDPs, idx] = sort(GDP, 'ascend');
A_now_s = A_now(idx);
A_fut_s = A_fut(idx);
A_fut_s_2 = A_fut_2(idx);
A_fut_s_3 = A_fut_3(idx);
A_fut_s_4 = A_fut_4(idx);
POPs=city_pop(idx);

cumPOP = cumsum(POPs);
x = cumPOP / cumPOP(end);         % 0~1

% ---- 4) y-axis: cumulative affected passengers share ----
cumA_now = cumsum(A_now_s);
cumA_fut = cumsum(A_fut_s);
cumA_fut_2 = cumsum(A_fut_s_2);
cumA_fut_3 = cumsum(A_fut_s_3);
cumA_fut_4 = cumsum(A_fut_s_4);

y_now = cumA_now / cumA_now(end); % 0~1
y_fut = cumA_fut / cumA_fut(end); % 0~1
y_fut_2 = cumA_fut_2 / cumA_fut_2(end); % 0~1
y_fut_3 = cumA_fut_3 / cumA_fut_3(end); % 0~1
y_fut_4 = cumA_fut_4 / cumA_fut_4(end); % 0~1

% Add origin for nicer curves
x0 = [0; x];
y0_now = [0; y_now];
y0_fut = [0; y_fut];
y0_fut_2 = [0; y_fut_2];
y0_fut_3= [0; y_fut_3];
y0_fut_4 = [0; y_fut_4];

% ---- 5) plot ----
figure('Color','w'); hold on; box on;

x0=(0:1:293)/293;
plot(x0, y0_now, '-', 'LineWidth', 2, 'MarkerSize', 4);
plot(x0, y0_fut, '-', 'LineWidth', 2, 'MarkerSize', 4);
plot(x0, y0_fut_2, '-', 'LineWidth', 2, 'MarkerSize', 4);
plot(x0, y0_fut_3, '-', 'LineWidth', 2, 'MarkerSize', 4);
plot(x0, y0_fut_4, '-', 'LineWidth', 2, 'MarkerSize', 4);

% equality line (no concentration by GDP)
% plot([0 1], [0 1], '--', 'LineWidth', 1);

xlabel('Cumulative city share (income-ranked)');
ylabel('Cumulative share of affected passengers');

legend({'Current', 'Future scenario 1', 'Future scenario 2', 'Future scenario 3', 'Future scenario 4'}, 'Location', 'southeast');

% optional: show end-point labels
% text(0.02,0.95,sprintf('N = %d cities',N),'Units','normalized');

grid on;



%% ==============================
% 6. 累积概率分布图-ATD
% ==============================
%% ==========================================================
%  FIGURE 2: Ventile plot (GDP ranked high -> low), weighted mean delay
%           y = sum(ATD * affected)/sum(affected)
% ==========================================================
% Rank by GDP high -> low for ventiles (as in your bar plot)
[GDP_desc, idxDesc] = sort(GDP, 'descend');
aff_cur_desc = A_now(idxDesc);
aff_fut_desc = A_fut(idxDesc);
ATD_cur_desc = current_ATD(idxDesc);
ATD_fut_desc = future_ATD(idxDesc);
ATD_fut_desc_2 = future_ATD_2(idxDesc);
ATD_fut_desc_3 = future_ATD_3(idxDesc);
ATD_fut_desc_4 = future_ATD_4(idxDesc);

nVentiles=293;

n = numel(GDP_desc);
edges = round(linspace(0, n, nVentiles+1));  % equal-count bins by city
edges(end) = n; % ensure last equals n

ventileATD_cur = nan(nVentiles,1);
ventileATD_fut = nan(nVentiles,4);
ventileAffShare_cur = nan(nVentiles,1);
ventileAffShare_fut = nan(nVentiles,1);

totAffCur = sum(aff_cur_desc);
totAffFut = sum(aff_fut_desc);

for v = 1:nVentiles
    i1 = edges(v)+1;
    ids = 1:i1;

    % Weighted mean delay among affected passengers in this ventile
    w_cur = aff_cur_desc(ids);
    w_fut = aff_fut_desc(ids);

    if sum(w_cur) > 0
        ventileATD_cur(v) = sum(ATD_cur_desc(ids).*w_cur) / sum(w_cur);
    else
        ventileATD_cur(v) = NaN; % no affected passengers in this bin
    end

    if sum(w_fut) > 0
        ventileATD_fut(v,1) = sum(ATD_fut_desc(ids).*w_fut) / sum(w_fut);
        ventileATD_fut(v,2) = sum(ATD_fut_desc_2(ids).*w_fut) / sum(w_fut);
        ventileATD_fut(v,3) = sum(ATD_fut_desc_3(ids).*w_fut) / sum(w_fut);
        ventileATD_fut(v,4) = sum(ATD_fut_desc_4(ids).*w_fut) / sum(w_fut);
    else
        ventileATD_fut(v,:) = NaN;
    end

    % Also compute share of affected passengers (optional, useful for context)
    ventileAffShare_cur(v) = 100 * sum(w_cur) / max(eps, totAffCur);
    ventileAffShare_fut(v) = 100 * sum(w_fut) / max(eps, totAffFut);
end

figure('Color','w'); hold on;
x = 1:nVentiles;
plot(x0(2:end), ventileATD_cur, '-','LineWidth',1.8,'MarkerSize',5);
plot(x0(2:end), ventileATD_fut(:,1), '-','LineWidth',1.8,'MarkerSize',5);
plot(x0(2:end), ventileATD_fut(:,2), '-','LineWidth',1.8,'MarkerSize',5);
plot(x0(2:end), ventileATD_fut(:,3), '-','LineWidth',1.8,'MarkerSize',5);
plot(x0(2:end), ventileATD_fut(:,4), '-','LineWidth',1.8,'MarkerSize',5);
grid on; box on;
legend({'Current', 'Future'});

xlabel('Cumulative fraction of ordered by income');
ylabel('Average travel delay (min)');


