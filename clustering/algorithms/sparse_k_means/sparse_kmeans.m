function [idx,centroids,w,niter,C,flag] = sparse_kmeans(x,k,s,varargin)
% SPARSE_KMEANS implements the sparse k-means algorithm of [1].
% Original R code can be found here: https://bit.ly/2PUFKim
% The MATLAB implementation uses the method of [2] to obtain the initial
% centroids in a deterministic way.

% References:

% [1] Witten, Daniela M., and Robert Tibshirani. "A framework for feature 
%     selection in clustering." Journal of the American Statistical 
%     Association 105.490 (2010): 713-726.

% [2] N. Nidheesh, K.A. Abdul Nazeer, P.M. Ameer, 
%     An enhanced deterministic K-Means clustering 
%     algorithm for cancer subtype prediction from 
%     gene expression data, Computers in Biology
%     and Medicine 91C (2017) pp. 213-221.
%     https://doi.org/10.1016/j.compbiomed.2017.10.014


% Input:
% - x : a matrix where rows are observations and columns are attributes.
% - k : number of target clusters.
% - s : sparsity parameter.
% - varargin:
%           (1) 'ITER', N : number of main iterations until termination
%               E.g. normalizations('ITER',6)
%           (2) 'ITERk', N : number of k-means iterations until termination
%               E.g. normalizations('ITER',100)
%           (3) 'Start', k-by-p: initial centroids given as a double array
%               where rows (k) is the number of clusters and columns (p)
%               the dimensions of the dataset

% Output:
% - idx       : vector specifying the cluster of each element.
% - centroids : final location of the centroids.
% - w         : vector specifying the final weight of each feature.
% - niter     : number of iterations until converge.
% - C         : initial centroids
% - flag      : error indication (empty clusters) = 1 

% Note:
% The weighted between-cluster sum of squares of the clustering can be 
% computed using the [~,BCSSp] = cluster_metrics(x,idx) function. 
% Then [BCSS_w = sum(BCSSp .* w)].



    % Default number of iterations
    ITER = 6;    %main iterations
    ITERk = 100; %kmeans iterations
    init_centers = [];

    for i = 1:length(varargin)
        if isequal(varargin{i},'ITER')
            ITER = varargin{i+1};
        elseif isequal(varargin{i},'ITERk')
            ITERk = 100;
        elseif isequal(varargin{i},'Start')
            init_centers = varargin{i+1};
        end
    end

    % Initialize
    [n,p] = size(x);
    niter = 0; %number of iterations until converge

    % Feature weights (init)
    w = (1/sqrt(p)) * ones(1,p);
    w_old = zeros(1,p);  
    
    if isempty(init_centers)
        % Use DKM++ to init the centroids
        C = dkmpp_init(x,k);
        init_centers = x(C,:);
    else
        C = init_centers;
    end

    % Do K-Means clustering
    [idx,centroids,~,flag] = kmeans_lloyd(x,k,init_centers,ITERk);
    if flag==1
        % Empty clusters
        idx = nan(n,1);
        centroids = nan(k,p);
        return
    end

    % Main loop
    while (sum(abs(w-w_old)) / sum(abs(w_old))) > 10^-4 && (niter < ITER)

        % Update the variables
        niter = niter + 1;
        %w(w<0) = 10^-6; %negative weights are possible... why?      
        w_old = w;       

        % Update the clusters (after the first iteration)
        if niter > 1
            % Scale each feature by w
            wx = x .* repmat(sqrt(w),n,1);  
            % Compute the new centroids
            for ii = 1:k
                elements = find(idx == ii);
                if length(elements) > 1
                    centroids(ii,:) = mean(wx(elements,:));
                elseif length(elements) == 1 %if only 1 element
                    centroids(ii,:) = wx(elements,:);             
                elseif isempty(elements) %if no elements
                    centroids(ii,:) = centroids(ii,:); 
                end                
            end
            % Do K-Means clustering using the new computed centroids as init centroids 
            [idx,centroids,~,flag] = kmeans_lloyd(wx,k,centroids,ITERk);
            if flag==1
                % Empty clusters
                idx = nan(n,1);
                centroids = nan(k,p);
                return
            end            
        end

        %% Update the weights:
        % Compute within-cluster sum of squares (per feature)
        [WCSSp,~,~,~] = cluster_metrics(x,idx);
        % Compute total cluster sum of squares (per feature)
        [TSSp,~,~,~] = cluster_metrics(x,ones(size(x,1),1));
        % Find Delta using binary search
        delta = BinarySearchDelta(-WCSSp+TSSp , s);
        % Compute the new weights
        w_tmp = sign(-WCSSp+TSSp) .* max(0,abs(-WCSSp+TSSp)-delta); 
        w = w_tmp/norm(w_tmp,2);
        w(w<0) = 0; %assign 0 to negative weights
    end
end


