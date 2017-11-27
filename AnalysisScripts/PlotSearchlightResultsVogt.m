% Plot results of searchlight analyis and their correspondence with Vogt parcellation
figure;
pain=fmri_data(which('RSA_searchlight_18studies_Pain_05UNC.nii'));
cogControl=fmri_data(which('RSA_searchlight_18studies_Cognitive_05UNC.nii'));
negAffect=fmri_data(which('RSA_searchlight_18studies_Neg Emotion_05UNC.nii'));
layer1names={'Pain' 'Cognitive Control' 'Negative Emotion'};
combined_dat=pain;
combined_dat.dat=[combined_dat.dat cogControl.dat negAffect.dat];
combined_dat.image_names=layer1names;
combined_dat.dat(combined_dat.dat<0)=0;
%% Make riverplot of searchlight maps and ROIs

layer2names= {'pMCC', 'aMCC', 'pgACC', 'sgACC','vmPFC','dMFC'};

imagenames1 = {which('pMCC.nii') ...  
    which('aMCC.nii')  ...  
    which('pgACC.nii') ... 
    which('sgACC.nii') ...
    which('vmPFC.nii') ...
    which('dmPFC.nii')};

imagenames = check_image_names_get_full_path(imagenames1);

image_obj1 = fmri_data(imagenames, [], 'noverbose');  % loads images with spatial basis patterns
image_obj1=resample_space(image_obj1,combined_dat);
image_obj1.image_names=layer2names;

C={[0 118 14]/255 [205 62 78]/255 [196 58 250]/255   [230 148 34]/255  [70 130 180]/255  [120 18 134]/255   };
layer1colors = {[1 0 0] [0 1 0] [0 0 1]};
stats = image_similarity_plot(image_obj1, 'mapset', combined_dat, 'noplot', 'cosine_similarity');
sim_mat = stats.r';
sim_mat(sim_mat<0)=0;
% layer2colors=riverplot_recolor_layer2(sim_mat,layer1colors);
% C=layer2colors;
layer2colors=C;
riverplot(combined_dat,'layer2',image_obj1,'pos','colors1',layer1colors,'colors2',layer2colors,'reorder') %'recolor'

%% render searchlight maps and ROIs
clear o2;
o2=fmridisplay();
o2 = surface(o2, 'axes', [0 .5 .4 .4], 'direction', 'surface left', 'orientation', 'lateral');
o2 = surface(o2, 'axes', [0.5 .5 .4 .4], 'direction', 'surface right', 'orientation', 'lateral');

pname = 'R.pial_MSMAll_2_d41_WRN_DeDrift.32k.mat'; % from Glasser_et_al_2016_HCP
load(which(pname))
set(o2.surface{1}.object_handle(1),'FaceVertexCData',cdata)
set(o2.surface{2}.object_handle(1),'FaceVertexCData',cdata)

colormap gray

Cm={[1 0 0 ] [0 1 0] [0 0 1] [1 1 0] [1 0 1] [0 1 1] [1 1 1]};
for i=1:length(Cm)
    tv=combined_dat;
    tmp=zeros(1,length(tv.dat(:,1)));

    if i<4
    tv.dat=tv.dat(:,i).*double(tv.dat(:,i)>0);
    
    elseif i==4
            inds=(tv.dat(:,1)>0 & tv.dat(:,2)>0);
            tmp(~inds)=0;
            tmp(inds)=min(tv.dat(inds,1),tv.dat(inds,2));
            tv.dat=tmp';
    elseif i==5
            inds=(tv.dat(:,1)>0 & tv.dat(:,3)>0);
            tmp(~inds)=0;
            tmp(inds)=min(tv.dat(inds,1),tv.dat(inds,3));
            tv.dat=tmp';

    elseif i==6
             inds=(tv.dat(:,2)>0 & tv.dat(:,3)>0);
            tmp(~inds)=0;
            tmp(inds)=min(tv.dat(inds,2),tv.dat(inds,3));
            tv.dat=tmp';

    elseif i==7
            inds=(tv.dat(:,1)>0 & tv.dat(:,2)>0 & tv.dat(:,3)>0);
            tmp(~inds)=0;
            tmp(inds)=min([tv.dat(inds,1),tv.dat(inds,2),tv.dat(inds,3)]);
            tv.dat=tmp';

    end
    
        o2=addblobs(o2,region(tv),'splitcolor',{[0 0 0] [0 0 0] Cm{i}/2 Cm{i}*.8});

end

delete(o2.surface{1}.object_handle(2))
delete(o2.surface{2}.object_handle(2))

clear o2
o2=fmridisplay();
o2 = surface(o2, 'axes', [0.5 0 .5 .5], 'direction', 'surface left', 'orientation', 'lateral','trans');
o2 = surface(o2, 'axes', [0.5 .5 .4 .4], 'direction', 'surface right', 'orientation', 'lateral');

pname = 'R.pial_MSMAll_2_d41_WRN_DeDrift.32k.mat'; % from Glasser_et_al_2016_HCP
load(which(pname))
set(o2.surface{1}.object_handle(1),'FaceVertexCData',cdata)
set(o2.surface{2}.object_handle(1),'FaceVertexCData',cdata)
colormap gray

%add mask regions
for i=fliplr(1:6)
    tv=image_obj1;
    tv.dat=tv.dat(:,i);
    o2=addblobs(o2,region(tv),'onecolor',C{i});
end

%clear brainstem
delete(o2.surface{1}.object_handle(2))
delete(o2.surface{2}.object_handle(2))

%position axes
ha=findobj(gcf,'type','axes');
newpos=[[.69 .25 .2 .95];[.76 -.2 .2 .95];[.05 .25 .2 .95];[.12 -.2 .2 .95];[.35 .0 .3 .9];];
for i=1:5
    set(ha(i),'Position',newpos(i,:))
end
set(gcf,'Position',[481,1323.4,1137.6,508])
set(ha([1 3]),'view',[-115 -3]);
set(ha([2 4]),'view',[115 -3]);
set(ha(5),'view',[0 90]);

saveas(gcf, [basedir 'Results' filesep 'Fig4dleft'], 'png')