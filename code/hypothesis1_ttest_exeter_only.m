% load n-NRF magnitude data for Exeter
both_sites_magnitudes = readtable('both_sites_magnitudes.csv');
both_sites_magnitudes_hyp1 = both_sites_magnitudes(both_sites_magnitudes.hypothesis1_include == 1, :);

%% Exeter
exeter_magnitudes_hyp1 = both_sites_magnitudes_hyp1(both_sites_magnitudes_hyp1.Site == "Exeter",:);
exeter_lance = table2array(exeter_magnitudes_hyp1(:,12));
exeter_control = table2array(exeter_magnitudes_hyp1(:,11));

% t-test
[h,p,ci,stats] = ttest(exeter_lance, exeter_control, 'Tail', 'right', 'Alpha', 0.05)

% mean difference
meanEffectSize(exeter_lance,exeter_control,Paired=true)

%95% confidence interval for mean lance
mean(exeter_lance)
[h,p,ci,stats] = ttest(exeter_lance)
mean(exeter_control)
[h,p,ci,stats] = ttest(exeter_control)
