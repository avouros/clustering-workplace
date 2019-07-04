function [C,lof] = ROBIN(data,k,nn,varargin)
%The ROBIN clustering initialisation method based on the work of:
% Al Hasan, Mohammad, et al. "Robust partitional clustering by outlier and 
% density insensitive seeding." Pattern Recognition Letters 
% 30.11 (2009): 994-1002.

    LOFCOM = 'lof_paper';
    DETERMINISTIC = 0;
    critRobin = 1.05;
    lof = [];
        
    for iii = 1:length(varargin)
        if isequal(varargin{iii},'LOFCOM')
            LOFCOM = varargin{iii+1};
			i = iii;
        elseif isequal(varargin{iii},'DETERMINISTIC')
            DETERMINISTIC = 1;
        elseif isequal(varargin{iii},'critRobin')
            critRobin = varargin{iii+1};
        elseif isequal(varargin{iii},'LOF')
            lof = varargin{iii+1};
        end
    end  
    
    % Compute distance matrix
    dists = squareform(pdist(data));
    
    % Compute LOF either based on the code or the paper
    if isempty(lof)
        switch LOFCOM
            case 'lof_com'
                lof = lof_com(data,nn);
            case 'lof_paper'
                lof = lof_paper(data,nn);
            case 'lof_given'
                lof = varargin{i+2};
            otherwise
                error('Wrong LOF');
        end       
    end
    
    % Select reference point
    if ~DETERMINISTIC
        n = size(data,1);
        r = randsample(n,1);
    else
        r = abs(1-lof);
        [~,r] = min(r);
    end
    
    
    % Find centroids
    C = [];
    while length(C) < k
        if length(C) < 2
            [~,sorted] = sort(dists(r,:),'descend');
        else
            [~,sorted] = sort(min(dists(C,:)),'descend');
        end
        sorted_lof = lof(sorted);
        id = find((sorted_lof < critRobin) == 1);
        id = id(1);
        r = sorted(id);
        C = union(C,r);
    end

end