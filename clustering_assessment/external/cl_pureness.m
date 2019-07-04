function [clustering_pureness, cluster_pureness] = cl_pureness(true_values,predicted_values)
%CL_PURENESS indicates the degree of single class existence per cluster.
% Mathematically it is defined for each cluster as: 
% cluster_pureness = sum( nc_i/c_size ) / nc, 
% where nc_i is the number of elements with true class i inside the 
% cluster, c_size is the total number of elements inside the cluster and
% nc is the number of unique classes inside the cluster.
% Based on the cluster_pureness formula a cluster that has only one class
% will have a pureness equal to 1.
% The clustering_pureness index can then be defined as the average 
% cluster_pureness of all the clusters.

% INPUT:
%  true_values: data labels
%  predicted_values: clustering results

% OUTPUT:
%  clustering_pureness: overall clustering pureness
%  cluster_pureness: pureness of each cluster


    if size(true_values) ~= size(predicted_values)
        error('cl_pureness error: vectors of true and predicted values needs to have the same size');
    end    
    
    clusters = unique(predicted_values);
    nc = length(clusters);
    cluster_pureness = zeros(nc,1);
    
    for i = 1:nc
        % Find the true class of the elements inside the cluster
        tmp = true_values(predicted_values == clusters(i));
        % Count the number of occurrences per class in the cluster  
        nclasses = arrayfun(@(x) length(find(tmp==x)),unique(tmp));
        % Probability of occurrence per class
        nprob = arrayfun(@(x) x/sum(nclasses),nclasses);
        % Pureness of the cluster
        cluster_pureness(i) = mean(nprob);
    end

    % As pureness index take the average pureness of the clusters
    clustering_pureness = mean(cluster_pureness);
end

