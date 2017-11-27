% Plot distribution of beta estimates from resting state simulation
load(which('false_positive_rate_simulation.mat'))
colors={[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255; [0 0 0]};
region_labels={'pMCC' 'aMCC' 'pACC' 'sgACC' 'vmPFC' 'dMFC' 'Whole MFC'};

figure;
for r=1:6
    
    subplot(6,6,6*(r-1)+(1:3));
    hold on;
    distributionPlot(squeeze(null_sample_betas(:,r,2:19)),'color',colors{r},'showMM',5)
    h=findobj(gca,'type','line');
    set(h,'color','k','linewidth',2)
    
    
    set(gca,'XLim',[.5 18.5]);
    set(gca,'YLim',[-.5 .5]);
    
    plot([0 19],[.0 .0],'k--','Linewidth',2)
    if r==6
        xlabel 'Study Parameters'
    end
    
    subplot(6,6,6*(r-1)+(4:5));
    hold on;
    distributionPlot(squeeze(null_sample_betas(:,r,20:28)),'color',colors{r},'showMM',5)
    h=findobj(gca,'type','line');
    set(h,'color','k','linewidth',2)
    
    
    set(gca,'XLim',[.5 9.5]);
    set(gca,'YLim',[-.5 .5]);
    plot([0 10],[.0 .0],'k--','Linewidth',2)
    if r==6
        xlabel 'Subdomain Parameters'
    end
    title(region_labels{r})
    
    subplot(6,6,6*(r-1)+(6));
    hold on;
     
    distributionPlot(squeeze(null_sample_betas(:,r,29:31)),'color',colors{r},'showMM',5)
    h=findobj(gca,'type','line');
    set(h,'color','k','linewidth',2)
    
    set(gca,'XLim',[.5 3.5]);
    set(gca,'YLim',[-.5 .5]);
    
    plot([0 4],[.0 .0],'k--','Linewidth',2)
    if r==6
        xlabel 'Domain Parameters'
    end
    
end

saveas(gcf, [basedir 'Results' filesep 'SFig5b'], 'png')

