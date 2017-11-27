% Take results from BICAnalysisBrainnetome.m and render them on cortical surface

%if we dont have data in workspace, load it (see BICAnalysisBrainnetome)
if ~exist('wBIC_out','var')
    load([basedir 'Results' filesep 'wBICBrainnetome.mat']);
    maskdat=fmri_data(which('BN_Atlas_246_1mm.nii'));
    rois=unique(maskdat.dat);
end

C=wBIC_out(:,2:4); %color based on evidence for pain, cognitive control, and negative emotion models

%%
clear o2
o2=fmridisplay(); %initialize display object
o2 = surface(o2, 'axes', [0.5 .5 .4 .4], 'direction', 'surface right', 'orientation', 'lateral'); %right hemisphere lateral view
o2 = surface(o2, 'axes', [0.5 0  .4 .4], 'direction', 'surface right', 'orientation', 'medial'); %right hemisphere lateral view
 
%get surface data
pname = 'R.pial_MSMAll_2_d41_WRN_DeDrift.32k.mat'; % from Glasser_et_al_2016_HCP
load(which(pname));
set(o2.surface{1}.object_handle(1),'FaceVertexCData',cdata);
set(o2.surface{2}.object_handle(1),'FaceVertexCData',cdata);
colormap gray

h=findobj('type','patch');
set(h,'FaceColor','interp')
set(h,'CDataMapping','scaled');

%format colormap as cell array
for i=1:length(C)
Cm{i}=C(i,:);
end

%for this hemisphere 1:2:length(Cm) = left, 2:2:length(Cm) = right
for i=2:2:length(Cm) 
    tv=maskdat; %initialize temporary object
    tv.dat=double(tv.dat==i); %find the proper region
    o2=addblobs(o2,region(tv),'splitcolor',{[0 0 0] [0 0 0] Cm{i} Cm{i}},'depth',4); %set color based on wBIC across 3 models
end

delete(o2.surface{1}.object_handle(2))
delete(o2.surface{2}.object_handle(2))

h=findobj('type','patch');
% manually make 'transparent'
for p=1:2
    new_colors=get(h(p),'FaceVertexCData')';
    original_colors = vals2colormap(cdata, 'gray');
    alpha=sum(new_colors)';
    for i=1:length(original_colors)
        transparent_colors(i,:) = alpha(i) * new_colors(:,i)' + (1 - alpha(i)) * original_colors(i,:);
    end
    set(h(p),'FaceVertexCData',transparent_colors)
end
%%
clear o2;
o2=fmridisplay(); %initialize display object
o2 = surface(o2, 'axes', [0 .5 .4 .4], 'direction', 'surface left', 'orientation', 'lateral'); %left hemisphere lateral view
o2 = surface(o2, 'axes', [0 0  .4 .4], 'direction', 'surface left', 'orientation', 'medial'); %left hemisphere lateral view
 
%get surface data
pname = 'L.pial_MSMAll_2_d41_WRN_DeDrift.32k.mat'; % from Glasser_et_al_2016_HCP
load(which(pname));
set(o2.surface{1}.object_handle(1),'FaceVertexCData',cdata);
set(o2.surface{2}.object_handle(1),'FaceVertexCData',cdata);
colormap gray


h=findobj('type','patch');
set(h,'FaceColor','interp')
set(h,'CDataMapping','scaled');

%format colormap as cell array
for i=1:length(C)
Cm{i}=C(i,:);
end

%for this hemisphere 1:2:length(Cm) = left, 2:2:length(Cm) = right
for i=1:2:length(Cm) 
    tv=maskdat; %initialize temporary object
    tv.dat=double(tv.dat==i); %find the proper region
    o2=addblobs(o2,region(tv),'splitcolor',{[0 0 0] [0 0 0] Cm{i} Cm{i}}); %set color based on wBIC across 3 models
end

delete(o2.surface{1}.object_handle(2))
delete(o2.surface{2}.object_handle(2))
set(gca,'visible','off')


h=findobj('type','patch');
% manually make 'transparent'
for p=1:2
    new_colors=get(h(p),'FaceVertexCData')';
    original_colors = vals2colormap(cdata, 'gray');
    alpha=sum(new_colors)';
    for i=1:length(original_colors)
        transparent_colors(i,:) = alpha(i) * new_colors(:,i)' + (1 - alpha(i)) * original_colors(i,:);
    end
    set(h(p),'FaceVertexCData',transparent_colors)
end

saveas(gcf, [basedir 'Results' filesep 'SFig4'], 'png')