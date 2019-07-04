function DBi = cl_DaviesBouldinIndex_par(data,indexes,varargin)
%CL_DAVIESBOULDININDEX computes the Davies-Bouldin index.
% The optimal clustering solution has the smallest index (DBi) value.

% INPUT:
% - data: the dataset; rows: observations, columns: features
% - indexes: cluster of each datapoint
% - centroids: cluster centroids; rows: clusters, columns: features
% - Name-Value Pair Arguments:
%   - 'metric': any distance metric of https://bit.ly/2ztpzSz   

% OUTPUT:
% - DBi: The Davies-Bouldin index.

% Formula for ch_index: MATLAB documentation https://goo.gl/nTVJTZ

    dmetric = 'squaredeuclidean';
    for i = 1:length(varargin)
        if isequal(varargin{i},'metric')
            dmetric = varargin{i+1};
        end
    end

    [n,p] = size(data);
    K = unique(indexes);
    k = length(K);

    % Compute cluster centroids
    centroids = NaN(k,p);
    for ii = 1:k
        centroids(ii,:) = mean( data(indexes==K(ii),:),1 );
    end
    
    max_nums = -1*ones(k,1);
    
    parfor ki = 1:k
        % Intra-cluster distance (i)
        elems = find(indexes == K(ki));
        distance_i = pdist2(data(elems,:),centroids(ki,:),dmetric);
        distance_i = mean(distance_i);
        for kj = 1:k
            if ki ~= kj
                % Intra-cluster distance (j)
                elems = find(indexes == K(kj));
                distance_j = pdist2(data(elems,:),centroids(kj,:),dmetric);
                distance_j = mean(distance_j);                
                % Distance between centroids i and j
                distance_ij = pdist2( centroids(ki,:),centroids(kj,:),dmetric);
                % Within-to-between cluster distance ratio
                d_ij = (distance_i + distance_j) / distance_ij;
                % Store the maximum d_ij
                if d_ij > max_nums(ki)
                    max_nums(ki) = d_ij;
                end
            end
        end
    end
    
    DBi = sum(max_nums( max_nums~=-1 & ~isinf(max_nums) & ~isnan(max_nums) )) / k;  
end