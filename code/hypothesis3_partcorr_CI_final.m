%% data prep

clear;

T = readtable("both_sites_magnitudes");

rows_to_exclude = find(T.hypothesis3_include == 0);

T(rows_to_exclude, :) = [];

cols_of_interest = [...
    "GestationalAgeAtStudy_weeks_",...
    "magnitude_HL",...
    "Site",...
    ];

T = T(:, cols_of_interest);

T.Site = str2double(replace(T.Site, {'UCL', 'Exeter'}, {'1', '0'}));

data = double(T.Variables);

data = zscore(data);

pma = data(:,1);
mag = data(:,2);
site = data(:,3);

%% get correlation point estimate

[rho,pval] = partialcorr(pma, mag, site,'Tail','right');

%% get distribution of correlations using bootstrapping

num_observations = size(site, 1);

num_bootstraps = 10000;

[~,bootsam] = bootstrp(num_bootstraps, [], (1 : num_observations)');

pma_bootstrapped = pma(bootsam);
mag_bootstrapped = mag(bootsam);
site_bootstrapped = site(bootsam);

rho_bootstrapped = zeros(num_bootstraps, 1);

for boostrap_counter = 1 : num_bootstraps

    pma_boot = pma_bootstrapped(:, boostrap_counter);
    mag_boot = mag_bootstrapped(:, boostrap_counter);
    site_boot = site_bootstrapped(:, boostrap_counter);

    rho_boot = partialcorr(pma_boot, mag_boot, site_boot);

    rho_bootstrapped(boostrap_counter) = rho_boot;

end

%% calculate confidence intervals from the bootstrapping results

rho_ci95_twosided = prctile(rho_bootstrapped,[2.5, 97.5]);

rho_ci95_onesided_lower = cat(2, prctile(rho_bootstrapped, 5), 1);

rho_ci95_onesided_upper = cat(2, -1, prctile(rho_bootstrapped, 95));

%% summarise results

rho_and_ci95_oneside = cat(2, rho, rho_ci95_onesided_lower);
