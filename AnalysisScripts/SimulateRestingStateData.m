% Simulate null effects using random models fit to resting state data

%%
studies=[];
for s=1:18
    studies=[studies;s*ones(15,1)]; %#ok<AGROW>
end
dat.Y=studies;

if computeBootstrap
    
    rois = {'pMCC', 'aMCC', 'pgACC', 'sgACC','vmPFC','dmPFC','full'};

    %% regional analyses for MFC
    pval=zeros(1000,7,31);
    b_P=pval;
    b_null=zeros(200,7,31);
    mask_template=fmri_data(which('AllRegions.nii'));
    gm_mask=fmri_data(which('TPM.nii'));
    gm_mask.dat=gm_mask.dat(:,1)>.5;
    
    %% over 1000 iterations, load a "random" beta map for 15 subjects from 18 sites
    for it=1:1000
        
        [masked_dat]=apply_mask(load_random_betas(it,basedir),mask_template);
        [masked_dat]=apply_mask(masked_dat,gm_mask);
        
        
        for r=1:7
            rng(3) %3
            if r~=7
                roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
            else
                roi_masked_dat=(masked_dat);
            end
            
            
            exclude=(all(roi_masked_dat.dat==0));
            Y=pdist(roi_masked_dat.dat','correlation'); %#ok<NASGU>
            
            masked_dat.Y=studies;
            
            studyInds=condf2indic(masked_dat.Y(:));
            taskInds=condf2indic(ceil(masked_dat.Y(:)/2));
            catInds=condf2indic(ceil(masked_dat.Y(:)/6));
            clear *RDM;
            
            
            %effects unique to each study -18
            for i=1:size(studyInds,2)
                studyRDM(i,:)=pdist(studyInds(:,i),'seuclidean');
            end
            
            %RDM for each task separately (9 total)
            for i=1:size(taskInds,2)
                taskRDM(i,:)= pdist(taskInds(:,i),'seuclidean');
            end
            
            %RDM for each category separately (3 total)
            painRDM=pdist(catInds(:,1),'seuclidean');
            cogRDM=pdist(catInds(:,2),'seuclidean');
            affectRDM=pdist(catInds(:,3),'seuclidean');
            
            X=[studyRDM' taskRDM' painRDM' cogRDM' affectRDM'];
            for i=1:size(X,2)
                X(:,i)=1000*X(:,i)/sum(X(:,i));
            end
            labels={'Thermal Pain 1' 'Thermal Pain 2' 'Visceral Pain 1' 'Visceral Pain 2' 'Pressure Pain 1' 'Pressure Pain 2' 'WorkingMemory 1' 'Working Memory 2' 'Response Selection 1' 'Response Selection 2' 'Conflict 1' 'Conflict 2' 'Visual Neg. Affect 1' 'Visual Neg. Affect 2' 'Social Neg. Affect 1' 'Social Neg. Affect 2' 'Auditory Neg. Affect 1' 'Auditory Neg. Affect 2'                'Thermal Pain' 'Visceral Pain' 'Pressure Pain' 'Working Memory' 'Response Selection' 'Conflict' 'Visual Neg. Affect' 'Social Neg. Affect' 'Auditory Neg. Affect' 'Pain' 'Cognition' 'Neg. Affect'};
            
            %% noise only
            dat_mat=roi_masked_dat.dat';
            Y=pdist(dat_mat,'correlation');
            Y(Y<.00001)=NaN;
            
            
            [full_x] = glmfit([ones(length(Y),1) double(X)],Y','normal','constant','off');
            
            null_sample_betas(it,r,:)=full_x; %#ok<*SAGROW>
            
            
            %% bootstrap resampling of subjects within studies
            rng(it)
            clear b_null
            for ij=1:200
                bs_inds(1:15)=randi([1,15],1,15);
                bs_inds(16:30)=randi([16,30],1,15);
                bs_inds(31:45)=randi([31,45],1,15);
                bs_inds(46:60)=randi([46,60],1,15);
                bs_inds(61:75)=randi([61,75],1,15);
                bs_inds(76:90)=randi([76,90],1,15);
                bs_inds(91:105)=randi([91,105],1,15);
                bs_inds(106:120)=randi([106,120],1,15);
                bs_inds(121:135)=randi([121,135],1,15);
                bs_inds(136:150)=randi([136,150],1,15);
                bs_inds(151:165)=randi([151,165],1,15);
                bs_inds(166:180)=randi([166,180],1,15);
                bs_inds(181:195)=randi([181,195],1,15);
                bs_inds(196:210)=randi([196,210],1,15);
                bs_inds(211:225)=randi([211,225],1,15);
                bs_inds(226:240)=randi([226,240],1,15);
                bs_inds(241:255)=randi([241,255],1,15);
                bs_inds(256:270)=randi([256,270],1,15);
                
                dat_mat=roi_masked_dat.dat(:,bs_inds)';
                Y=pdist(dat_mat,'correlation');
                Y(Y<.00001)=NaN;
                
                [full_x] = glmfit([ones(length(Y),1) double(X)],Y','normal','constant','off');
                
                b_null(ij,r,:)=full_x;
                
                
            end
            
        end
        %
        
        %b_null=squeeze(b_null(:,1,:)); %bootstrap distribution of betas on a single iteration
        
        b_ste = squeeze(nanstd(b_null));
        b_mean = squeeze(nanmean(b_null));
        b_ste(b_ste == 0) = Inf;
        b_Z = b_mean ./ b_ste;
        b_P_null(it,:,:) = 2 * (1 - normcdf(abs(b_Z))); %p value for single iteration
        
        
    end

    save([basedir 'Results' filesep 'false_positive_rate_simulation.mat'],'b_P_null','null_sample_betas')

else
    
        load([basedir 'Results' filesep 'false_positive_rate_simulation.mat'])

end

