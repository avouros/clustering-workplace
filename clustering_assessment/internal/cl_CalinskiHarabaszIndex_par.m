function [ch_index,Sb,Sw] = cl_CalinskiHarabaszIndex_par(data,indexes,varargin)
%CL_CALINSKIHARABASZINDEX computes the Calinski-Harabasz index.
% Well-defined clusters have a large between-cluster variance (Sb) and a 
% small within-cluster variance Sw. The larger the index (ch_index), the 
% better the data partition

% INPUT:
%  data: the dataset; rows: observations, columns: features
%  indexes: cluster of each datapoint

% OUTPUT:
%  ch_index: The Calinski-Harabasz index.
%  Sb: the betweeen-cluster scatter matrix
%  Sw: the internal scatter matrix

% Formula for ch_index: R documentation https://goo.gl/45sjVg
%                       MATLAB documentation https://goo.gl/dpFfv3

% Note: in some extreme cases ch_index equals NaN or Inf. This happens in
% cases of empty clusters.

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

    clusters = 1:size(centroids,1);
    mean_dataset = mean(data);
    
    Sb = 0;
    Sw = 0;
    parfor k = 1:length(clusters)
        %find the elements of the kth cluster
        elements = data(indexes == clusters(k),:);
        Nk = size(elements,1);
        %betweeen-cluster scattering
        d = pdist2(centroids(k,:),mean_dataset,dmetric);
        Sb = Sb + (Nk * d);
        %internal scattering
        Sw = Sw + sum(pdist2(elements,centroids(k,:),dmetric));
    end

    % Calinski-Harabasz index
    ch_index = ( sum(diag(Sb)) * (size(data,1)-size(centroids,1)) ) / ( sum(diag(Sw)) * (size(centroids,1) - 1) );
    
    if isnan(ch_index) || isinf(ch_index)
        ch_index = NaN;
    end
end
