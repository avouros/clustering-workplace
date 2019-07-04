function lof = lof_com(data,nn)
% Computes the Local Outlier Factor (LOF) based on the work of:
%Al Hasan, Mohammad, et al. "Robust partitional clustering by 
%outlier and density insensitive seeding." Pattern Recognition 
%Letters 30.11 (2009): 994-1002.

% This code is based on the R code formulas. Written by 
% Sarka Brodinova <sarka.brodinova@tuwien.ac.at>

% Author: Avgoustinos Vouros


%INPUT: 
% nn: number of neighbors
% data: dataset, rows = observations, columns = attributes

    dists = squareform(pdist(data));
    knns = nan(size(dists,2),nn);
    knns_idx = nan(size(dists,2),nn);
    
    for np = 1:size(dists,2)
        %find the nn-th nearest neighbors of the np-th datapoint
        [vals,N] = sort(dists(:,np));
        assert(vals(1)==0,'First value is not 0');
        N = N(1:nn+1);
        N(1) = [];
        knns(np,:) = dists(N,np);
        %keep also the indexes
        knns_idx(np,:) = N;
    end
    
    % Compute
    rd = nan(size(dists,2),1);
    for np = 1:size(dists,2)
        submat = [ knns(knns_idx(np,:),nn) , knns(np,:)' ];
        rd(np) = 1 / ( sum(max(submat,[],2)) / nn);
    end
    lof = nan(size(dists,2),1);
    for np = 1:size(dists,2)
        lof(np) = (sum(rd(knns_idx(np,:))) / nn) / rd(np);
    end
    
    % NaN values equal to 1
    tt = find(isnan(lof));
    lof(tt) = 1;
	tt = find(isinf(lof));
	lof(tt) = 1;

end

