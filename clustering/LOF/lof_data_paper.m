function [LOF,ard,density,neighbors] = lof_data_paper(data,data2,nn,density_ref)
%LOF_DATA_PAPER computes the Local Outlier Factor (LOF) of data2 based on 
%the work of [1]. This code is based on the paper formulas.

% REFERENCES:
% [1] Al Hasan, Mohammad, et al. "Robust partitional clustering by 
%     outlier and density insensitive seeding." Pattern Recognition 
%     Letters 30.11 (2009): 994-1002.

%INPUT: 
% nn: number of neighbors
% data: dataset, rows = observations, columns = attributes
% data2: dataset, rows = observations, columns = attributes

% Author: Avgoustinos Vouros

    n = size(data2,1);
    
    % First compute the LOF scores of the primary dataset
    if nargin < 4
        [~,~,density_ref,~] = lof_paper(data,nn);
    end
                
    density = zeros(n,1);
    neighbors = cell(n,1);
    ard = zeros(n,1);
    LOF = nan(n,1);
    
    % Then compute the LOF scores of the seconday dataset
    parfor i = 1:n
        % Find the distance between the i-th datapoint and all the elements
        %of the dataset
        tmp = pdist2(data2(i,:),data);
        % Sort the distances using ascending order
        dtmp = sort(tmp,'ascend');
        % Take the nn closer neighbors of the i-th datapoint
        r = dtmp(nn+1); %+1 because we have the distance between the i-th and i-th datapoint
        tmp = find(tmp <=r );
        tmp(tmp==i) = []; %remove the i-th datapoint
        neighbors{i} = tmp;
        
        % Compute the density of the i-th datapoint
        density(i) = length(neighbors{i}) / sum(pdist2(data2(i,:),data(neighbors{i},:)));

        % Compute the average relative density of the datapoint
        ard(i) = density(i) / (sum(density_ref(neighbors{i})) / length(neighbors{i}));

        % Compute the Local Outlier Factor score
        LOF(i) = 1 / ard(i);
    end
end

