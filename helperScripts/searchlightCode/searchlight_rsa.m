function [dat, sl_size] = searchlight_rsa(dat1,X, varargin)
% Estimate regression on similarity structure of searchlight
%
% :Usage:
% ::
%
%     [dat, sl_size] = searchlight_rsa(train, test, varargin)
%
%
% :Inputs:
%
%   **dat1:**
%        fmri_data object with train.Y == size(train.dat,2)
%
%
% :Optional inputs:
%
%   **'r':**
%        searchlight sphere radius (in voxel) (default: r = 3 voxels)
%
%   **'parallel':**
%        run subset of voxels to distribute on a cluster.  flag must
%               be followed by array specifing id and total number of jobs
%               (e.g., 'parallel',[1,10]);
%
% :Outputs:
%
%   **dat:**
%        This contains an fmri_data object that contain
%        correlation pattern expression values
%
%   **sl_size:**
%        The number of voxels within each searchlight. Based on this
%        number, you can detect searchlights on the edge (searchlights
%        with low sl_size should be on the edge of the brain.
%
% ..
%     Author and copyright information:
%
%     Copyright (C) 2015  Luke Chang & Wani Woo
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% ..
%
% :Examples:
% ::
%
%    [r, dat] = searchlight_applymask(train, test, 'r', 5);
%
%    [r, dat] = searchlight_applymask(train, test, 'r', 5,'parallel',[1,10]);


r = 4; % default radius (in voxel)
doParallel = 0;

% parsing varargin
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case 'r' % radius
                r = varargin{i+1};
                varargin{i} = []; varargin{i+1} = [];
            case 'parallel'
                doParallel = 1;
                tmp = varargin{i+1};
                dist_id = tmp(1);
                dist_n = tmp(2);
                varargin{i} = []; varargin{i+1} = [];
        end
    end
end

if ~isa(dat1,'fmri_data')
    dat1 = fmri_data(dat1); dat1 = remove_empty(dat1);
end


dat1 = remove_empty(dat1);
n = size(dat1.dat,1);

% fprintf('\n Calculating correlation for voxel                   ');
b=zeros(n,size(X,2)+1);
sl_size=zeros(n,1);
tv=dat1.volInfo.xyzlist(~dat1.removed_voxels,:);
searchlight_indx=cell(n,1);
D=dat1.dat; %array is faster than structure...
for i = 1:n
    searchlight_indx = searchlight_sphere_prep(tv, i, r)>0;
    Y=pdist(D(searchlight_indx,:)','correlation');
     b(i,:)=mldivide([ones(length(find(~isnan(Y))),1) double(X(~isnan(Y),:))],Y(~isnan(Y))');
end
dat = fmri_data;
dat.volInfo = dat1.volInfo;
dat.removed_voxels = dat1.removed_voxels;
dat.dat = b;

end

% ========== SUBFUNCTION ===========

function indx = searchlight_sphere_prep(xyz, i, r)
seed = xyz(i,:);
indx = sum([xyz(:,1)-seed(1) xyz(:,2)-seed(2) xyz(:,3)-seed(3)].^2, 2) <= r.^2;
end

function dist_indx = select_voxels(dist_id, dist_n, vox_num)
% preparation of distribution indx

dist_indx = false(vox_num,1);

unit_num = ceil(vox_num/dist_n);
unit = true(unit_num,1);

start_point = (unit_num.*(dist_id-1)+1);
end_point = min(start_point+unit_num-1, vox_num);
dist_indx(start_point:end_point) = unit(1:end_point-start_point+1);

dist_indx = logical(dist_indx);
end

