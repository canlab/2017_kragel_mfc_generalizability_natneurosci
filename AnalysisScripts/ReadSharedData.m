% This script takes imaging data saved in .nii files and formats as a CANLAB data object

image_counter=0; % initialize counter for storing data
for study = 1:18 %indices of studies
        
    for subject =1:15 %indices of subjects

        tv=fmri_data([basedir 'Data' filesep 'ExperimentalData' filesep 'S' num2str(study) filesep 'subject' sprintf('%02d',subject) '.nii']); % read data from google drive
        tv=replace_empty(tv); %replace voxels with 0 values (for concatenating)
        image_counter=image_counter+1; %update counter for indexing
        
        if image_counter==1 %if this is the first image in data object
        FullDataSet=tv;    %initialize as temporary object
        FullDataSet.Y(image_counter,1)=study; %first study so Y = 1

        else
        FullDataSet.dat=[FullDataSet.dat tv.dat]; %concatenate data
        FullDataSet.Y(image_counter,1)=study; %add study index to Y
        end
    end
end

FullDataSet=remove_empty(FullDataSet); %remove voxels that are always 0

save([basedir 'Data' filesep 'ExperimentalData' filesep  'FullDataSet.mat'],'FullDataSet'); %save to google drive as data object in .mat file 