%Perform analyses within local searchlights

%Bootstrap statistics within searchlights (this takes a long time to run,
%see the code below in /helperScripts/searchlightCode/

% searchlight_map_cluster.m
% searchlight_rsa.m
% searchlight_rsa.sh

%Compute statistics: 
SearchlightStatistics
PlotSearchlightResultsVogt
PlotSearchlightResultsBuckner

%Assess overlap: 
SearchlightConjunction
BayesFactorOverlap