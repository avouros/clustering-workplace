function cm = cl_correlation(data,idx,option)
%CL_CORRELATION computes correlation between the clusters

%INPUT:
% - data:   matrix; every row an observation and every column a feature.
% - idx:    vector specifying the cluster assignment of each datapoint.
% - option: 
%           (a) 'centroids': computes the correlation based on the cluster
%           centroids.
%           (b) 'datapoints': computes the correlation based on the closer
%           to the centroids datapoints.

%OUTPUT:
% - cm:     correlation matrix


    [n,p] = size(data);
    cl = unique(idx); 
    k = length(cl);
    centers = zeros(length(cl),p);
    cm = zeros(k,k);
    
    for i = 1:k
        a = find(idx==cl(i));
        if isempty(a)
            centers(i,:) = NaN;
        elseif length(a) == 1
            centers(i,:) = data(a,:);
        else
            centers(i,:) = mean(data(a,:));
        end 
    end
    
    switch option
        case 'centroids'
            centers = centers';
            for i = 1:k
                for j = i:k
                    if i==j
                        cm(i,j) = 1;
                        cm(j,i) = 1;
                    else
                        rho = corr(centers(:,i),centers(:,j));
                        cm(i, j) = rho;
                        cm(j, i) = rho;     
                    end
                end
            end
        case 'datapoints'
            for i = 1:k
                for j = i:k
                    if cl(i)==cl(j)
                        cm(i,j) = 1;
                        cm(j,i) = 1;
                    else
                        % Find the closer points of the centers
                        a = find(idx == cl(i));
                        b = find(idx == cl(j));
                        dist1 = sum( (data(a,:)-repmat(centers(i,:),length(a),1)).^2 ,2);
                        dist2 = sum( (data(b,:)-repmat(centers(j,:),length(b),1)).^2 ,2);
                        [~, ord] = sort(dist1);
                        sel1 = a(ord);
                        [~, ord] = sort(dist2);
                        sel2 = b(ord);
                        
                        n1 = length(sel1);
                        n2 = length(sel2);
                        n = min(n1, n2);                                

                        % Compute the correlation between n elements                        
                        rho = corr2( data(sel1(1:n), :), data(sel2(1:n), :) );
                        cm(i, j) = rho;
                        cm(j, i) = rho;     
                    end
                end
            end            
    end
end

