% Set some parameters for doing analyses and configure path

computeBootstrap=false; %perform bootstrap analyses (if true, this can be slow) or load bootstrap results (if false)
basedir=which('ConfigureAnalysisOptions.m'); %location of scripts folder
basedir=basedir(1:end-50); %location of base folder
warning off stats:pdist:ConstantPoints %some subjects have missing data in ROIs (and are excluded from some analyses), this suppressing warning about low variance
addpath(genpath(basedir)); %add basepath and subfolders