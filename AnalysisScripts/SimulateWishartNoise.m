% Generate synthetic data (with and without effects) using wishart noise

%% specify models

studyInds=condf2indic(masked_dat.Y);
taskInds=condf2indic(ceil(masked_dat.Y/2));
catInds=condf2indic(ceil(masked_dat.Y/6));
clear *RDM;


%effects unique to each study -18
for i=1:size(studyInds,2)
    studyRDM(i,:)=pdist(studyInds(:,i),'seuclidean');
end

%RDM for each task separately (9 total)
for i=1:size(taskInds,2)
    taskRDM(i,:)= pdist(taskInds(:,i),'seuclidean');
end

%RDM for each category separately (3 total)
painRDM=pdist(catInds(:,1),'seuclidean');
cogRDM=pdist(catInds(:,2),'seuclidean');
affectRDM=pdist(catInds(:,3),'seuclidean');

X=[studyRDM' taskRDM' painRDM' cogRDM' affectRDM'];
for i=1:size(X,2)
    X(:,i)=1000*X(:,i)/sum(X(:,i));
end
labels={'Thermal Pain 1' 'Thermal Pain 2' 'Visceral Pain 1' 'Visceral Pain 2' 'Pressure Pain 1' 'Pressure Pain 2' 'Working Memory 1' 'Working Memory 2' 'Response Selection 1' 'Response Selection 2' 'Conflict 1' 'Conflict 2' 'Visual Neg. Affect 1' 'Visual Neg. Affect 2' 'Social Neg. Affect 1' 'Social Neg. Affect 2' 'Auditory Neg. Affect 1' 'Auditory Neg. Affect 2' 'Thermal Pain' 'Visceral Pain' 'Pressure Pain' 'Working Memory' 'Response Selection' 'Conflict' 'Visual Neg. Affect' 'Social Neg. Affect' 'Auditory Neg. Affect' 'Pain' 'Cognition' 'Neg. Affect'};
%% specify covariance
clear Y;
catInds=[condf2indic(ceil(masked_dat.Y/6)) condf2indic(ceil(masked_dat.Y/2)) condf2indic(ceil(masked_dat.Y)) condf2indic((1:270)')];
Y=(catInds);


if computeBootstrap
    clear b_null
    
    %% domain effects with increasing size
    cs=0;
    for es=[.1 .2 .3]
        cs=cs+1;
        clear b
        for it=1:500
            
            tY=Y;
            tY(:,4:12)=tY(:,4:12)*0;
            tY(:,1:3)=tY(:,1:3)*es;
            tY(:,13:30)=tY(:,13:30)*0;
            
            if it==1
                [W,D]=wishrnd(cov(tY'),18);
            else
                [W,D]=wishrnd(cov(tY'),18,D);
            end
            
            %     figure(1);imagesc(W);drawnow;
            d=1-corrcov(W);
            [b(it,:), dev, st] = glmfit(double(X),squareform(d)');
            distance_mats(it,:,:)=d;
            
            
            
            
            rng(it)
            for ij=1:200
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
                
                dY=d(bs_inds,bs_inds);
                dY=squareform(dY);
                dY(dY<.00001)=NaN;
                
                [full_x] = glmfit([ones(length(dY),1) double(X)],dY','normal','constant','off');
                
                b_null(ij,:)=full_x;
                
            end
            
            
            b_ste = squeeze(nanstd(b_null));
            b_mean = squeeze(nanmean(b_null));
            b_ste(b_ste == 0) = Inf;
            b_Z = b_mean ./ b_ste;
            b_P_domain(cs,it,:) = 2 * (1 - normcdf(abs(b_Z)));
        end
        
        beta_estimates_mean(cs,:)=mean(b);
        beta_estimates_std(cs,:)=std(b);
        distmats(cs,:,:)=mean(distance_mats);
        
    end
    
    
    %% study effects with increasing size
    cs=0;
    for es=[.1 .2 .3]
        cs=cs+1;
        clear b
        for it=1:500
            
            tY=Y;
            tY(:,4:12)=tY(:,4:12)*0;
            tY(:,1:3)=tY(:,1:3)*0;
            tY(:,13:30)=tY(:,13:30)*es;
            
            if it==1
                [W,D]=wishrnd(cov(tY'),18);
            else
                [W,D]=wishrnd(cov(tY'),18,D);
            end
            
            %     figure(1);imagesc(W);drawnow;
            d=1-corrcov(W);
            [b(it,:), dev, st] = glmfit(double(X),squareform(d)');
            distance_mats(it,:,:)=d;
            
            
            
            
            rng(it)
            for ij=1:200
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
                
                dY=d(bs_inds,bs_inds);
                dY=squareform(dY);
                dY(dY<.00001)=NaN;
                
                [full_x] = glmfit([ones(length(dY),1) double(X)],dY','normal','constant','off');
                
                b_null(ij,:)=full_x;
                
            end
            
            
            b_ste = squeeze(nanstd(b_null));
            b_mean = squeeze(nanmean(b_null));
            b_ste(b_ste == 0) = Inf;
            b_Z = b_mean ./ b_ste;
            b_P_study(cs,it,:) = 2 * (1 - normcdf(abs(b_Z))); %#ok<*SAGROW>
        end
        
        beta_estimates_mean(cs,:)=mean(b);
        beta_estimates_std(cs,:)=std(b);
        distmats(cs,:,:)=mean(distance_mats);
        
        
    end
    save([basedir 'Results' filesep 'wishartSimulation.mat'], 'b_P_study','b_P_domain')
else
    load([basedir 'Results' filesep 'wishartSimulation.mat'])
end