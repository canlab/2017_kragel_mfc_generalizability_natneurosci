% Calculate statistics from bootstrap distributions of the generalization index using searchlight approach

%% load bootstrap data for searchlight 
% see \searchlightCode which contains scripts for running this on HPC cluster

clear b;
d=dir([basedir 'Data' filesep 'ProcessedData' filesep 'SearchlightBootstrap' filesep '2017*.txt']);
ci=0;
for i=1:length(d)
    ci=ci+1;
    try
        b(ci,:,:)=importdata([d(i).folder filesep d(i).name]);
    catch
    end
end

b=b(1:1000,:,:); %take first 1000

%% convert to Z/p-values
b_ste = squeeze(nanstd(b));
b_mean = squeeze(nanmean(b));
b_ste(b_ste == 0) = Inf;
b_Z = b_mean ./ b_ste;
pval = 2*normcdf(-1*abs(b_Z),0,1);

%%
classes={'Pain' 'Cognitive' 'Neg Emotion'};
for i=1:3
    i=i+28;
    tv=b_Z(:,i);
    
    w = statistic_image('dat', tv, ...
        'volInfo', masked_dat.volInfo, ...
        'p', pval(:,i), ...
        'ste',b_ste(:,i), ...
        'dat_descrip', 'RSA', ...
        'removed_voxels', masked_dat.removed_voxels);
    w = threshold(w, .05, 'UNC','k',5);

    w.fullpath=[basedir 'Results' filesep 'RSA_searchlight_18studies_' classes{i-28} '_05UNC.nii'];
    w=replace_empty(w);
    w.dat(isnan(w.dat))=0;
    w.dat(~w.sig)=0;
    write(w);
    table(region(w));
    xX(:,i-28)=double(w.dat>0);
    
end


%% calculate overlap within each ROI
rois = {'pMCC', 'aMCC', 'pgACC', 'sgACC','vmPFC','dmPFC'};
M=zeros(length(xX),1);
for r=1:length(rois)
    roi_masked_dat=replace_empty(apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii'])))));
    overlap(1,r)=sum(sum(xX(M==r,[1 2])')==2);
    overlap(2,r)=sum(sum(xX(M==r,[1 3])')==2);
    overlap(3,r)=sum(sum(xX(M==r,[2 3])')==2);
    overlap(4,r)=sum(sum(xX(M==r,1:3)')==3);
    
end

