function [CL_RESULTS,x,PARAMS,EXTRAS] = clustering_exe(method_norm,method_centers,method_cluster,x,KS,SS)
%CLUSTERING_EXE

    VOCAL = 0; %for debugging
    
    [n,p] = size(x);
    nk = length(KS);
    ns = length(SS);
    
    CL_RESULTS = struct('idx',[],'w',[],'iter',[],'centers',[],'centers0',[]);
    CL_RESULTS = repmat(CL_RESULTS,nk,ns);
    PARAMS.k = KS;
    PARAMS.s = SS;
    
    % Normalize the data
    x = normalizations(x,method_norm);
    x(find(isnan(x))) = 0; %turn NaN values to 0
    
    % Extras for 'ROBIN' and 'Density K-Means++'
    EXTRAS = cluster_extras(x);

    % Execute clustering
    for i = 1:nk
        if VOCAL
            fprintf('k=%d\n',K(i)); 
            fprintf('\tinitialize\n'); 
            tic 
        end
        k = KS(i);
        % Initialize the clusters
        if isequal(method_centers,'Density K-Means++')
            centers = cluster_init(x,k,method_centers,EXTRAS.MST);
        elseif  isequal(method_centers,'ROBIN') || isequal(method_centers,'ROBIN-DETERM')
            centers = cluster_init(x,k,method_centers,EXTRAS.LOF);
        else
            centers = cluster_init(x,k,method_centers);
        end
        if VOCAL
            toc
            fprintf('\tclustering\n'); 
            tic
        end
        for j = 1:ns
            s = SS(j);
            % Execute clustering
            [idx,centroids,w,iterations] = cluster_algorithm(x,k,s,centers,method_cluster);
            if ~isempty(find(isnan(w)))
                return
            end
            CL_RESULTS(i,j).idx = idx;
            CL_RESULTS(i,j).w = w;
            CL_RESULTS(i,j).iter = iterations;
            CL_RESULTS(i,j).centers = centroids;
            CL_RESULTS(i,j).centers0 = centers; %init centers
        end
        if VOCAL
            toc
        end
    end
end
         
