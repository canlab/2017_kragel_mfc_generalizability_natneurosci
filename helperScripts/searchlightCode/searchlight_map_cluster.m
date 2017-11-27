function b = searchlight_map_cluster
addpath(genpath('/work/wagerlab/Resources/CanlabCore'))
addpath(genpath('/work/wagerlab/Resources/spm8_r5236'))
addpath '/home/phkr0046/'
load data

%% bootstrap resampling of subjects within studies

rng('shuffle')

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

studyInds=condf2indic(masked_dat.Y);
taskInds=condf2indic(ceil(masked_dat.Y/2));
catInds=condf2indic(ceil(masked_dat.Y/6));
clear *RDM;

%effects unique to each study
for i=1:size(studyInds,2);
    studyRDM(i,:)=pdist(studyInds(:,i),'seuclidean');
end

%RDM for each task separately (6 total)
for i=1:size(taskInds,2)
    taskRDM(i,:)= pdist(taskInds(:,i),'seuclidean');
end

%RDM for each category separately (3 total)
painRDM=pdist(catInds(:,1),'seuclidean');
cogRDM=pdist(catInds(:,2),'seuclidean');
affectRDM=pdist(catInds(:,3),'seuclidean');

X=[studyRDM' taskRDM' painRDM' cogRDM' affectRDM'];
for i=1:size(X,2);
    X(:,i)=1000*X(:,i)/sum(X(:,i));
end

masked_dat.dat=masked_dat.dat(:,bs_inds);
searchlight_maps=searchlight_rsa(masked_dat,X);
b=searchlight_maps.dat;
% save(['/home/phkr0046/' datestr(now,30) '.txt'],'b','-ascii')
save([datestr(now,30) '.txt'],'b','-ascii')

