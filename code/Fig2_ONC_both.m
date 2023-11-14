%% script for ONC analysis and figures

%% load data for UCL
load('alldata_EEG_control_post_UCL.mat')
load('alldata_EEG_control_pre_UCL.mat')
load('alldata_EEG_heellance_post_UCL.mat')
load('alldata_EEG_heellance_pre_UCL.mat')

%% load data for Exeter

load('alldata_EEG_control_post_exeter.mat')
load('alldata_EEG_control_pre_exeter.mat')
load('alldata_EEG_heellance_post_exeter.mat')
load('alldata_EEG_heellance_pre_exeter.mat')

%% merge Exeter and UCL data
alldata_EEG_control_pre = [alldata_EEG_control_pre_UCL alldata_EEG_control_pre_exeter];
alldata_EEG_control_post = [alldata_EEG_control_post_UCL alldata_EEG_control_post_exeter];

alldata_EEG_heellance_pre = [alldata_EEG_heellance_pre_UCL alldata_EEG_heellance_pre_exeter];
alldata_EEG_heellance_post = [alldata_EEG_heellance_post_UCL alldata_EEG_heellance_post_exeter];

%% Call the montecarlo function for controls
tableMonteCarlo_control = montecarlo_paired_subjpairflips(0,1,...
    0,0,2000,0,alldata_EEG_control_post,flip(alldata_EEG_control_pre));

%% Call the montecarlo function for lances
tableMonteCarlo_lance = montecarlo_paired_subjpairflips(0,1,...
    0,0,2000,0,alldata_EEG_heellance_post,flip(alldata_EEG_heellance_pre));

%END%