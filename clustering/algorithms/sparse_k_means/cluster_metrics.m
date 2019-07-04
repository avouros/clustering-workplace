function [WCSSp,BCSSp,WCSS,BCSS] = cluster_metrics(x,idx)
%CLUSTER_METRICS computes the within-cluster sum of squares (WCSS) and the 
%bithin-cluster sum of squares (BCSS).

% Input:
% - x   : a matrix where rows are observations and columns are attributes.
% - idx : vector specifying the cluster of each element.

% Output:
% - WCSSp : WCSS per dimension.
% - BCSSp : BCSS per dimension.
% - WCSS  : overall WCSS.
% - BCSS  : overall BCSS.


    [n,p] = size(x);
    k = length(unique(idx));

    % Compute WCSS
    WCSSp = zeros(1,p);
    for ii = 1:k
        WCSSp = WCSSp + sum(normalizations(x(idx == ii,:),'mean').^2);
    end
    WCSS = sum(WCSSp);
    
    % Compute BCSS
    BCSSp = sum(normalizations(x,'mean').^2) - WCSSp;
    BCSS = sum(BCSSp);
end

