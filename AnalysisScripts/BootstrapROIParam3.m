% Perform bootstrap analysis for inference within each ROI

%% Create RDM-based model

% create RDMs (same for all rois)
studyInds=condf2indic(masked_dat.Y); %matrix of 0/1 based on study membership
taskInds=condf2indic(ceil(masked_dat.Y/2)); %matrix of 0/1 based on subdomain membership
catInds=condf2indic(ceil(masked_dat.Y/6));%matrix of 0/1 based on domain membership


%effects unique to each study (18 total)
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

% place RDMs in design matrix
X=[studyRDM' taskRDM' painRDM' cogRDM' affectRDM'];

% scale to have mean of 1000
for i=1:size(X,2)
    X(:,i)=1000*X(:,i)/sum(X(:,i));
end


%% do bootstrap resampling separately for each neural RDM (per ROI)
% create variable with roi names
rois = {'pMCC', 'aMCC', 'pgACC', 'sgACC','vmPFC','dmPFC','full'};

if computeBootstrap
    clear b;
    for r=1:7
        rng(3) %start with same seed for each region of interest
        
        % mask out data that is not within this ROI
        if r~=7
            roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
        else
            roi_masked_dat=(masked_dat);
        end
        
        
        exclude=(all(roi_masked_dat.dat==0));
        Y=pdist(roi_masked_dat.dat','correlation');
        
        
        studyInds=condf2indic(masked_dat.Y(:));
        taskInds=condf2indic(ceil(masked_dat.Y(:)/2));
        catInds=condf2indic(ceil(masked_dat.Y(:)/6));
        clear *RDM;
        
        
        %effects unique to each study -18
        for i=1:size(studyInds,2);
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
        for i=1:size(X,2);
            X(:,i)=1000*X(:,i)/sum(X(:,i));
        end
        labels={'Thermal Pain 1' 'Thermal Pain 2' 'Visceral Pain 1' 'Visceral Pain 2' 'Pressure Pain 1' 'Pressure Pain 2' 'Working Memory 1' 'Working Memory 2' 'Response Selection 1' 'Response Selection 2' 'Conflict 1' 'Conflict 2' 'Visual Neg. Affect 1' 'Visual Neg. Affect 2' 'Social Neg. Affect 1' 'Social Neg. Affect 2' 'Auditory Neg. Affect 1' 'Auditory Neg. Affect 2' 'Thermal Pain' 'Visceral Pain' 'Pressure Pain' 'Working Memory' 'Response Selection' 'Conflict' 'Visual Neg. Affect' 'Social Neg. Affect' 'Auditory Neg. Affect' 'Pain' 'Cognition' 'Neg. Affect'};
        
        
        %% convert to focus each parameter only on a single domain
        
        for i=1:size(X,2)
            temp=squareform(X(:,i));
            
            if ~any([i==1,i==19,i==28])
                start=find(temp(1,:)>0,1,'first');
                stop=find(temp(1,:)>0,1,'last');
                change_inds=false(270);
                change_inds(start:stop,:)=temp(start:stop,:)==0;
                
            else
                
                stop=find(temp(:,1)>0,1,'first')-1;
                change_inds=false(270);
                change_inds(:,1:stop)=temp(:,1:stop)==0;
                
            end
            
            temp(change_inds==1)=-1;
            temp(eye(270)==1)=0;
            nX(:,i)=squareform(temp);
            
            
            posinds=nX(:,i)>0;
            neginds=nX(:,i)<0;
            
            %need to mean center?
            nX(posinds,i)=1/length(find(posinds));
            nX(neginds,i)=-1/length(find(neginds));
            
            
        end
        
        nX=double(nX);
        X=nX;
        
        % bootstrap resampling of subjects within studies
        for it=1:5000 %5000 bootstrap samples
            bs_inds(1:15)=randi([1,15],1,15); %resample with replacement within first study
            bs_inds(16:30)=randi([16,30],1,15); %resample with replacement within second study
            bs_inds(31:45)=randi([31,45],1,15); %resample with replacement within third study
            bs_inds(46:60)=randi([46,60],1,15); % ...
            bs_inds(61:75)=randi([61,75],1,15); % ...
            bs_inds(76:90)=randi([76,90],1,15); % ...
            bs_inds(91:105)=randi([91,105],1,15); % ...
            bs_inds(106:120)=randi([106,120],1,15); % ...
            bs_inds(121:135)=randi([121,135],1,15); % ...
            bs_inds(136:150)=randi([136,150],1,15); % ...
            bs_inds(151:165)=randi([151,165],1,15); % ...
            bs_inds(166:180)=randi([166,180],1,15); % ...
            bs_inds(181:195)=randi([181,195],1,15); % ...
            bs_inds(196:210)=randi([196,210],1,15); % ...
            bs_inds(211:225)=randi([211,225],1,15); % ...
            bs_inds(226:240)=randi([226,240],1,15); % ...
            bs_inds(241:255)=randi([241,255],1,15); % ...
            bs_inds(256:270)=randi([256,270],1,15); % resample with replacement within eighteenth study
            
            resampled_mat=roi_masked_dat.dat(:,bs_inds)'; % grab data from bootstrap indices
            Y=pdist(resampled_mat,'correlation'); % compute distance matrix on this data
            Y(Y<.00001)=NaN; % exclude very small off diagonal elements (because subjects can be replicated, and because some subjects have low variance)
            
            
            [full_x] = glmfit([ones(length(Y),1) double(X)],Y','normal','constant','off'); %estimate coefficients with OLS
            
            b(it,r,:)=full_x; %store bootstrap statistic for each iteration, each roi
            
        end
    end
    
    % save bootstrap statistics to disk
    save([basedir  'Results' filesep 'bsModCompWithinROIParam3.mat'],'b', '-v7.3');
    
else
    load(which('bsModCompWithinROIParam3.mat'))
end


%% get p-values from bootstrap distribution under some assumpations of normality

b_ste = squeeze(nanstd(b)); %bootstrap SE
b_mean = squeeze(nanmean(b)); %bootstrap mean
b_ste(b_ste == 0) = Inf; %ignore cases where SE is 0
b_Z = b_mean ./ b_ste; % compute Z
b_P = 2 * (1 - normcdf(abs(b_Z))); %get two-tailed p-value from Z

