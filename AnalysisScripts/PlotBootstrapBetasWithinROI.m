% Plot bootstrap distributions of Generalization Indices in each ROI 
figure; %figure for plotting
region_labels={'pMCC' 'aMCC' 'pACC' 'sgACC' 'vmPFC' 'dMFC' 'MFC'}; %titles for figures
for r=1:7 %for each region
subplot(1,7,r) %plot all on same figure
distributionPlot(squeeze(b(:,r,29:31)),'color',{[1 0 0] [0 1 0] [0 0 1]},'showMM',5) %plot bootstrap distributions for domain-level generalization indices

%format figure
axis tight
xlabel 'Domain'
title(region_labels(r));
set(gca,'XTick',[])
set(gca,'Linewidth',2)
ylabel 'Generalization Index' 
h=findobj(gca,'type','line');
set(h,'color','k','linewidth',2)
end

set(gcf,'units','inches');
set(gcf,'position',[0 0 12 3]);
saveas(gcf, [basedir 'Results' filesep 'Fig2'], 'png')

%% inference using FDR correction

% across all rois
sig_FDR_roi=b_P(1:6,:)<FDR(b_P(1:6,:),.05); %6 region by 31 parameter matrix - last 3 are domain

% for the full MFCs
sig_FDR_fullMFC=b_P(7,:)<FDR(b_P(7,:),.05); %1 region by 31 parameter matrix - last 3 are domain
