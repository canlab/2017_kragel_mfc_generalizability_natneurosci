% Plot results from SimulateWishartNoise.m

%% make plots where simulated effects are for each study
figure;
for r=1:3 %for 3 effect sizes
    positives=squeeze(b_P_study(r,:,2:end))<.05; %b_P pval
    for d=1:30
        RES(d) = binotest([positives(:,d); 1],.05); %#ok<SAGROW> %get stats assuming binomial distribution
    end
    
    subplot(3,6,6*(r-1)+(1:2));
    hold on;
    bar([RES(1:18).prop],'FaceColor',[.8 .8 .8]);
    errorbar([RES(1:18).prop], [RES(1:18).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 18.5]);
    set(gca,'YLim',[0 1])
    plot([0 19],[.05 .05],'k--','Linewidth',2)
    if r==3
        xlabel 'Study Parameters'
    end
    
    subplot(3,6,6*(r-1)+(3:4));
    hold on;
    bar([RES(19:27).prop],'FaceColor',[.8 .8 .8]);
    errorbar([RES(19:27).prop], [RES(19:27).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 9.5]);
    set(gca,'YLim',[0 1])
    plot([0 10],[.05 .05],'k--','Linewidth',2)
    if r==3
        xlabel 'Subdomain Parameters'
    end
    
    subplot(3,6,6*(r-1)+(5:6));
    hold on;
    bar([RES(28:30).prop],'FaceColor',[.8 .8 .8]);
    errorbar([RES(28:30).prop], [RES(28:30).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 3.5]);
    set(gca,'YLim',[0 1])
    plot([0 4],[.05 .05],'k--','Linewidth',2)
    if r==3
        xlabel 'Domain Parameters'
    end
    
end
saveas(gcf, [basedir 'Results' filesep 'SFig6c'], 'png')

%% make plots where simulated effects are for each domain
figure;
for r=1:3 %for 3 effect sizes
    positives=squeeze(b_P_domain(r,:,2:end))<.05; %b_P pval
    for d=1:30
        RES(d) = binotest([positives(:,d); 1],.05); %get stats assuming binomial distribution
    end
    
    subplot(3,6,6*(r-1)+(1:2));
    hold on;
    bar([RES(1:18).prop],'FaceColor',[.8 .8 .8]);
    errorbar([RES(1:18).prop], [RES(1:18).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 18.5]);
    set(gca,'YLim',[0 1])
    plot([0 19],[.05 .05],'k--','Linewidth',2)
    if r==3
        xlabel 'Study Parameters'
    end
    
    subplot(3,6,6*(r-1)+(3:4));
    hold on;
    bar([RES(19:27).prop],'FaceColor',[.8 .8 .8]);
    errorbar([RES(19:27).prop], [RES(19:27).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 9.5]);
    set(gca,'YLim',[0 1])
    plot([0 10],[.05 .05],'k--','Linewidth',2)
    if r==3
        xlabel 'Subdomain Parameters'
    end
    
    subplot(3,6,6*(r-1)+(5:6));
    hold on;
    bar([RES(28:30).prop],'FaceColor',[.8 .8 .8]);
    errorbar([RES(28:30).prop], [RES(28:30).SE],'linestyle','none','color','k','linewidth',2)
    set(gca,'XLim',[.5 3.5]);
    set(gca,'YLim',[0 1])
    plot([0 4],[.05 .05],'k--','Linewidth',2)
    if r==3
        xlabel 'Domain Parameters'
    end
    
end

saveas(gcf, [basedir 'Results' filesep 'SFig6b'], 'png')

