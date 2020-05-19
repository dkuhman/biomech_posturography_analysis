%This script provides a sample template for implimenting the
%CoP_posturography function.
%Created by: Daniel Kuhman
%Github: https://github.com/dkuhman
%Last updated: 2020-05-19

clc
clear all
%----------------------------IMPORT & SORT--------------------------------
%Select files to be analyzed
[filesList, path_n] = uigetfile('*.xlsx','Grab files you want to process','MultiSelect', 'on');

if iscell(filesList) == 0
    filesList = {filesList};  
end

for i = 1:length(filesList)
    %Load data
    filename = (filesList{i});
    pathname = (path_n);
    data_in = xlsread([pathname filename]);
    
    %Specify sample rate of force platform
    sample_freq = 1000;
    
    %Get CoP data
    CoP_AP = data_in(1:end,9);
    CoP_AP(isnan(CoP_AP)) = [];
    CoP_ML = data_in(1:end,10);
    CoP_ML(isnan(CoP_ML)) = [];
    
    %Plot the CoP tracing
    figure
    plot(CoP_ML, CoP_AP, '-b', 'LineWidth', 1)
    xlabel('CoP ML')
    ylabel('CoP AP')
    uiwait
    
    %Run CoP_posturography function
    [mean_AP, mean_ML, stdev_AP, stdev_ML, rms_AP, rms_ML, ampDisp_AP,...
    ampDisp_ML, meanVel_AP, meanVel_ML, cpAreaConf, cpTotalMeanVel, pathLength]...
    = CoP_posturography(CoP_AP, CoP_ML, sample_freq);
end