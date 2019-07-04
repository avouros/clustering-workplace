function [sf,bcd,wcd] = cl_ScoreFunction_par(data,idx,option,varargin)
%CL_SCOREFUNCTION computes the Score Function [1]. The index in bounded
%between (0,1) and higher values indicate better clustering.

%REFERENCES:
%[1] Saitta, Sandro, Benny Raphael, and Ian FC Smith. "A bounded index for 
%    cluster validity." International Workshop on Machine Learning and Data
%    Mining in Pattern Recognition. Springer, Berlin, Heidelberg, 2007.

%INPUT:
% data: datapoins; rows = observations, columns = attributes
% idx: vector; the cluster of each datapoint.
% option: methods of between cluster distance computation:
%   - 'single_link'
%   - 'complete_link'
%   - 'average_link'
%   - 'centroids'

%OUTPUT:
% sf: the Score Function
% bcd: between cluster distance
% wcd: within cluster distance

    dmetric = 'squaredeuclidean';
    for i = 1:length(varargin)
        if isequal(varargin{i},'metric')
            dmetric = varargin{i+1};
        end
    end

    % Check input
    switch option
        case {'single_link','complete_link','average_link','centroids'}
        otherwise
            error('Wrong option.');
    end

    
    % Initialize
    k = unique(idx);
    K = length(k);
    [n,m] = size(data);
    bcd = 0;
    wcd = 0;

    % Compute cluster centroids
    centroids = NaN(K,m);
    for i = 1:K
        centroids(i,:) = mean(data(idx==k(i),:),1);
    end
        
    % Execute
    switch option
        case {'single_link','complete_link','average_link'}
            for i = 1:length(k)
                % Compute between cluster distance
                for j = i+1:length(k)
                    % Get the points of each cluster and find their
                    % distances
                    a = find(idx==k(i));
                    b = find(idx==k(j));
                    d = pdist2(data(a,:),data(b,:),'euclidean');
                    % Find the minimum (single) or maximum (complete) of 
                    %the distances
                    switch option
                        case 'single_link'
                            m = min(d(:));
                        case 'complete_link'
                            m = max(d(:));
                        case 'average_link'
                            m = mean2(d);
                    end
                    [row,col] = find(d==m);
                    % Update
                    if ~isempty(d(row,col))
                        bcd = bcd + d(row(1),col(1));
                    end
                end             
            end
            % Compute within cluster distance
            for i = 1:length(k)
                a = find(idx==k(i));
                centroid = mean(data(a,:));
                cd = 0;
                for j = 1:length(a)
                    cd = cd + norm(data(a(j),:) - centroid);
                end
                wcd = wcd + (1/length(a))*cd;
            end  
            
        case 'centroids'
            % Compute global cluster
            if n > 1 && m >= 1
                ztot = mean(data,1);
            elseif n == 1 
                ztot = data;
            end
            % Number of elements per cluster
            ni = zeros(K,1);
            parfor i = 1:K
                ni(i) = length(find(idx==k(i)));
            end         
            normT = ni./(n*K);
            % Compute between cluster distance
            bcd = pdist2(centroids,ztot,dmetric);
            bcd = sum(bcd .* normT);
            % Compute within cluster distance
            parfor i = 1:K
                wcd = wcd + ( sum(pdist2(data(idx==k(i),:),centroids(i,:),dmetric)) / ni(i));
            end    
    end
    
    % Compute the Score Function
    sf = 1 - ( 1 / (exp(exp(bcd-wcd))) );  
end

