% Create figure showing results for full MFC

load(which('bsModCompWithinROI.mat'))
%% plot figure of Generalization indices for full MFC
figure;
hold on;
violinplot(squeeze(b(:,7,2:31)),'x',[1:18 20:28 30:32],'nopoints','facecolor',[[[1 0 0];  [1 0 0];  [1 0 0];  [1 0 0];  [1 0 0]; [1 0 0];  [0 1 0]; [0 1 0];  [0 1 0];  [0 1 0]; [0 1 0]; [0 1 0];  [0 0 1];  [0 0 1];  [0 0 1]; [0 0 1]; [0 0 1]; [0 0 1]; [  [1 0 0];[1 0 0]; [1 0 0]];    [0 1 0];[0 1 0];  [0 1 0];  [0 0 1];  [0 0 1];  [0 0 1];] ; [1 0 0];     [0 1 0];   [0 0 1];],'medc','none','facealpha',1);
plot([0.5 33.5],[0 0],'k-.','linewidth',1);

view([90 90])
set(gca,'YLim',[-.8 .8])
set(gca,'Linewidth',2)
set(gca,'FontSize',14)
ylabel 'Parameter Estimate'
legend off
set(gca,'XTick',[1:18 20:28 30:32])
set(gca,'XTickLabel',{'S1' 'S2' 'S3' 'S4' 'S5' 'S6' 'S7' 'S8' 'S9' 'S10' 'S11' 'S12' 'S13' 'S14' 'S15' 'S16' 'S17' 'S18' 'Somatic' 'Visceral' 'Pressure' 'WM' 'RS' 'Conflict' 'Visual' 'Social' 'Auditory' 'Pain' 'Cognitive Control' 'Negative Emotion'})
% xticklabel_rotate([],45)
hpatch=findobj(gca,'type','patch');
alphas=fliplr([.3*ones(1,18) .5*ones(1,9) .9*ones(1,3)]);
for h=1:length(hpatch); set(hpatch(h),'FaceAlpha',alphas(h)); end

saveas(gcf, [basedir 'Results' filesep 'SFig1B'], 'png')


%% make FDG plot based on stimulus categories
snames={'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18'};
studyNames=snames(FullDataSet.Y);
roi_masked_dat=masked_dat;

C=hsv(3);
thresh=.2;
for i=1:3
    xC{i}=C(i,:);
end

clust=ceil(FullDataSet.Y/6);
cat=clust;
R=corr(roi_masked_dat.dat);
R=R>prctile(R(:),50);
[stats, handles] = canlab_force_directed_graph(R,'rset',clust); % this takes some time
lh = findobj(gca, 'Type', 'line');
set(lh,'linestyle','none');

x=stats.Xc(:,1);
y=stats.Xc(:,2);

for i=1:length(stats.rset)
    cat(stats.rset{i})=i;
end


clear median_*
for i=1:max(cat)
    median_x(i)=median(x(cat==i));
    median_y(i)=median(y(cat==i));
end
close all;



figure;hold on;

C=hsv(max(cat));


for i=1:length(x)
    for j=1:3
        if cat(i)==j
            patch([x(i) median_x(j)],[y(i) median_y(j)],C(j,:),'EdgeAlpha',.1,'EdgeColor',C(j,:),'Linewidth',2)
        end
    end
end

x_offset = .01 * range(get(gca, 'XLim'));
y_offset = .01 * range(get(gca, 'YLim'));

for i=1:length(x)
    scatter(x(i),y(i),50,C(cat(i),:),'MarkerFaceColor',C(cat(i),:),'MarkerFaceAlpha',.8,'MarkerEdgeColor',[0 0 0],'MarkerEdgeAlpha',.8);
    text(x(i)+x_offset,y(i)-y_offset,studyNames{i},'FontSize',10,'Color',[0 0 0],'FontWeight','bold');
end

for i=1:3
    scatter(median_x(i),median_y(i),300,C(i,:),'MarkerFaceColor',C(i,:),'MarkerFaceAlpha',.8,'MarkerEdgeColor',[0 0 0],'MarkerEdgeAlpha',.8);
end


axis square;
legend off;
set(gca,'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1]);
set(gcf,'Color',[1 1 1]);

ha=findobj(gca,'type','scatter');
legend(ha(1:3),'Negative Emotion','Cognitive Control','Pain')

saveas(gcf, [basedir 'Results' filesep 'SFig1A'], 'png')

