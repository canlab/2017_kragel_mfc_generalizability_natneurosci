% Perform BIC analysis using Vogt parcellation

%% set up RDMS
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
labels={'Thermal Pain 1' 'Thermal Pain 2' 'Visceral Pain 1' 'Visceral Pain 2' 'Pressure Pain 1' 'Pressure Pain 2' 'Working Memory 1' 'Working Memory 2' 'Response Selection 1' 'Response Selection 2' 'Conflict 1' 'Conflict 2' 'Visual Neg. Affect 1' 'Visual Neg. Affect 2' 'Social Neg. Affect 1' 'Social Neg. Affect 2' 'Auditory Neg. Affect 1' 'Auditory Neg. Affect 2' 'Thermal Pain' 'Visceral Pain' 'Pressure Pain' 'Working Memory' 'Response Selection' 'Conflict' 'Visual Neg. Affect' 'Social Neg. Affect' 'Auditory Neg. Affect' 'Pain' 'Cognition' 'Neg. Affect'};

%% do model comparisons within each ROI
clear b
for r=1:6;%length(rois)
    
    
    X=[studyRDM' taskRDM' painRDM' cogRDM' affectRDM'];
    for i=1:size(X,2)
        X(:,i)=1000*X(:,i)/sum(X(:,i));
    end
    %% evaluate possible combinations of models
    
    if ~strcmp(rois{r},'full')
        roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
    else
        roi_masked_dat=masked_dat;
    end
    Y=pdist(roi_masked_dat.dat','correlation');
    keep=~isnan(Y);
    Y=Y(keep);
    X=X(keep,:);
    
    [sup_x] = glmfit([ones(length(Y),1) double(X(:,1:27))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,1:27)),Y');
    sup_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    yhat_sup=[ones(length(Y),1) double(X(:,1:27))]*sup_x;
    rho_sup=corr(yhat_sup,Y','type','Kendall');
    LL_sup=mdl.LogLikelihood;
    Rsq_sup=mdl.Rsquared.Adjusted;
    [pain_x] = glmfit([ones(length(Y),1) double(X(:,1:28))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,1:28)),Y');
    pain_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    yhat_pain=[ones(length(Y),1) double(X(:,1:28))]*pain_x;
    rho_pain=corr(yhat_pain,Y','type','Kendall');
    LL_pain=mdl.LogLikelihood;
    Rsq_pain=mdl.Rsquared.Adjusted;
    
    [cog_x] = glmfit([ones(length(Y),1) double(X(:,[1:27 29]))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,[1:27 29])),Y');
    cog_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    yhat_cog=[ones(length(Y),1) double(X(:,[1:27 29]))]*cog_x;
    rho_cog=corr(yhat_cog,Y','type','Kendall');
    LL_cog=mdl.LogLikelihood;
    Rsq_cog=mdl.Rsquared.Adjusted;
    
    [neg_x] = glmfit([ones(length(Y),1) double(X(:,[1:27 30]))],Y','normal','constant','off');
    mdl=fitglm(double(X(:,[1:27 30])),Y');
    neg_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    yhat_neg=[ones(length(Y),1) double(X(:,[1:27 30]))]*neg_x;
    rho_neg=corr(yhat_neg,Y','type','Kendall');
    LL_neg=mdl.LogLikelihood;
    Rsq_neg=mdl.Rsquared.Adjusted;
    
    [full_x, dev, st] = glmfit([ones(length(Y),1) double(X)],Y','normal','constant','off');
    mdl=fitglm([double(X)],Y');
    full_bic=-2*mdl.LogLikelihood+mdl.NumCoefficients*log(270);
    
    yhat_full=[ones(length(Y),1) double(X)]*full_x;
    rho_full=corr(yhat_full,Y','type','Kendall');
    LL_full=mdl.LogLikelihood;
    Rsq_full=mdl.Rsquared.Adjusted;
    
    b(r,:)=full_x;
    
    rho_hierarchical=[rho_sup rho_pain rho_cog rho_neg rho_full];
    bic_hierarchical=[sup_bic pain_bic cog_bic neg_bic full_bic];
    d_bic_hierarchical = bic_hierarchical - min(bic_hierarchical);
    w_bic_hierarchical = exp(-.5*d_bic_hierarchical)/sum(exp(-.5*d_bic_hierarchical));
    Rsq_hierarchical=[Rsq_sup Rsq_pain Rsq_cog Rsq_neg Rsq_full];
    
    rho_out(r,:)=rho_hierarchical;
    BIC_out(r,:)=bic_hierarchical;
    dBIC_out(r,:)=d_bic_hierarchical;
    wBIC_out(r,:)=w_bic_hierarchical;
    Rsq_out(r,:)=Rsq_hierarchical;
    
    
    
    [~,ind_bestmodel]=min(bic_hierarchical);
    
    model_inds={1:27,1:28, [1:27 29],[1:27 30],1:30};
    allModels={[ones(length(Y),1) double(X(:,1:27))],[ones(length(Y),1) double(X(:,1:28))],[ones(length(Y),1) double(X(:,[1:27 29]))],[ones(length(Y),1) double(X(:,[1:27 30]))],[ones(length(Y),1) double(X)]};
    [best_x] = glmfit(allModels{ind_bestmodel},Y','normal','constant','off');
    yhat_best=allModels{ind_bestmodel}*best_x;
end


%% make table

wBIC_Table=table(wBIC_out(:,1),wBIC_out(:,2),wBIC_out(:,3),wBIC_out(:,4),wBIC_out(:,5),'RowNames',{'pMCC' 'aMCC' 'pACC' 'sgACC' 'vmPFC' 'dMFC'},'VariableNames',{'Study_Subdomain' 'Pain' 'Cognitive_Control' 'Negative_Emotion' 'Full_Model'});
display(wBIC_Table);
