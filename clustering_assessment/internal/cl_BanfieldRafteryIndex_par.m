function [BRi,aWCSS] = cl_BanfieldRafteryIndex_par(data,indexes,varargin)
%CL_BANFELDRAFTERYINDEX computes the Banfield-Raftery index.

% INPUT:
%  data: the dataset; rows: observations, columns: features
%  indexes: cluster of each datapoint

% OUTPUT:
%  BRi: The Banfield-Raftery index.

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
    
    aWCSS = zeros(k,1);
    aWCSS_log = zeros(k,1);
    formula = zeros(k,1);
    
    parfor i = 1:k
        % Find the points of the ith cluster
        elements = data(indexes==K(i),:);
        % Compute the within cluster square distance
        di = sum(pdist2(elements,centroids(i,:),'squaredeuclidean'))        
        % Average distance
        aWCSS(i) = di/length(elements);
        % Logarithm
        aWCSS_log(i) = log(aWCSS(i));
        % Formula
        formula(i) = length(elements) * aWCSS_log(i);
    end
    
    % Banfield-Raftery index
    BRi = sum(formula);  
    
    if isnan(BRi) || isinf(BRi)
        BRi = NaN;
    end    
end

