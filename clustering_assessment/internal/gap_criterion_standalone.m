function [bestTuningBCD,bestTuningKBCD,bestTuningWCD,bestTuningKWCD,gap_stats,resFinal] = gap_criterion_standalone(x,ks,sparsity,B,method_init,method_clustering,varargin)
%GAP_CRITERION_STANDALONE 

% INPUT:
% - dataset: rows are observations and columns are attributes
% - k: number of target clusters
% - s: sparsity (or any secondary parameter) values
% - B: number of reference datasets
% - method_init: clustering initialization method
% - method_clustering: clustering algorithm

% OUTPUT:
% bestTuningBCD:  best optimal tuning between k and s based on
%                 maximization of between-cluster distance
% bestTuningKBCD: best optimal tuning of s per k based on
%                 maximization of between-cluster distance
% bestTuningWCD:  best optimal tuning between k and s based on
%                 minimization of inter-cluster distance
% bestTuningKWCD: best optimal tuning of s per k based on
%                 minimization of between-cluster distance
% gap_stats: various measurements of the gap statistic
% resFinal:  clustering results for every k and s

    REFDATA = 'PC';
    WithinClusterDictance = 'wcd_datapoints';
    BetweenClusterDistance = 'bcd_global_center';

    for i = 1:length(varargin)
        if isequal(varargin{i},'REFDATA')
            REFDATA = varargin{i+1};
        elseif isequal(varargin{i},'WCD')
            WithinClusterDictance = varargin{i+1};
        elseif isequal(varargin{i},'BCD')
            BetweenClusterDistance = varargin{i+1};
        elseif isequal(varargin{i},'DETERMINISTIC')
            s = RandStream('mt19937ar','Seed',0);
            RandStream.setGlobalStream(s);            
        end
    end

    nks = length(ks);
    ns = length(sparsity);
    
    resFinal = cell(nks,ns); %clustering results of the dataset using different k and s
    obj_data_wcd = nan(nks,ns);  %objFunc of the dataset using different k and s (within cluster distance)
    obj_data_bcd = nan(nks,ns);  %objFunc of the dataset using different k and s (between cluster distance)
    obj_ref_wcd = nan(nks,ns,B); %same as obj_data_wcd but for the reference datasets
    obj_ref_bcd = nan(nks,ns,B); %same as obj_ref_bcd but for the reference datasets

    % Compute Minimum Spanning Tree if Density K-Means++ is selected
    if isequal(method_init,'Density K-Means++')
        M = squareform(pdist(x));
        Mnorm = M./max(max(M)); 
        G = graph(Mnorm); %generate graph from M
        mst = minspantree(G); %generate Minimum Spanning Tree
        tmp = table2array(mst.Edges); %table to matrix
        L = tmp(:,3); %weights of edges of the Minimum Spanning Tree   
    else
        L = [];
    end
    
    % First cluster using the original dataset
    parfor i = 1:nks
        K = ks(i);
        % Execute initialization method
        centers = cluster_init(x,K,method_init,L);
        for j = 1:ns
            S = sparsity(j);
            [idx,~,w,iterations] = cluster_algorithm(x,K,S,centers,method_clustering);
            % Compute the clustering metrics
            [centroids,wcd_vec,wcd,bcd_mat,bcd] = clustering_metrics(x,idx,'Weights',w,...
                'option_within_cluster_distance',WithinClusterDictance,'option_between_cluster_distance',BetweenClusterDistance);
            resFinal{i,j} = {centroids,wcd_vec,wcd,bcd_mat,bcd,iterations};
            obj_data_wcd(i,j) = wcd;
            obj_data_bcd(i,j) = bcd;
        end
    end
    
    % Compute Minimum Spanning Tree if Density K-Means++ is selected
    L = cell(B,1);
    Xr = cell(B,1);
    if isequal(method_init,'Density K-Means++')
        parfor b = 1:B
            % Generate permuted dataset
            dataset_perm = generate_reference_data(x,REFDATA); 
            M = squareform(pdist(dataset_perm));
            Mnorm = M./max(max(M)); 
            G = graph(Mnorm); %generate graph from M
            mst = minspantree(G); %generate Minimum Spanning Tree
            tmp = table2array(mst.Edges); %table to matrix
            L{b} = tmp(:,3); %weights of edges of the Minimum Spanning Tree   
            Xr{b} = dataset_perm;
        end
    else
        parfor b = 1:B
            dataset_perm = generate_reference_data(x,REFDATA);
            Xr{b} = dataset_perm;
        end
    end
        
    % Cluster using the permuted datasets
    parfor b = 1:B
        for ii = 1:nks
            K = ks(ii);
            % Execute initialization method
            centers = cluster_init(Xr{b},K,method_init,L{b});
            for jj = 1:ns
                S = sparsity(jj);
                [idx,~,w,~] = cluster_algorithm(Xr{b},K,S,centers,method_clustering);
                % Compute the clustering metrics
                [~,~,wcd,~,bcd] = clustering_metrics(Xr{b},idx,'Weights',w,...
                    'option_within_cluster_distance',WithinClusterDictance,'option_between_cluster_distance',BetweenClusterDistance); 
                obj_ref_wcd(ii,jj,b) = wcd;         
                obj_ref_bcd(ii,jj,b) = bcd; 
            end
        end
    end
           
    % Gap statistic and simulation error
    %Take the log of the obj functions
    log_obj_data_wcd = log(obj_data_wcd);
    log_obj_data_bcd = log(obj_data_bcd);
    log_obj_ref_wcd = log(obj_ref_wcd); 
    log_obj_ref_bcd = log(obj_ref_bcd);
    %Expectation of the reference distributions
    Eref_wcd = mean(log_obj_ref_wcd,3);
    Eref_bcd = mean(log_obj_ref_bcd,3);
    %Gap statistic
    gapStat_wcd = Eref_wcd - log_obj_data_wcd;
    gapStat_bcd = log_obj_data_bcd - Eref_bcd;
    %Simulation error
    simuError_wcd = ( sqrt(1+(1/B)) * sqrt(var(log_obj_ref_wcd,1,3)) * sqrt((B-1)/B) );
    simuError_bcd = ( sqrt(1+(1/B)) * sqrt(var(log_obj_ref_bcd,1,3)) * sqrt((B-1)/B) );
    
    % Prepare results for output
    gap_stats.WCD = obj_data_wcd;
    gap_stats.BCD = obj_data_bcd;    
    gap_stats.logWCD = log_obj_data_wcd;
    gap_stats.logBCD = log_obj_data_bcd;
    gap_stats.logrWCD = log_obj_ref_wcd;
    gap_stats.logrBCD = log_obj_ref_bcd;   
    gap_stats.ErWCD = Eref_wcd;
    gap_stats.ErBCD = Eref_bcd;
    gap_stats.gapWCD = gapStat_wcd;
    gap_stats.gapBCD = gapStat_bcd;
    gap_stats.seWCD = simuError_wcd;
    gap_stats.seBCD = simuError_bcd;
    
    %% TO CORRECT!!!!
    % Optimal tuning 
    if length(sparsity) == 1 
        % WCD
        % Find the best tuning per k        
        bestTuningKWCD = [ks',sparsity*ones(length(ks),1)];
        b = 1;
        for i1 = 1:length(ks)-1
            if gapStat_wcd(i1) >= gapStat_wcd(i1+1) - simuError_wcd(i1+1)
                b = i1;
            end
        end    
        bestTuningWCD(1,1) = ks(b); %k value
        bestTuningWCD(1,2) = sparsity; %s value  
        bestTuningWCD(2,1) = b; %k index
        bestTuningWCD(2,2) = 1; %s index
        
        % BCD
        % Find the best tuning per k
        bestTuningKBCD = [ks',sparsity*ones(length(ks),1)];
        b = 1;
        for i1 = 1:length(ks)-1
            if gapStat_wcd(i1) >= gapStat_bcd(i1+1) - simuError_bcd(i1+1)
                b = i1;
            end
        end    
        bestTuningBCD(1,1) = ks(b); %k value
        bestTuningBCD(1,2) = sparsity; %s value  
        bestTuningBCD(2,1) = b; %k index
        bestTuningBCD(2,2) = 1; %s index
    else
        % WCD
        % Find the best tuning per k
        bestTuningKWCD = [ks',zeros(length(ks),1)];
        c = zeros(length(ks),1);
        for i1 = 1:length(ks)
            b = 1;
            for i2 = 1:length(sparsity)-1
                if gapStat_wcd(i1,i2) >= gapStat_wcd(i1,i2+1) - simuError_wcd(i1,i2+1)
                    b = i2;
                end
            end    
            bestTuningKWCD(i1,2) = sparsity(b);
            c(i1) = gapStat_bcd(b);
        end
        % Find the overall best tuning
        [~,maxGapi] = max(c);
        bestTuningWCD(1,1) = bestTuningKWCD(maxGapi,1); %k value
        bestTuningWCD(1,2) = bestTuningKWCD(maxGapi,2); %s value  
        bestTuningWCD(2,1) = find(ks==bestTuningKWCD(maxGapi,1)); %k index
        bestTuningWCD(2,2) = find(sparsity==bestTuningKWCD(maxGapi,2)); %s index  
        
        % BWD
        % Find the best tuning per k
        bestTuningKBCD = [ks',zeros(length(ks),1)];
        c = zeros(length(ks),1);
        for i1 = 1:length(ks)
            b = 1;
            for i2 = 1:length(sparsity)-1
                if gapStat_bcd(i1,i2) >= gapStat_bcd(i1,i2+1) - simuError_bcd(i1,i2+1)
                    b = i2;
                end
            end    
            bestTuningKBCD(i1,2) = sparsity(b);
            c(i1) = gapStat_bcd(b);
        end
        % Find the overall best tuning
        [~,maxGapi] = max(c);
        bestTuningBCD(1,1) = bestTuningKBCD(maxGapi,1); %k value
        bestTuningBCD(1,2) = bestTuningKBCD(maxGapi,2); %s value  
        bestTuningBCD(2,1) = find(ks==bestTuningKBCD(maxGapi,1)); %k index
        bestTuningBCD(2,2) = find(sparsity==bestTuningKBCD(maxGapi,2)); %s index        
    end    
end

