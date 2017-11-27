% Use minimum statistics from the conjunction analysis to get Bayes Factors for overlap

%% find minimum statistic from bootstrap distributions
b_ste=nanstd(b); %bootstrap standard error
b_ste(b_ste == 0) = Inf; %voxels with no variance are ignored
b_Z=nanmean(b)./(b_ste); %z score
bZ=b_Z; % create additional variable to find minimim
bZ=squeeze(bZ(1,:,29:31)); %domain effects only
[min_bZ,inds]=min(bZ,[],2); %find minimum domain effect
b_P = 2*min(squeeze((1+sum(b < 0))/(size(b,1)+1)),squeeze((1+sum(b > 0))/(size(b,1)+1))); % get p-value

%% compute BF at each voxel (against distribution mean 0 se of 1)
for v=1:size(b,2)
    
    for c=29:31
        mean_b=nanmean(b(:,v,c));
        se_b=nanstd(b(:,v,c));
        
        if se_b==0
            se_b=Inf;
        end
        
        B(v,c-28)= computeBF_np(mean_b,se_b); %greater than 0
    end
    
    
    mean_b=nanmean(b(:,v,28+inds(v)));
    se_b=nanstd(b(:,v,28+inds(v)));
    if se_b==0
        se_b=Inf;
    end
    
    B_conj(v)= computeBF_np(mean_b,se_b);
end

%% 05 unc mask
classes={'Pain' 'Cognitive' 'Neg_Affect'};
clear X;
b_Z=squeeze(b_Z);b_ste=squeeze(b_ste);

for i=1:3%1:3;
    i=i+28;
    tv=b_Z(:,i);
    
    w = statistic_image('dat', tv, ...
        'volInfo', masked_dat.volInfo, ...
        'p', b_P(:,i), ...
        'ste',b_ste(:,i), ...
        'dat_descrip', 'RSA', ...
        'removed_voxels', masked_dat.removed_voxels);
    w = threshold(w, .05, 'UNC','k',5);
    w=replace_empty(w);
    w.dat(isnan(w.dat))=0;
    w.dat(~w.sig)=0;
    X(:,i-28)=double(w.dat>0);
    
end

%% make cutoff based maps

for_null=[1 1/3 .1 .05 1/30 .01 .0067 -Inf]; %
for_effect=[1 3 10 20 30 100 150 Inf];


B_conj_obj=masked_dat;
B_conj_obj.dat=zeros(size(B_conj'));
for c=1:(length(for_null)-1)
    B_conj_obj.dat(B_conj'< for_null(c) & B_conj'>= for_null(c+1))=-1*c;
    B_conj_obj.dat(B_conj'>= for_effect(c) & B_conj'< for_effect(c+1))=c;
end
B_conj_obj.fullpath=[basedir 'Results' filesep 'BF_conjunction_18studies_original_param.nii'];
% write(B_conj_obj);

mB_conj_obj=replace_empty(B_conj_obj);
mB_conj_obj.dat(~any(X'>0))=NaN;
mB_conj_obj=remove_empty(mB_conj_obj);
% orthviews(mB_conj_obj)
%% render BF map
figure;
clear o2
o2=fmridisplay();
o2 = surface(o2, 'axes', [0 .5 .4 .4], 'direction', 'surface left', 'orientation', 'lateral');
o2 = surface(o2, 'axes', [0.5 .5 .4 .4], 'direction', 'surface right', 'orientation', 'lateral');
pname = 'R.pial_MSMAll_2_d41_WRN_DeDrift.32k.mat'; % from Glasser_et_al_2016_HCP
load(which(pname))
set(o2.surface{1}.object_handle(1),'FaceVertexCData',cdata)
set(o2.surface{2}.object_handle(1),'FaceVertexCData',cdata)
colormap gray
o2=addblobs(o2,region(mB_conj_obj),'splitcolor',{[.3 0 .8] [.8 .3 0] [.8 .3 0] [1 1 0]});

ha=findobj(gcf,'type','axes');
set(ha,'visible','off')
set(ha(1:2:end),'view',[-115 -3]);
set(ha(2:2:end),'view',[115 -3]);
delete(o2.surface{1}.object_handle(2))
delete(o2.surface{2}.object_handle(2))
saveas(gcf, [basedir 'Results' filesep 'Fig4c'], 'png')



%% plot colorbar
%figure;imagesc([-6 -5 -4 -3 -2]);
%set(gca,'XTick',1:5)
%set(gca,'XTickLabel',({'.1' '.05' '.01' '.03' '.0067'}))
%set(gca,'YTick',[]);
%colormap(colormap_tor([.8 .3 0],[.3 0 .8]))
