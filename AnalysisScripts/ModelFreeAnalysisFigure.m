% Create correlation matrices for display in Figure 2
for r=1:length(rois)
    
    fprintf(['\nLoading mask for ' rois{r} ': \n\n'])

    clear P
    if r<7
        roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
    else
        roi_masked_dat=masked_dat;
    end
    data_mat=roi_masked_dat.dat;
    Y=corr(data_mat);
    Y(eye(270)==1)=NaN;
    %% get indices for domain, subdomain, and study
    domain_inds=ceil(roi_masked_dat.Y/6);
    task_inds=ceil(roi_masked_dat.Y/2);
    study_inds=roi_masked_dat.Y;
    
    %% print region name to screen
    fprintf(['\n\nComputing correlations for ' rois{r} ': \n\n'])
    
    %% within all pain
    tv=zeros(length(domain_inds));
    tv(domain_inds==1,domain_inds==1)=1;
    mean_corr_pain=nanmean(Y(tv==1 & ~isnan(Y) ));
    bs_se_corr_pain=std(bootstrp(10000,@mean,(Y(tv==1 & ~isnan(Y)))));
    fprintf(' Within Pain: Mean = %0.3f, SD = %0.3f \n',mean_corr_pain,bs_se_corr_pain)
    
    %% across different types of pain
    tv=zeros(length(domain_inds));
    tv(domain_inds==1,domain_inds==1)=1;
    tv(squareform(pdist(task_inds)==0))=0;
    tv(eye(270)==1)=0;
    mean_corr_pain_across_task=mean(Y(tv==1& ~isnan(Y)));
    bs_se_corr_pain_across_task=std(bootstrp(10000,@mean,(Y(tv==1& ~isnan(Y)))));
    
    tv=bootci(10000,{@mean,(Y(tv==1 & ~isnan(Y)))},'alpha',(.05/54));
    if tv(1)>0
        P(1,1)=1;
    else
        P(1,1)=0;
    end
    
    fprintf(' Within Pain Across Subdomains: Mean = %0.3f, SD = %0.3f, CI = [%0.3f %0.3f] \n',mean_corr_pain_across_task,bs_se_corr_pain_across_task,tv(1),tv(2))
    
    
    %% between all pain and cog
    tv=zeros(length(domain_inds));
    tv(domain_inds==1,domain_inds==2)=1;
    tv(domain_inds==2,domain_inds==1)=1;
    
    mean_corr_pain_cog=mean(Y(tv==1& ~isnan(Y)));
    bs_se_corr_pain_cog=std(bootstrp(10000,@mean,(Y(tv==1& ~isnan(Y)))));
    
    tv=bootci(10000,{@mean,(Y(tv==1 & ~isnan(Y)))},'alpha',(.05/54));
    if tv(1)>0
        P(2,1)=1;
        P(1,2)=1;
        
    else
        P(2,1)=0;
        P(1,2)=0;
        
    end
    
    fprintf(' Between Pain and Cognitive Control: Mean = %0.3f, SD = %0.3f, CI = [%0.3f %0.3f] \n',mean_corr_pain_cog,bs_se_corr_pain_cog,tv(1),tv(2));
    
    
    %% between all pain and negative emotion
    tv=zeros(length(domain_inds));
    tv(domain_inds==1,domain_inds==3)=1;
    tv(domain_inds==3,domain_inds==1)=1;
    
    mean_corr_pain_emot=mean(Y(tv==1 & ~isnan(Y)));
    bs_se_corr_pain_emot=std(bootstrp(10000,@mean,(Y(tv==1 & ~isnan(Y)))));
    
    tv=bootci(10000,{@mean,(Y(tv==1 & ~isnan(Y)))},'alpha',(.05/54));
    if tv(1)>0
        P(3,1)=1;
        P(1,3)=1;
        
    else
        P(3,1)=0;
        P(1,3)=0;
        
    end
    
    fprintf(' Between Pain and Negative Emotion: Mean = %0.3f, SD = %0.3f, CI = [%0.3f %0.3f] \n',mean_corr_pain_emot,bs_se_corr_pain_emot,tv(1),tv(2));
    
    %% within all cog
    tv=zeros(length(domain_inds));
    tv(domain_inds==2,domain_inds==2)=1;
    mean_corr_cog=nanmean(Y(tv==1& ~isnan(Y) ));
    bs_se_corr_cog=std(bootstrp(10000,@mean,(Y(tv==1 & ~isnan(Y)))));
    
    fprintf('\n Within Cognitive Control: Mean = %0.3f, SD = %0.3f \n',mean_corr_cog,bs_se_corr_cog);
    
    
    %% across different types of cog
    tv=zeros(length(domain_inds));
    tv(domain_inds==2,domain_inds==2)=1;
    tv(squareform(pdist(task_inds')==0))=0;
    mean_corr_cog_across_task=mean(Y(tv==1& ~isnan(Y)));
    bs_se_corr_cog_across_task=std(bootstrp(10000,@mean,(Y(tv==1& ~isnan(Y)))));
    
    
    tv=bootci(10000,{@mean,(Y(tv==1 & ~isnan(Y)))},'alpha',(.05/54));
    if tv(1)>0
        P(2,2)=1;
    else
        P(2,2)=0;
    end
    fprintf(' Within Cognitive Control Across Subdomains: Mean = %0.3f, SD = %0.3f, CI = [%0.3f %0.3f] \n',mean_corr_cog_across_task,bs_se_corr_cog_across_task,tv(1),tv(2))

   
    %% between all cog and negative emotion
    tv=zeros(length(domain_inds));
    tv(domain_inds==2,domain_inds==3)=1;
    tv(domain_inds==3,domain_inds==2)=1;
    
    mean_corr_cog_emot=mean(Y(tv==1 & ~isnan(Y)));
    bs_se_corr_cog_emot=std(bootstrp(10000,@mean,(Y(tv==1 & ~isnan(Y)))));
    
    tv=bootci(10000,{@mean,(Y(tv==1 & ~isnan(Y)))},'alpha',(.05/54));
    if tv(1)>0
        P(2,3)=1;
        P(3,2)=1;
        
    else
        P(2,3)=0;
        P(3,2)=0;
        
    end
    
    fprintf(' Between Cognitive Control and Negative Emotion: Mean = %0.3f, SD = %0.3f, CI = [%0.3f %0.3f] \n',mean_corr_cog_emot,bs_se_corr_cog_emot,tv(1),tv(2))

    %% within all emot
    tv=zeros(length(domain_inds));
    tv(domain_inds==3,domain_inds==3)=1;
    mean_corr_emot=nanmean(Y(tv==1& ~isnan(Y) ));
    bs_se_corr_emot=std(bootstrp(10000,@mean,(Y(tv==1 & ~isnan(Y)))));
    fprintf('\n Within Negative Emotion: Mean = %0.3f, SD = %0.3f \n',mean_corr_emot,bs_se_corr_emot);

    %% across different types of emot
    tv=zeros(length(domain_inds));
    tv(domain_inds==3,domain_inds==3)=1;
    tv(squareform(pdist(task_inds')==0))=0;
    mean_corr_emot_across_task=mean(Y(tv==1& ~isnan(Y)));
    bs_se_corr_emot_across_task=std(bootstrp(10000,@mean,(Y(tv==1& ~isnan(Y)))));
    tv=bootci(10000,{@mean,(Y(tv==1 & ~isnan(Y)))},'alpha',(.05/54));
    if tv(1)>0
        P(3,3)=1;
    else
        P(3,3)=0;
    end
    fprintf(' Within Negative Emotion Across Subdomains: Mean = %0.3f, SD = %0.3f, CI = [%0.3f %0.3f] \n\n',mean_corr_emot_across_task,bs_se_corr_emot_across_task,tv(1),tv(2))
  
    %% construct table
    M{r}=[[mean_corr_pain;mean_corr_pain_cog;mean_corr_pain_emot; mean_corr_pain_across_task],[mean_corr_pain_cog;mean_corr_cog;mean_corr_cog_emot; mean_corr_cog_across_task], [mean_corr_pain_emot;mean_corr_cog_emot;mean_corr_emot; mean_corr_emot_across_task]]; %#ok<*SAGROW>
    SE{r}=[[bs_se_corr_pain;bs_se_corr_pain_cog;bs_se_corr_pain_emot; bs_se_corr_pain_across_task],[bs_se_corr_pain_cog;bs_se_corr_cog;bs_se_corr_cog_emot; bs_se_corr_cog_across_task], [bs_se_corr_pain_emot;bs_se_corr_cog_emot;bs_se_corr_emot; bs_se_corr_emot_across_task]];
    nonzero{r}=P;
end

%% figures; some code adapted from https://github.com/ibogun/interaction/blob/master/SSC_1.0/visualizeConfusionMatrix.m
colors={[0 118 14]/255; [205 62 78]/255; [196 58 250]/255; [230 148 34]/255;  [70 130 180]/255; [120 18 134]/255; [0 0 0]};
region_labels={'pMCC' 'aMCC' 'pACC' 'sgACC' 'vmPFC' 'dMFC' 'Whole MFC'};
for r=1:7
    tv=M{r};
    for c=1:3
        tv(c,c)=tv(4,c);
    end
    tv=tv(1:3,:);
    figure;
    imagesc(tv); %,[0 .08]
    axis square
    colormap(colormap_tor([1 1 1],colors{r}));
    h=colorbar('peer',gca,'SouthOutside');set(h,'linewidth',2)
    set(gca,'YTick',[])
    set(gca,'XTick',[])
    %     set(gca,'YTickLabel',{'Pain','Cognitive Control' 'Negative Emotion'});
    title(region_labels{r})
    
    textStrings = num2str(tv(:),'%0.3f');  %# Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
    [x,y] = meshgrid(1:3);   %# Create x and y coordinates for the strings
    hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
        'HorizontalAlignment','center','FontSize',12);
    midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
    textColors = repmat(tv(:) > midValue,1,3);  %# Choose white or black for the
    
    %#   text color of the strings so they can be easily seen over the background color
    set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
    
    for i=1:length(x)
        for j=1:length(x)
            if x(i,j)<=y(j,j)
                if nonzero{r}(x(i,j),y(i,j))
                    rectangle('Position',[x(i,j)-.5 y(i,j)-.5 1 1],'linewidth',2)
                    rectangle('Position',[y(i,j)-.5 x(i,j)-.5 1 1],'linewidth',2)
                    
                end
            end
        end
    end
    
    
    set(gca,'Fontsize',12)
    set(gcf,'units','inches')
    set(gcf,'Position',[0 0 3 3]);
	
	saveas(gcf, [basedir 'Results' filesep 'Fig2CorrMat' rois{r}], 'png')

end