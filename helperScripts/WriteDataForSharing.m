% This script takes imaging data saved in a CANLAB fMRI data object and writes it out to separate .nii files for sharing

%load CANLAB data object
load FullDataSet.mat

for study = 1:18 %indices of studies
    
    study_inds=find(tv.Y==study); %get images for this study
    
    for subject =1:15 %indices of subjects
        
        %create temporary object for writing
        tv=FullDataSet; %initialize temporary fMRI data object
        tv.dat=tv.dat(:,study_inds(subject)); % grab data for this subject
        tv.fullpath=([basedir 'Data\ExperimentalData\S' num2str(study) '\subject' sprintf('%02d',subject) '.nii']); %write filename with appropriate study and subject number
        write(tv); %write data object as .nii file
    end
end