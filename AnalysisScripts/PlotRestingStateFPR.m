% Plot false positive rates from simulations of resting state data

load(which('false_positive_rate_simulation.mat'))
colors={[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255; [0 0 0]};
region_labels={'pMCC' 'aMCC' 'pACC' 'sgACC' 'vmPFC' 'dMFC' 'Whole MFC'};

figure;
for r=1:6
    false_positives=b_P(:,r,2:end)<.05; %b_P pval
    for d=1:30
       RES(d) = binotest([false_positives(:,d); 1],.05);  %#ok<SAGROW>
    end
    
    subplot(6,6,6*(r-1)+(1:3));
    hold on;
    bar([RES(1:18).prop],'FaceColor',colors{r});
    errorbar([RES(1:18).prop], [RES(1:18).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 18.5]);
    set(gca,'YLim',[0 .1])
    plot([0 19],[.05 .05],'k--','Linewidth',2)
    if r==6
    xlabel 'Study Parameters'
    end
    
     subplot(6,6,6*(r-1)+(4:5));
    hold on;
    bar([RES(19:27).prop],'FaceColor',colors{r});
    errorbar([RES(19:27).prop], [RES(19:27).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 9.5]);
    set(gca,'YLim',[0 .1])
    plot([0 10],[.05 .05],'k--','Linewidth',2)
    if r==6
    xlabel 'Subdomain Parameters'
    end
    title(region_labels{r})
    
    subplot(6,6,6*(r-1)+(6));
    hold on;
    bar([RES(28:30).prop],'FaceColor',colors{r});
    errorbar([RES(28:30).prop], [RES(28:30).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 3.5]);
    set(gca,'YLim',[0 .1])
    plot([0 4],[.05 .05],'k--','Linewidth',2)
    if r==6
    xlabel 'Domain Parameters'
    end
    
end

saveas(gcf, [basedir 'Results' filesep 'SFig5c'], 'png')
