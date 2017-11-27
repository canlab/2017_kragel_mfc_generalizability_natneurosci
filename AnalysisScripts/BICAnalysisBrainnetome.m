% Perform BIC analysis using Brainnetome parcellation


%% load Brainnetome parcels
maskdat=fmri_data(which('BN_Atlas_246_1mm.nii'));
rois=unique(maskdat.dat);

%% specify model space

studyInds=condf2indic(FullDataSet.Y);
taskInds=condf2indic(ceil(FullDataSet.Y/2));
catInds=condf2indic(ceil(FullDataSet.Y/6));
clear *RDM;

%effects unique to each study
for i=1:size(studyInds,2)
    studyRDM(i,:)=pdist(studyInds(:,i),'seuclidean');
end

%RDM for each task separately (6 total)
for i=1:size(taskInds,2)
    taskRDM(i,:)= pdist(taskInds(:,i),'seuclidean');
end

%RDM for each category separately (3 total)
painRDM=pdist(catInds(:,1),'seuclidean');
cogRDM=pdist(catInds(:,2),'seuclidean');
affectRDM=pdist(catInds(:,3),'seuclidean');
labels={'Thermal Pain 1' 'Thermal Pain 2' 'Visceral Pain 1' 'Visceral Pain 2' 'Working Memory 1' 'Working Memory 2' 'Response Selection 1' 'Response Selection 2' 'Visual Neg. Affect 1' 'Visual Neg. Affect 2' 'Social Neg. Affect 1' 'Social Neg. Affect 2' 'Visceral Pain' 'Thermal Pain' 'Working Memory' 'Response Selection' 'Visual Neg. Affect' 'Social Neg. Affect' 'Pain' 'Cognition' 'Neg. Affect'};


%%  loop over regions and do model comparison for each -- this can be slow
for r=1:(length(rois)-1)

    %initialize model
    
    X=double([studyRDM' taskRDM' painRDM' cogRDM' affectRDM']);
    for i=1:size(X,2)
        X(:,i)=1000*X(:,i)/sum(X(:,i));
    end

    
    tv=replace_empty(maskdat); %create temporary variable with all regions
    tv.dat=double(tv.dat==r); %only use region 'r'
    
    roi_masked_dat=apply_mask(FullDataSet,remove_empty(tv)); %apply the mask
    Y=pdist(double(roi_masked_dat.dat'),'correlation'); %compute distance
    
    keep=~isnan(Y); %keep non-nan distances (some subjects have dropout for some smaller regions)
    Y=Y(keep); %exclude nans
    X=X(keep,:); %exclude nans
    
    %% compare superordinate and full
    
    %model with study and subdomain
    [sup_x] = glmfit([ones(length(Y),1) double(X(:,1:27))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,1:27)),Y');
    sup_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    %make predictions and get log likelihood and r squared
    yhat_sup=[ones(length(Y),1) double(X(:,1:27))]*sup_x;
    rho_sup=corr(yhat_sup,Y','type','Kendall');
    LL_sup=mdl.LogLikelihood;
    Rsq_sup=mdl.Rsquared.Adjusted;
    
    %model with pain included
    [pain_x] = glmfit([ones(length(Y),1) double(X(:,1:28))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,1:28)),Y');
    pain_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    %make predictions and get log likelihood and r squared
    yhat_pain=[ones(length(Y),1) double(X(:,1:28))]*pain_x;
    rho_pain=corr(yhat_pain,Y','type','Kendall');
    LL_pain=mdl.LogLikelihood;
    Rsq_pain=mdl.Rsquared.Adjusted;
    
    %model with cognitive control included
    [cog_x] = glmfit([ones(length(Y),1) double(X(:,[1:27 29]))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,[1:27 29])),Y');
    cog_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    %make predictions and get log likelihood and r squared
    yhat_cog=[ones(length(Y),1) double(X(:,[1:27 29]))]*cog_x;
    rho_cog=corr(yhat_cog,Y','type','Kendall');
    LL_cog=mdl.LogLikelihood;
    Rsq_cog=mdl.Rsquared.Adjusted;
    
    %model with negative emotion
    [neg_x] = glmfit([ones(length(Y),1) double(X(:,[1:27 30]))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,[1:27 30])),Y');
    neg_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    %make predictions and get log likelihood and r squared
    yhat_neg=[ones(length(Y),1) double(X(:,[1:27 30]))]*neg_x;
    rho_neg=corr(yhat_neg,Y','type','Kendall');
    LL_neg=mdl.LogLikelihood;
    Rsq_neg=mdl.Rsquared.Adjusted;
    
    %full model
    [full_x, dev, st] = glmfit([ones(length(Y),1) double(X)],Y','normal','constant','off');
    mdl=fitglm(double(X),Y');
    full_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    %make predictions and get log likelihood and r squared
    yhat_full=[ones(length(Y),1) double(X)]*full_x;
    rho_full=corr(yhat_full,Y','type','Kendall');
    LL_full=mdl.LogLikelihood;
    Rsq_full=mdl.Rsquared.Adjusted;
    
    %compute BIC, deltaBIC, and wBIC
    rho_hierarchical=[rho_sup rho_pain rho_cog rho_neg rho_full];
    bic_hierarchical=[sup_bic pain_bic cog_bic neg_bic full_bic];
    d_bic_hierarchical = bic_hierarchical - min(bic_hierarchical);
    w_bic_hierarchical = exp(-.5*d_bic_hierarchical)/sum(exp(-.5*d_bic_hierarchical));
    Rsq_hierarchical=[Rsq_sup Rsq_pain Rsq_cog Rsq_neg Rsq_full];
    
    %store output by region
    rho_out(r,:)=rho_hierarchical;
    BIC_out(r,:)=bic_hierarchical;
    dBIC_out(r,:)=d_bic_hierarchical;
    wBIC_out(r,:)=w_bic_hierarchical;
    Rsq_out(r,:)=Rsq_hierarchical;
    

end


%% make table -- might be slight differences due to rounding errors
ReadBNlabels; 
wBIC_Table=table(wBIC_out(:,1),wBIC_out(:,2),wBIC_out(:,3),wBIC_out(:,4),wBIC_out(:,5),'RowNames',RegionLabel,'VariableNames',{'Study_Subdomain' 'Pain' 'Cognitive_Control' 'Negative_Emotion' 'Full_Model'});
display(wBIC_Table);
save([basedir 'Results' filesep 'wBICBrainnetome.mat'], 'wBIC_out')