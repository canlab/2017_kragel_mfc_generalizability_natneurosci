# mfc-generalizability
Summary and requirements:
-------------------------
This repository contains MATLAB scripts needed to produce key results found in Kragel et al. 2017 and supplementary materials. 
They have been tested using MATLAB 2016b, and require [the CANLAB core tools](https://github.com/canlab/CanlabCore).

This code requires data available [here](https://canlabweb.colorado.edu/publications-v1/47-published-in-2018/4950-kragel-pa-kano-m-van-oudenhove-l-ly-hg-dupont-p-rubio-a-delon-martin-c-bonaz-b-manuck-s-gianaros-pj-ceko-m-losin-ear-woo-cw-wager-td-accepted-generalizable-representations-of-pain-cognitive-control-and-negative-emotion-in-medial-frontal-cortex-nature-neuroscience.html).

To run the scripts, add Canlab Core, SPM12, the root install directory from the above link (and subfolders), and finally this folder and 
subdirectories to the MATLAB path. Change to the root install directory and run the script RunAllAnalyses.m to recreate the main results in the manuscript.

Test environment(s):
--------------------
- MATLAB Version: 9.1.0.441655 (R2016b)
- Operating System: Microsoft Windows 10 Home Version 10.0 (Build 14393)
- Java Version: Java 1.7.0_60-b19 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode

Wrapper Scripts: These scripts run blocks of code as described below. These are intended to be run in order (or all at once via RunAllAnalyses)
-----------------------------------------------------------------------------------------------------------------------------------------------
- PreliminaryTasks.m - set some parameters, configure MATLAB path, and load data
- ROIAnalyses.m - perform analyses within ROIs
- SearchlightAnalyses.m - perform analyses within local searchlights
- BICModelComparisons.m - perform model comparisons using BIC
- ModelAssessment.m - run simulations on synthetic and resting state data
- RunAllAnalyses.m - run all code to produce all figures (and some tables)

Preliminary Tasks:
------------------
- Configure analyses: configureAnalysisOptions.m
- Load data: ReadSharedData.m

Region of Interest Analyses (Figure 2, Figure 3, Supplementary Figure 1, Supplementary Figure 3, Supplementary Figure 7):
-------------------------------------------------------------------------------------------------------------------------
- Mask data: MaskLONI.m
- Region of interest analysis: BootstrapROI.m, PlotBootstrapBetasWithinROI.m, SupplementalFigureMFC.m
- Model free analysis: ModelFreeAnalysis.m, ModelFreeAnalysisFigure.m, ModelFreeSupplementalFigures.m
- Parital Least Squares analysis: PLSWithinROI.m, PlotSurfaceFiguresPLS.m

Searchlight Analyses (Figure 4):
--------------------------------
- Bootstrap statistics within searchlights: searchlight_map_cluster.m, searchlight_rsa.m, searchlight_rsa.sh  (results can be found in \ProcessedData\SearchlightBootstrap)
- Compute statistics: SearchlightStatistics.m, PlotSearchlightResultsVogt.m, PlotSearchlightResultsBuckner.m
- Assess overlap: SearchlightConjunction.m, BayesFactorOverlap.m

BIC Model Comparisons (Table 1, Supplementary Figure 4):
--------------------------------------------------------
- Vogt parcels: BICAnalysisVogt.m
- Brainnetome parcels: BICAnalysisBrainnetome.m, RenderBICBrainnetome.m

Model Assessment (Supplementary Figure 2, Supplementary Figure 5, Supplementary Figure 6):
------------------------------------------------------------------------------------------
- Synthetic data: SimulateWishartNoise.m, PlotWishartSimulationFPR.m
- Resting state data: SimulateRestingStateData.m, PlotRestingStateBiasVariance.m, PlotRestingStateFPR.m
