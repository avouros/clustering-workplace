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
    
    % Extras
    EXTRAS = cluster_extras(x);
    EXTRAS1 = struct('bcdc',[],'bcdgc',[],'bcdwcd',[], 'wcdc',[],'wcdwc',[],'wcdd',[],'wcdwd',[]);
    EXTRAS1 = repmat(EXTRAS1,nk,ns);
    EXTRAS2 = struct('MST',[],'LOF',[],'ard',[],'density',[],'neighbors',[]);
    EXTRAS2 = repmat(EXTRAS2,nk,ns);
    EXTRAS3 = struct('LOF',[],'ard',[],'density',[],'neighbors',{});
    EXTRAS3 = repmat(EXTRAS3,nk,ns);
    EXTRAS4 = cell(nk,ns);

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
            CL_RESULTS(i,j).idx = idx;
            CL_RESULTS(i,j).w = w;
            CL_RESULTS(i,j).iter = iterations;
            CL_RESULTS(i,j).centers = centroids;
            CL_RESULTS(i,j).centers0 = centers; %init centers
            EXTRAS2(i,j) = cluster_extras(repmat(w,n,1).*x);
            % LOF of the final centroids
            cents = clustering_metrics(x,idx,'Weights',w);
            [LOF,ard,density,neighbors] = lof_data_paper(repmat(w,n,1).*x,cents,10);
            EXTRAS3(i,j).LOF = LOF;
            EXTRAS3(i,j).ard = ard;
            EXTRAS3(i,j).density = density;
            EXTRAS3(i,j).neighbors = neighbors;  
            % Correlation
            EXTRAS4{i,j} = cl_correlation(repmat(w,n,1).*x,idx,'datapoints');
            % WCD and BCD
            [~,~,EXTRAS1(i,j).wcdc,~,EXTRAS1(i,j).bcdc] = clustering_metrics(x,idx,'Weights',w,...
                    'option_within_cluster_distance','wcd_centroids',...
                    'option_between_cluster_distance','bcd_centroids');  
            [~,~,EXTRAS1(i,j).wcdwc,~,EXTRAS1(i,j).bcdgc] = clustering_metrics(x,idx,'Weights',w,...
                    'option_within_cluster_distance','wcd_centroids_average',...
                    'option_between_cluster_distance','bcd_global_center'); 
            [~,~,EXTRAS1(i,j).wcdd,~,EXTRAS1(i,j).bcdwcd] = clustering_metrics(x,idx,'Weights',w,...
                    'option_within_cluster_distance','wcd_datapoints',...
                    'option_between_cluster_distance','bcd_wcd'); 
            [~,~,EXTRAS1(i,j).wcdwd,~,~] = clustering_metrics(x,idx,'Weights',w,...
                    'option_within_cluster_distance','wcd_datapoints_average');   
        end
        if VOCAL
            toc
        end
    end
    EXTRAS.EXTRAS1 = EXTRAS1;
    EXTRAS.EXTRAS2 = EXTRAS2;
    EXTRAS.EXTRAS3 = EXTRAS3;
    EXTRAS.EXTRAS4 = EXTRAS4;
end
         
