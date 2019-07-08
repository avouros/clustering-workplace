function PERF_INTER = performance_internal_simple(data,CL_RESULTS)
%PERFORMANCE_INTERNAL_SIMPLE 

    [k,s] = size(CL_RESULTS);
    
    PERF_INTER = struct('wSilh2',[],'wSilh',[],'wDBi',[],'wBRi',[],'wCHi',[],...
            'Silh2',[],'Silh',[],'DBi',[],'BRi',[],'CHi',[]);
    PERF_INTER = repmat(PERF_INTER,k,s);

    for i = 1:k
        for j = 1:s
            indexes = CL_RESULTS(i,j).idx;
            w = CL_RESULTS(i,j).w;
            % Basic metrics
            [~,~,~,~,~,d] = clustering_metrics(data,indexes,'Weights',w,'option_between_cluster_distance','bcd_global_center'); 
            % Correlation (on the weighted data)    
            % Performance indexes (on the weighted data)
            [wSilh2,wSilh,~,~] = cl_SilhouetteIndex_par(d,indexes);
            wDBi = cl_DaviesBouldinIndex_par(d,indexes);
            wBRi = cl_BanfieldRafteryIndex_par(d,indexes);
            wCHi = cl_CalinskiHarabaszIndex_par(d,indexes);
            % Performance indexes
            [Silh2,Silh,~,~] = cl_SilhouetteIndex_par(data,indexes);
            DBi = cl_DaviesBouldinIndex_par(data,indexes);
            BRi = cl_BanfieldRafteryIndex_par(data,indexes);
            CHi = cl_CalinskiHarabaszIndex_par(data,indexes);
            % Store
            PERF_INTER(i,j).wSilh2 = wSilh2;
            PERF_INTER(i,j).wSilh = wSilh;
            PERF_INTER(i,j).wDBi = wDBi;
            PERF_INTER(i,j).wCHi = wCHi;
            PERF_INTER(i,j).wBRi = wBRi;
            PERF_INTER(i,j).Silh2 = Silh2;
            PERF_INTER(i,j).Silh = Silh;
            PERF_INTER(i,j).DBi = DBi;
            PERF_INTER(i,j).BRi = BRi;
            PERF_INTER(i,j).CHi = CHi;
            PERF_INTER(i,j).BRi = BRi;
        end
    end        
end

