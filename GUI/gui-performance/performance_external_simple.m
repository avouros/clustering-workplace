function PERF_EXTER = performance_external_simple(true_values, CL_RESULTS)
%PERFORMANCE_EXTERNAL_SIMPLE 

    [~,s] = size(CL_RESULTS);
    k = length(unique(true_values));
    
    PERF_EXTER = struct('entropy',[],'purity',[],...
        'f_score',[],'accuracy',[],'recall',[],'specificity',[],'precision',[]);
    PERF_EXTER = repmat(PERF_EXTER,1,s);  
    
    for i = 1:s
        predicted_values = CL_RESULTS(k,i).idx;
        
        [clustering_entropy, ~] = cl_entropy(true_values, predicted_values);
        clustering_purity = cl_purity(true_values, predicted_values);
        [f_score,accuracy,recall,specificity,precision,~,~,~,~] = cl_FmeasureCL(true_values, predicted_values);
        
        PERF_EXTER(i).entropy = clustering_entropy;
        PERF_EXTER(i).purity = clustering_purity;
        PERF_EXTER(i).f_score = f_score;
        PERF_EXTER(i).accuracy = accuracy;
        PERF_EXTER(i).recall = recall;
        PERF_EXTER(i).specificity = specificity;
        PERF_EXTER(i).precision = precision;
    end
end

