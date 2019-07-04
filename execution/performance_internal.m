function [PERF_INTER,INTER_MEAS,CORR] = performance_internal(data,CL_RESULTS)
%PERFORMANCE_INTERNAL 

    [k,s] = size(CL_RESULTS);
    
    PERF_INTER = struct('wBCD',[],'wWCD',[],...
        'wSilh2',[],'wSilh',[],'wDBi',[],'wBRi',[],'wCHi',[],'wSF',[],...
        'Silh2',[],'Silh',[],'DBi',[],'BRi',[],'CHi',[],'SF',[]);
    PERF_INTER = repmat(PERF_INTER,k,s);
    
    INTER_MEAS = struct('wCenters',[],'wData',[],'wWCDvec',[],'wBCDmat',[]);
    INTER_MEAS = repmat(INTER_MEAS,k,s);
    
    CORR = cell(k,s);

    for i = 1:k
        for j = 1:s
            indexes = CL_RESULTS(i,j).idx;
            w = CL_RESULTS(i,j).w;
            % Basic metrics
            [centers,wcd_vec,wcd,bcd_mat,bcd,d] = clustering_metrics(data,indexes,'Weights',w,'option_between_cluster_distance','bcd_global_center'); 
            % Correlation (on the weighted data)
            cm = cl_correlation(d,indexes,'datapoints');      
            % Performance indexes (on the weighted data)
            [wSilh2,wSilh,~,~] = cl_SilhouetteIndex_par(d,indexes);
            wDBi = cl_DaviesBouldinIndex_par(d,indexes);
            wBRi = cl_BanfieldRafteryIndex_par(d,indexes);
            wCHi = cl_CalinskiHarabaszIndex_par(d,indexes);
            wSF = cl_ScoreFunction_par(d,indexes,'centroids');
            % Performance indexes
            [Silh2,Silh,~,~] = cl_SilhouetteIndex_par(data,indexes);
            DBi = cl_DaviesBouldinIndex_par(data,indexes);
            BRi = cl_BanfieldRafteryIndex_par(data,indexes);
            CHi = cl_CalinskiHarabaszIndex_par(data,indexes);
            SF = cl_ScoreFunction_par(data,indexes,'centroids');  
            % Store
            INTER_MEAS(i,j).wCenters = centers;
            INTER_MEAS(i,j).wData = d;
            INTER_MEAS(i,j).wWCDvec = wcd_vec;
            INTER_MEAS(i,j).wBCDmat = bcd_mat;
            CORR{i,j} = cm;
            PERF_INTER(i,j).wBCD = wcd;
            PERF_INTER(i,j).wWCD = bcd;
            PERF_INTER(i,j).wSilh2 = wSilh2;
            PERF_INTER(i,j).wSilh = wSilh;
            PERF_INTER(i,j).wDBi = wDBi;
            PERF_INTER(i,j).wBRi = wBRi;
            PERF_INTER(i,j).wCHi = wCHi;
            PERF_INTER(i,j).wSF = wSF;
            PERF_INTER(i,j).Silh2 = Silh2;
            PERF_INTER(i,j).Silh = Silh;
            PERF_INTER(i,j).DBi = DBi;
            PERF_INTER(i,j).BRi = BRi;
            PERF_INTER(i,j).CHi = CHi;
            PERF_INTER(i,j).SF = SF;
            PERF_INTER(i,j).BRi = BRi;
        end
    end    
end
