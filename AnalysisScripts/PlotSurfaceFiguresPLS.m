load(which('bs_pls_workspace.mat'));
cmap=canlabCmap;
r=2; %aMCC
roi_masked_dat=apply_mask(masked_dat,remove_empty(fmri_data(which([rois{r} '.nii']))));
close all;
figure;
i=1; %pain
tv=roi_masked_dat;
tv.dat=b_pls_tZ{i,r};
tv=replace_empty(tv);
a=nan(size(tv.volInfo.image_indx));
a(tv.volInfo.image_indx)=tv.dat;
a=reshape(a,(tv.volInfo.dim));
b=interp2(squeeze(a(41,50:80,25:50)));
b(b==0)=nan;
surf(b)
colormap(cmap)
view(-90,60);set(gca,'Visible','off');
saveas(gcf, [basedir 'Results' filesep 'Fig3btop'], 'png')

i=2; %cognitive control
close all;
figure;

tv=roi_masked_dat;
tv.dat=b_pls_tZ{i,r};
tv=replace_empty(tv);
a=nan(size(tv.volInfo.image_indx));
a(tv.volInfo.image_indx)=tv.dat;
a=reshape(a,(tv.volInfo.dim));
b=interp2(squeeze(a(41,50:80,25:50)));
b(b==0)=nan;
surf(b)
colormap(cmap)
view(-90,60);set(gca,'Visible','off');
saveas(gcf, [basedir 'Results' filesep 'Fig3bmiddle'], 'png')

i=3; %negative emotion
close all;
figure;

tv=roi_masked_dat;
tv.dat=b_pls_tZ{i,r};
tv=replace_empty(tv);
a=nan(size(tv.volInfo.image_indx));
a(tv.volInfo.image_indx)=tv.dat;
a=reshape(a,(tv.volInfo.dim));
b=interp2(squeeze(a(41,50:80,25:50)));
b(b==0)=nan;
surf(b)
colormap(cmap)
view(-90,60);set(gca,'Visible','off');
saveas(gcf, [basedir 'Results' filesep 'Fig3bbottom'], 'png')
