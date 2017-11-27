% Perform PLS Analysis within each ROI to get patterns of activity that load on each domain
clear Y;
catInds=[condf2indic(ceil(FullDataSet.Y/6)) condf2indic(ceil(FullDataSet.Y/2)) condf2indic(ceil(FullDataSet.Y))];
Y=(catInds);
Y(Y==0)=-1;
for i=1:size(Y,2)
    ycat(Y(:,i)==1,1)=i;
end


%% compute or load PLS regression coefficients for each ROI
if computeBootstrap
    rois = {'pMCC', 'aMCC', 'pgACC', 'sgACC','vmPFC','dmPFC'};
    for r=1:length(rois)
        
        roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data([rois{r} '.nii'])));
            
        %%
        clear BS_BETA
        for it=1:5000
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
            [~,~,~,~,BS_BETA(it,:,:)] = plsregress(roi_masked_dat.dat(:,bs_inds)',Y(bs_inds,:),18,'options',statset('UseParallel',true));
            
            
        end
        %%
        b_pls_mean=squeeze(mean(BS_BETA));
        b_pls_ste=squeeze(std(BS_BETA));
        b_pls_Z = b_pls_mean ./ b_pls_ste;
        b_pls_P = 2 * (1 - normcdf(abs(b_pls_Z)));
        %%
        for i=1:30
            b_pls_tZ{i,r}=b_pls_Z(2:end,i);
        end
    end
    save([basedir 'Results' filesep 'bs_pls_workspace.mat'],'b_pls_tZ')
else
    load(which('bs_pls_workspace.mat'));
end
%% render PLS betas within each ROI
clear o2 ol or %in case of memory problems
% set rendering search depth to 4mm?
figure;clf;
for i=1:3
    for r=1:6
        roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
        
        if r==1
            ol=fmridisplay();
            or=fmridisplay();
            
            ol = surface(ol, 'axes', [.25 1-i/3  .3 .3], 'direction', 'surface left', 'orientation', 'lateral');
            or = surface(or, 'axes', [.5  1-i/3 .3 .3], 'direction', 'surface right', 'orientation', 'lateral');
            pname = 'R.pial_MSMAll_2_d41_WRN_DeDrift.32k.mat'; % from Glasser_et_al_2016_HCP
            load(which(pname))
            set(ol.surface{1}.object_handle(1),'FaceVertexCData',cdata)
            set(or.surface{1}.object_handle(1),'FaceVertexCData',cdata)
            colormap gray
            
        end
        
        
        
        tv=roi_masked_dat;
        tv.dat=b_pls_tZ{i,r};
        tv.dat(abs(tv.dat)<1.96)=0;
        ol=addblobs(ol,region(tv),'splitcolor',{[0 0 1] [.3 0 .8] [.8 .3 0] [1 1 0]},'depth',4);
        or=addblobs(or,region(tv),'splitcolor',{[0 0 1] [.3 0 .8] [.8 .3 0] [1 1 0]},'depth',4);

        
        
    end
    %
    clear ol or
    ha=findobj(gcf,'type','axes');
    set(ha,'visible','off')
    set(ha(1:2:end),'view',[-115 -3]);
    set(ha(2:2:end),'view',[115 -3]);
end

saveas(gcf, [basedir 'Results' filesep 'Fig3'], 'png')