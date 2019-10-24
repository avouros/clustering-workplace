function [idx,w,iterations] = noclustering(x,init_centroids,varargin)
%NOCLUSTERING assignes datapoints to their closer centroids 

%INPUT:
% x: datapoins; rows = observations, columns = attributes
% init_centroids: initial centroids positions; if empty then random positions
% varargin:
%           (1) 'metric': metric to use to compute distances.
%		Default: 'squaredeuclidean'
%               E.g. 'metric', 'euclidean'

%OUTPUT
% idx: vector; the cluster of each datapoint.
% w: vector (of ones) specifying the final weight of each feature.
% iterations: number of iterations before converged (always 1).

    dmetric = 'squaredeuclidean';
    for i = 1:length(varargin)
        if isequal(varargin,'metric')
            dmetric = varargin{i+1};
        end
    end
    
    dist = pdist2(x,init_centroids,dmetric);
    [~,idx] = min(dist,[],2);
    w = ones(1,size(init_centroids,2));
    iterations = 1;      
end

