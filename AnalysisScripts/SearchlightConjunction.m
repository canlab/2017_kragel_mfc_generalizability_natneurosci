% Perform conjunction analysis of searchight results

%% free up some space if variables are in workspace
clear roi_masked_dat gm_mask image_obj3 image_obj1;

%% conjunction of thresholded images

figure;
clf
imagenames1 = {which('pMCC.nii') ...  
    which('aMCC.nii')  ...  
    which('pgACC.nii') ... 
    which('sgACC.nii') ...
    which('vmPFC.nii') ...
    which('dmPFC.nii')};

imagenames = check_image_names_get_full_path(imagenames1);

image_obj1 = fmri_data(imagenames, [], 'noverbose');  % loads images with spatial basis patterns
image_obj1=resample_space(image_obj1,combined_dat);
image_obj1.image_names=imagenames1;

% C={[0 118 14]/255 [205 62 78]/255 [196 58 250]/255   [230 148 34]/255  [70 130 180]/255  [120 18 134]/255   };
layer1colors = {[1 0 0] [0 1 0] [0 0 1]};

clear o2;
o2=fmridisplay();
o2 = surface(o2, 'axes', [0 0 .6 .6], 'direction', 'surface left', 'orientation', 'lateral');
o2 = surface(o2, 'axes', [0.4 0 .6 .6], 'direction', 'surface right', 'orientation', 'lateral');

pname = 'R.pial_MSMAll_2_d41_WRN_DeDrift.32k.mat'; % from Glasser_et_al_2016_HCP
load(which(pname))
set(o2.surface{1}.object_handle(1),'FaceVertexCData',cdata)
set(o2.surface{2}.object_handle(1),'FaceVertexCData',cdata)

colormap gray

boundary_image=image_obj1;
for i=1:6
clear tv;
tv=zeros(size(image_obj1.volInfo.image_indx));
tv(image_obj1.volInfo.image_indx)=image_obj1.dat(:,i);
perim = bwperim(reshape(tv,image_obj1.volInfo.dim));
boundary_image.dat(:,i)=perim(image_obj1.volInfo.image_indx);
end



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
            tmp(inds)=min([tv.dat(inds,1),tv.dat(inds,2),tv.dat(inds,3)],[],2);
            tv.dat=tmp';

    end
    
    if~all(tv.dat==0)
        o2=addblobs(o2,region(tv),'splitcolor',{[0 0 0] [0 0 0] Cm{i}/2 Cm{i}*.8},'depth',2);
    end
end

delete(o2.surface{1}.object_handle(2))
delete(o2.surface{2}.object_handle(2))
clear o2;


%% individual renders for each domain
clear o2;
for i=1:3
    o3=fmridisplay();
    o4=fmridisplay();

    o3 = surface(o3, 'axes', [0+(4-i-1)*.125 0.6 .3 .3], 'direction', 'surface left', 'orientation', 'lateral');
    o4 = surface(o4, 'axes', [0.45+(i-1)*.125 0.6 .3 .3], 'direction', 'surface right', 'orientation', 'lateral');
    
    set(o3.surface{1}.object_handle(1),'FaceVertexCData',cdata)
    set(o4.surface{1}.object_handle(1),'FaceVertexCData',cdata)

    

    
    tv=combined_dat;
    tv.dat=tv.dat(:,i).*double(tv.dat(:,i)>0);
    
    o3=addblobs(o3,region(tv),'splitcolor',{[0 0 0] [0 0 0] Cm{i}/2 Cm{i}*.8},'depth',2);
    
    tv=combined_dat;
    tv.dat=tv.dat(:,i).*double(tv.dat(:,i)>0);
    o4=addblobs(o4,region(tv),'splitcolor',{[0 0 0] [0 0 0] Cm{i}/2 Cm{i}*.8},'depth',2);

    
    
    delete(o3.surface{1}.object_handle(2))
    delete(o4.surface{1}.object_handle(2))

    
    clear o3 o4
end

%% clean up figure
ha=findobj(gcf,'type','axes');
set(ha,'visible','off')
set(ha(1:2:end),'view',[-115 -3]);
set(ha(2:2:end),'view',[115 -3]);
set(gcf,'units','inches')
set(gcf,'position',[0 0 12 6])
saveas(gcf, [basedir 'Results' filesep 'Fig4a'], 'png')
