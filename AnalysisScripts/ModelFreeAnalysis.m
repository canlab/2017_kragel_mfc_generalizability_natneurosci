% Compute correlations and compare intra-subject similarity within each ROI
for r=1:length(rois)
    %% load fmri data and compute correlation matrix (variable Y)
    if r<7
        roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
    else
        roi_masked_dat=masked_dat;
    end
    data_matrix=roi_masked_dat.dat; %get imaging data matrix from object
    Y=corr(data_matrix);  %compute correlation
    Y(eye(270)==1)=NaN; %exclude diagonal entries
    
    %% get indices that code for domain, subdomain (task type), and study
    domain_inds=ceil(roi_masked_dat.Y/6);
    task_inds=ceil(roi_masked_dat.Y/2);
    study_inds=roi_masked_dat.Y;
    
    %% within all domains, but not from same subdomain
    tv=bwlabel(squareform(pdist(domain_inds)==0)); %pairs of images that are from the same domain have a distance of 0
    tv(squareform(pdist(task_inds)==0))=nan; % exclude pairs of images that come from the same task
    
    for d=1:3 % for each domain
        
        tv_btw=bwlabel(squareform(pdist(domain_inds)>0)); % pairs of images that come from different domains have distances greater than 0
        tv_btw(:,~any(tv==d))=nan; %exclude comparisons between domains other than the current one
        
        mean_corr_btw_domain(r,d)=nanmean(Y(tv_btw==1 & ~isnan(Y) )); %compute sample average for - between domains
        bootci_btw_domain(r,d,:)=bootci(10000,@mean,Y(tv_btw==1 & ~isnan(Y) )); %compute BCa bootstrap CI with 10000 iterations
        
        mean_corr_domain_not_task(r,d)=nanmean(Y(tv==d& ~isnan(Y) )); %compute sample average for - within domain, across tasks
        bootci_domain_not_task(r,d,:)=bootci(10000,@mean,Y(tv==d & ~isnan(Y) )); %compute BCa bootstrap CI with 10000 iterations
        
        cY=nan(size(Y)); %initialize matrix to compute difference
        cY(tv==d & ~isnan(Y))=Y(tv==d & ~isnan(Y)); % within domain, across task
        cY(tv_btw==1 & ~isnan(Y))=Y(tv_btw==1 & ~isnan(Y)); % between domain
        
        
        x1=nan(size(Y)); %initialize matrix to compute difference
        x2=nan(size(Y)); %initialize matrix to compute difference
        
        x1(tv==d& ~isnan(Y))=cY(tv==d & ~isnan(Y)); % within domain, across task
        x2(tv_btw==1 & ~isnan(Y))=cY(tv_btw==1 & ~isnan(Y)); % between domain
          
        bootci_domain_not_task_vs_btw(r,d,:)=bootci(10000,{@bootdiff,x1(:),x2(:)}); %compute BCa bootstrap for mean of within domain and across tasks vs. mean of btw domains
        
    end
    
    %% compare within same domain, but different tasks against within domain but different study
    tv=bwlabel(squareform(pdist(domain_inds)==0)); %pairs of images that are from the same domain have a distance of 0
    tv(squareform(pdist(study_inds)==0))=nan; %pairs of images that are from the same study have a distance of 0
    
    tv_within_not_task=bwlabel(squareform(pdist(domain_inds)==0)); %pairs of images that are from the same domain have a distance of 0
    tv_within_not_task(squareform(pdist(task_inds)==0))=nan; %pairs of images that are from the same task have a distance of 0
    
    for d=1:3 % for each domain
        mean_corr_domain_not_study(r,d)=nanmean(Y(tv==d & ~isnan(Y) )); %compute sample average for - within a domain but from different studies
        bootci_domain_not_study(r,d,:)=bootci(10000,@mean,Y(tv==d & ~isnan(Y) )); %compute BCa bootstrap CI with 10000 iterations

        cY=nan(size(Y)); %initialize matrix to compute difference
        cY(tv==d& ~isnan(Y))=Y(tv==d & ~isnan(Y));  %within domain across study
        cY(tv_within_not_task==d & ~isnan(Y))=Y(tv_within_not_task==d & ~isnan(Y));  %within domain across task
        
        
        x1=nan(size(Y)); %initialize matrix to compute difference
        x2=nan(size(Y)); %initialize matrix to compute difference
        
        x1(tv==d& ~isnan(Y))=cY(tv==d & ~isnan(Y)); %within domain across study
        x2(tv_within_not_task==d & ~isnan(Y))=cY(tv_within_not_task==d & ~isnan(Y)); %within domain across task
        
        
        bootci_domain_not_study_vs_domain_not_task(r,d,:)=bootci(10000,{@bootdiff,x1(:),x2(:)}); %BCa bootstrap confidence interval
        
        
    end
    
    %% within all domains versus within all domains but from different study
    tv=bwlabel(squareform(pdist(domain_inds)==0));  %pairs of images that are from the same domain have a distance of 0
    
    tv_within_not_study=bwlabel(squareform(pdist(domain_inds)==0));  %pairs of images that are from the same domain have a distance of 0
    tv_within_not_study(squareform(pdist(study_inds)==0))=nan; %exclude pairs from same study
    
    
    for d=1:3  % for each domain
        mean_corr_domain(r,d)=nanmean(Y(tv==d & ~isnan(Y) )); %average correlation within domain
        bootci_domain(r,d,:)=bootci(10000,@mean,Y(tv==d & ~isnan(Y) )); %compute BCa bootstrap CI with 10000 iterations
        
        cY=nan(size(Y));%initialize matrix to compute difference
        cY(tv==d& ~isnan(Y))=Y(tv==d & ~isnan(Y)); %this domain only
        cY(tv_within_not_study==d & ~isnan(Y))=Y(tv_within_not_study==d & ~isnan(Y));
        
        x1=nan(size(Y)); %initialize matrix to compute subtraction
        x2=nan(size(Y)); %initialize matrix to compute subtraction
        
        x1(tv==d& ~isnan(Y))=cY(tv==d& ~isnan(Y)); %within a domain
        x2(tv_within_not_study==d & ~isnan(Y))=cY(tv_within_not_study==d & ~isnan(Y)); %within domain but different studies for that domain
        
        
        bootci_domain_vs_domain_not_study(r,d,:)=bootci(10000,{@bootdiff,x1(:),x2(:)}); %#ok<*SAGROW> %compute BCa bootstrap CI of difference with 10000 iterations
        
    end
    
end

