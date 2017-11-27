% Mask data within GM and LONI atlas MFC regions

mask_template=fmri_data(which('AllRegions.nii')); % this is a .nii file where all 6 MFC regions have a value of 1 and all other voxels are set to 0

gm_mask=fmri_data(which('TPM.nii')); %tissue probability map from SPM distribution
gm_mask.dat=gm_mask.dat(:,1)>.5; %threshold at prob GM > 50%
[masked_dat]=apply_mask(FullDataSet,mask_template); %first apply MFC mask
[masked_dat]=apply_mask(masked_dat,gm_mask); %then apply GM mask

% some contrasts have no ACC activity, clean up for analysis CHECK THIS
masked_dat.Y=masked_dat.Y(~masked_dat.removed_images);
FullDataSet.Y=FullDataSet.Y(~masked_dat.removed_images);
masked_dat=remove_empty(masked_dat);