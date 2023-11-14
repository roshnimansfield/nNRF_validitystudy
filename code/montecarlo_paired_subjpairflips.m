% Usage: tableMonteCarlo = montecarlo_fornewdata_adaptation(presec,postsec,fs,woody,data_control,data_noxious)

% Inputs: 
% - presec: start time of epoch in s (eg -0.5)
% - postsec: end time of epoch in s (eg 1)
% - woodystart: time to start woodyfiltering in seconds.
% - woodyend: end time of woodyfiltering in seconds. (e.g. to woodyfilter between 0 and
% 1 seconds, set woodystart = 0 and woodyend = 1).
% - fs: sampling rate in Hz (eg 2000)
% - woody: ms of woodyfiltering for woodyfiltering to average (eg 50)
% - data_control: control data with each column being a trial (eg EEG_data_all{1}(:,:,1));
% - data_noxious: lance data with each column being a trial (eg EEG_data_all{2}(:,:,1));
% 
% Output: 
% - tableMonteCarlo: table with clusters with p-values (also printed to screen)

% Code written by Caroline Hartley, adapted to function form by Marianne
% van der Vaart
% Adapted to conduct appropriate data analysis by and for Marianne Aspbury
% and Roshni Mansfield
% Latest version: November 2023

function tableMonteCarlo = montecarlo_paired_subjpairflips(presec,postsec,woodystart, woodyend,fs,woody,data_noxious,data_control)

cols = brewermap(10,'Dark2');

% set seeds for later
rand('seed',1)
randn('seed',1)

% comment to not woody filter / set to only woody if specified > 0
% woodyfilter
if woodystart > 0 || woodyend > 0 
    data_control_orig = woodyfilter_ave_new2(squeeze(data_control),woody,woody,100,woodystart,woodyend,presec,postsec,presec,postsec);
    data_noxious_orig = woodyfilter_ave_new2(squeeze(data_noxious),woody,woody,100,woodystart,woodyend,presec,postsec,presec,postsec);
    
    data_control = data_control_orig; 
    data_noxious = data_noxious_orig; 
end


%data_noxious = alldata_EEG_control_post;
%data_control = flip(alldata_EEG_control_pre);

% paired: get difference and calculate t-statistic at every point
data_noxious = squeeze(data_noxious);
data_control = squeeze(data_control);
data_difference = data_noxious - data_control; 
[~,~,~,stats] = ttest(permute(data_difference,[2,1]));
allt = reshape(stats.tstat,[],1);
n1 = size(data_difference,2); % number of subjects

% threshold: degrees of freedom = num subjects - 1
thres=tinv(0.975,(n1-1));
[clusters_no,clusters_start_original,clusters_end_original,...
    clusters_length_original]=seq_cluster(abs(allt),thres,...
    1,presec,postsec,fs,1);

clusters_size_original=zeros(clusters_no,1);
for i=1:clusters_no
    clusters_size_original(i)=sum(abs(allt(clusters_start_original(i):clusters_end_original(i))));
end

% maximum number of possible sign-flips
n = n1; 
max_perm_no = 2^n; % set maximum number of sign flips - too many
display(['Maximum number of sign-flips: ',num2str(max_perm_no)]); 

% actual permutation number
perm_no=10000; 
% We only care about the largest cluster
max_clusters = zeros(perm_no,1); 
max_clusters_size = zeros(perm_no,1); 

% use FSL PALM to generate position permutation matrix
% perm_no +1 since FSL palm includes non-permuted as 1st entry
% this permutes signs but returns row numbers - need to translate to +/-1 only
[Pset, VG] = palm_quickperms((1:n)',[],perm_no+1,false,true,false,false);
Pset(Pset<0) = -1;
Pset(Pset>0) = 1;
% 1st is true data so note that skip 1st entry in analysis
Pset = Pset(:,1:perm_no);
% perm_no = perm_no-1;


% thres=1.96;
for j=1:perm_no  
    % can print pos in loop but slows down for high permutation number
%      display([num2str(j), ' out of ', num2str(perm_no)])
    
    %  A) Random flips are from FSL above - pre-calculated
    
    %  B) Multiply differences by the sign flip - all of a subjs timept 
    %  data is flipped or not according to the sign
     permData = squeeze(data_difference) .* Pset(:,j)';
 
    %  C) Calculate paired t-statistic
    [~,~,~,stats] = ttest(permute(permData,[2,1]));
    allt_perm = reshape(stats.tstat,[],1);
    
    % Find clusters
    [clusters_no,clusters_start,clusters_end,clusters_length]=...
        seq_cluster(abs(allt_perm),thres,1,presec,postsec,fs,0);
    
    if ~isempty(clusters_length)
        max_clusters(j)=max(clusters_length); % find maximum cluster length for this permutation
        clusters_size=zeros(clusters_no,1); % for each cluster, sum the t-values in the cluster
        for c=1:clusters_no
            clusters_size(c)=sum(abs(allt_perm(clusters_start(c):clusters_end(c))));
        end
        max_clusters_size(j)=max(clusters_size); 
        max_clusters_length(j) = max(clusters_length); % find the maximum cluster size for this permutation
    end
    
end


% For each original cluster, find in how many of the permutations a an equally large/long or larger
% / longer cluster was found. Need to check if this is correct!
% 1st is true data so 1 to skip
pvals_tstats = ones(length(clusters_start_original),1);
pvals_length = ones(length(clusters_start_original),1);
for i=1:length(clusters_length_original)
    pvals_tstats(i) = sum(max_clusters_size >= clusters_size_original(i))/ perm_no;
    pvals_length(i) = sum(max_clusters_length >= clusters_length_original(i)) / perm_no;
end

% Let's add a funky histogram to view this
numbins = floor(perm_no / 10); 
figure; 
for i = 1:length(clusters_size_original)
    subplot(2,1,1); hold on; 
    histogram(max_clusters_size,numbins); 
    plot([clusters_size_original(i),clusters_size_original(i)],[0 500],'color',cols(i,:))
    title('Cluster size')
    subplot(2,1,2); hold on; 
    histogram(max_clusters_length, numbins); 
    plot([clusters_length_original(i),clusters_length_original(i)],[0 500], 'color',cols(i,:))
    title('Cluster length')
end

tableMonteCarlo = table(clusters_start_original/fs+presec,clusters_end_original/fs+presec,pvals_tstats, pvals_length);
tableMonteCarlo.Properties.VariableNames = {'Cluster_start','Cluster_end','p_value_tstat','p_value_length'}

% and plot the data with the identified clusters
figure; 
hold on; 
% plot(presec:1/2000:postsec,mean(data_control_orig,2))
% plot(presec:1/2000:postsec,mean(data_noxious_orig,2))
plot(presec:1/2000:postsec,mean(data_noxious,2))
plot(presec:1/2000:postsec,mean(data_control,2))
% figure; 
% hold on; 
% plot(presec:1/2000:postsec,mean(alldata_EEG_control,3))
% plot(presec:1/2000:postsec,mean(alldata_EEG_heellance,3))
% plot(presec:1/2000:postsec,mean(data_difference,3))
% plot(presec:1/2000:postsec,mean(permData,3))


% plot significant cluster boundaries from table with results
for i = 1:length(tableMonteCarlo.Cluster_start)
    if tableMonteCarlo.p_value_tstat(i) < 0.05
        plot([tableMonteCarlo.Cluster_start(i),tableMonteCarlo.Cluster_start(i)],[-10 30],'color',cols(i,:))
        plot([tableMonteCarlo.Cluster_end(i),tableMonteCarlo.Cluster_end(i)],[-10 30],'color',cols(i,:))
    end
end
% figureLayout('eeg')
legend('off')

% alternative plot of all clusters (if significant or not) from threshold
% includes postive and negative thresholds rather than absolute values
time=[presec:1/fs:postsec];
figure; plot(time,allt)
hold on
thres_above = thres*ones(length(time),1);
thres_below = -1*thres_above;
plot(time,thres_above,'k--')
plot(time,thres_below,'k--')
if ~isempty(clusters_start_original)
    for i = 1:length(tableMonteCarlo.Cluster_start)
        if allt(clusters_start_original(i)) < 0
            thres_plot = -thres;
        else
            thres_plot = thres;
        end
        plot(clusters_start_original(i)/fs+presec,thres_plot,'k.','markersize',10)
        plot(clusters_end_original(i)/fs+presec,thres_plot,'k.','markersize',10)
    end
end

hF(1)=fill(time,min(allt',thres_below'),'k','LineStyle','none');
% This one works for post vs pre for subjs
% set end point to not threshold value to avoid shading errors incase last
% point would be included
allt(length(allt),1) = 0;
hF(2)=fill(time,max(allt',thres_above'),'k','LineStyle','none');


alpha(0.1)
xlim([min(time) max(time)+1/fs])


% Make a subplot figure as well
% the EEG traces comparing and mark the cluster points in black on them too
figure; 
subplot(2,1,1);
hold on
noxious_mean=mean(data_noxious,2);
control_mean=mean(data_control,2);
plot(presec:1/2000:postsec,noxious_mean)
plot(presec:1/2000:postsec,control_mean)
if ~isempty(clusters_start_original)
     for i = 1:length(tableMonteCarlo.Cluster_start)
        cluster_time_start=clusters_start_original(i)/fs+presec;
        cluster_time_end=clusters_end_original(i)/fs+presec;
        xline(cluster_time_start,'k:');
        xline(cluster_time_end,'k:');
    end
end
xlim([min(time) max(time)+1/fs])
set(gca, 'YDir','reverse')

subplot(2,1,2); 
plot(time,allt)
hold on
thres_above = thres*ones(length(time),1);
thres_below = -1*thres_above;
plot(time,thres_above,'k--')
plot(time,thres_below,'k--')
if ~isempty(clusters_start_original)
    for i = 1:length(tableMonteCarlo.Cluster_start)
        if allt(clusters_start_original(i)) < 0
            thres_plot = -thres;
        else
            thres_plot = thres;
        end
        plot(clusters_start_original(i)/fs+presec,thres_plot,'k.','markersize',10)
        plot(clusters_end_original(i)/fs+presec,thres_plot,'k.','markersize',10)
    end
end
set(gca, 'YDir','reverse')

hF(1)=fill(time,min(allt',thres_below'),'k','LineStyle','none');

allt(length(allt),1) = 0;
hF(2)=fill(time,max(allt',thres_above'),'k','LineStyle','none');

alpha(0.1)
xlim([min(time) max(time)+1/fs])


