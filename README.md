# mfc-generalizability
This repository contains MATLAB scripts needed to produce key results found in Kragel et al. 2017 and supplementary materials. 
They have been tested using MATLAB 2016b, and require the CANLAB core tools found at https://github.com/canlab
================================================================================================================================
This code requires data available at https://canlabweb.colorado.edu/publications-v1.html 

To run the scripts, add Canlab Core, SPM12, the root install directory from the above link (and subfolders), and finally this folder and 
subdirectories to the MATLAB path. Change to the root install directory and run the script RunAllAnalyses.m to recreate the main results in the manuscript.

Test environment(s):
--------------------
- MATLAB Version: 9.1.0.441655 (R2016b)
- Operating System: Microsoft Windows 10 Home Version 10.0 (Build 14393)
- Java Version: Java 1.7.0_60-b19 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode

Wrapper Scripts: These scripts run blocks of code as described below. These are intended to be run in order (or all at once via RunAllAnalyses)
-----------------------------------------------------------------------------------------------------------------------------------------------
- i. PreliminaryTasks.m - set some parameters, configure MATLAB path, and load data
- ii. ROIAnalyses.m - perform analyses within ROIs
- iii. SearchlightAnalyses.m - perform analyses within local searchlights
- iv. BICModelComparisons.m - perform model comparisons using BIC
- v. ModelAssessment.m - run simulations on synthetic and resting state data
- vi. RunAllAnalyses.m - run all code to produce all figures (and some tables)

Preliminary Tasks:
------------------
- i. Configure analyses: configureAnalysisOptions.m
- ii. Load data: ReadSharedData.m

Region of Interest Analyses (Figure 2, Figure 3, Supplementary Figure 1, Supplementary Figure 3, Supplementary Figure 7):
-------------------------------------------------------------------------------------------------------------------------
- i. Mask data: MaskLONI.m
- ii. Region of interest analysis: BootstrapROI.m, PlotBootstrapBetasWithinROI.m, SupplementalFigureMFC.m
- iii. Model free analysis: ModelFreeAnalysis.m, ModelFreeAnalysisFigure.m, ModelFreeSupplementalFigures.m
- iv. Parital Least Squares analysis: PLSWithinROI.m, PlotSurfaceFiguresPLS.m

Searchlight Analyses (Figure 4):
--------------------------------
- i. Bootstrap statistics within searchlights: searchlight_map_cluster.m, searchlight_rsa.m, searchlight_rsa.sh  (results can be found in \ProcessedData\SearchlightBootstrap)
- ii. Compute statistics: SearchlightStatistics.m, PlotSearchlightResultsVogt.m, PlotSearchlightResultsBuckner.m
- iii. Assess overlap: SearchlightConjunction.m, BayesFactorOverlap.m

BIC Model Comparisons (Table 1, Supplementary Figure 4):
--------------------------------------------------------
- i. Vogt parcels: BICAnalysisVogt.m
- ii. Brainnetome parcels: BICAnalysisBrainnetome.m, RenderBICBrainnetome.m

Model Assessment (Supplementary Figure 2, Supplementary Figure 5, Supplementary Figure 6):
------------------------------------------------------------------------------------------
- i. Synthetic data: SimulateWishartNoise.m, PlotWishartSimulationFPR.m
- ii. Resting state data: SimulateRestingStateData.m, PlotRestingStateBiasVariance.m, PlotRestingStateFPR.m
