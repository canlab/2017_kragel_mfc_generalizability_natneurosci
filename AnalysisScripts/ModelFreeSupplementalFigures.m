% Make figures showing "model-free" analysis methods

%% make figures that depict different regions of the correlation matrix
figure;imagesc(tril(tv_within_not_task,-1));
colormap([1 1 1; 1 0 0; 0 1 0; 0 0 1])
set(gca,'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1]);
set(gcf,'color',[1 1 1]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
axis square
title 'Within Domain, Between Tasks'
saveas(gcf, [basedir 'Results' filesep 'SFig7b'], 'png')


figure;imagesc(tril(tv_within_not_study,-1));
colormap([1 1 1; 1 0 0; 0 1 0; 0 0 1])
set(gca,'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1]);
set(gcf,'color',[1 1 1]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
axis square
title 'Within Domain, Between Studies'
saveas(gcf, [basedir 'Results' filesep 'SFig7c'], 'png')

tv=bwlabel(squareform(pdist(domain_inds)==0)); %pairs of images that are from the same domain have a distance of 0

figure;imagesc(tril(tv,-1));
colormap([1 1 1; 1 0 0; 0 1 0; 0 0 1])
set(gca,'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1]);
set(gcf,'color',[1 1 1]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
axis square
title 'Within Domain'
saveas(gcf, [basedir 'Results' filesep 'SFig7d'], 'png')

figure;
nY=tril(Y,-1);
nY(nY==0)=1;
imagesc(nY,[-1 1]);
colormap(gray);
set(gca,'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1]);
set(gcf,'color',[1 1 1]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
axis square
title 'Observed Correlation'
saveas(gcf, [basedir 'Results' filesep 'SFig7a'], 'png')

%% compute bootstrap distributions/confidence interval for example figure

r=2;
roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
data_matrix=roi_masked_dat.dat';
Y=corr(data_matrix');
Y(eye(270)==1)=NaN;


domain_inds=ceil(roi_masked_dat.Y/6);
task_inds=ceil(roi_masked_dat.Y/2);
study_inds=roi_masked_dat.Y;

% within all domains, but not within tasks
d=1; %for pain domain
tv=bwlabel(squareform(pdist(domain_inds)==0));
tv(squareform(pdist(task_inds)==0))=nan;
tv_btw=bwlabel(squareform(pdist(domain_inds)>0));
tv_btw(:,~any(tv==d))=nan;
meanWithin=nanmean(Y(tv==d& ~isnan(Y) ));
ciWithin=bootci(10000,@mean,Y(tv==d & ~isnan(Y) ));
bsWithin=bootstrp(10000,@mean,Y(tv==d & ~isnan(Y) ));


cY=nan(size(Y));
cY(tv==d& ~isnan(Y))=Y(tv==d& ~isnan(Y));
cY(tv_btw==1 & ~isnan(Y))=Y(tv_btw==1 & ~isnan(Y));

x1=nan(size(Y));
x2=nan(size(Y));

x1(tv==d& ~isnan(Y))=cY(tv==d& ~isnan(Y));
x2(tv_btw==1 & ~isnan(Y))=cY(tv_btw==1 & ~isnan(Y));

bootciWithin_vs_btwn=bootci(10000,{@bootdiff,x1(:),x2(:)});
bsWithin_vs_btwn=bootstrp(10000,@bootdiff,x1(:),x2(:));
meanWithin_vs_btwn=nanmean(x1(:))-nanmean(x2(:));


%% plot bootstrap distribution for within pain domain
figure;
hold on;histogram(bsWithin,'FaceColor',[1 0 0],'linewidth',1.5)
lims=get(gca,'YLim');

plot([ciWithin(1) ciWithin(1)],lims,'k--','linewidth',1.5)
plot([ciWithin(2) ciWithin(2)],lims,'k--','linewidth',1.5)


plot([meanWithin(1) meanWithin(1)],lims,'k-','linewidth',3)

set(gca,'Linewidth',1.5,'FontSize',14)
xlabel 'Pearson Correlation Coefficient'
ylabel 'Count'
view([90 90])
saveas(gcf, [basedir 'Results\SFig7e'], 'png')

%% plot bootstrap distribution for within pain domain vs between pain and other domains
figure;
hold on;histogram(bsWithin_vs_btwn,'FaceColor',[1 0 0],'linewidth',1.5)
lims=get(gca,'YLim');

plot([bootciWithin_vs_btwn(1) bootciWithin_vs_btwn(1)],lims,'k--','linewidth',1.5)
plot([bootciWithin_vs_btwn(2) bootciWithin_vs_btwn(2)],lims,'k--','linewidth',1.5)


plot([meanWithin_vs_btwn(1) meanWithin_vs_btwn(1)],lims,'k-','linewidth',3)

set(gca,'Linewidth',1.5,'FontSize',14)
xlabel 'Difference in Pearson Correlation Coefficient'
ylabel 'Count'
view([90 90])
saveas(gcf, [basedir 'Results' filesep 'SFig7f'], 'png')
