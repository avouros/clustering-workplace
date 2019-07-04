function gui_update2(handles)
%GUI_UPDATE2 updates the GUI after the clustering

% button_load: loaded dataset
% run_clustering: {CL_RESULTS,DATA,PARAMS}, see clustering_exe.m
%         - CL_RESULTS: clustering results,
%         - DATA      : normalized dataset
%         - PARAMS    : tested Ks and Ss
% refresh_plots: {PERF_INTER,INTER_MEAS,CORR}, see performance_internal.m
%         - PERF_INTER: Indexes (for the active_index GUI table)
%         - INTER_MEAS: Measurements
%         - CORR      : Correlations (for the Correlation part of the GUI)   

    a = get(handles.run_clustering,'UserData');
    b = get(handles.refresh_plots,'UserData');
    
    [n,p] = size(a{2});
    
    Ks = a{3}.k;
    Ss = a{3}.s;
    %nKs = length(Ks);
    %nSs = length(Ss);
    
    % Table: active_k
    str = num2cell(Ks');
    act = num2cell(logical(zeros(length(Ks),1)));
    act{1} = true;
    str_tmp = repmat({''},length(Ks),1); %TODO: different brightness for each k
    t = [str,str_tmp,act];
    set(handles.active_k,'Data',t);   
    
    % Table: active_index
    str = fieldnames(b{1});
    nfields = size(str,1);
    act = num2cell(logical(zeros(nfields,1)));
    str_c = cell(nfields,1);
    colors = color_fullhue(nfields);
    for i = 1:nfields
        color = dec2hex(round(colors(i,:).*255));
        color = ['#',color(1,:),color(2,:),color(3,:)];
        str_tmp = num2str(colors(i,:)); %str2num should be used to get the color
        str_c{i} = strcat(['<html><body bgcolor="' color '" font color="' color '" text="' str_tmp '" width="80px">'], color);
    end
    act{1} = true;
    t = [str,str_c,act];
    set(handles.active_index,'Data',t);       
    
    % Table: active_w
    feats_t = get(handles.dataset_feats,'Data');
    nf = size(feats_t,1);
    str = cell(nf,1);
    str_c = cell(nf,1);
    for i = 1:nf
        if feats_t{i,3}
            str{i} = strcat('w_',num2str(i));
            str_c{i} = feats_t{i,2};
        end
    end
    str = str(~cellfun('isempty',str));
    str_c = str_c(~cellfun('isempty',str_c));
    act = num2cell(logical(zeros(p,1)));
    t = [str,str_c,act];
    set(handles.active_w,'Data',t);  
    
    % Table: correlation
    set(handles.correlation_table,'ColumnName',Ss);
    set(handles.correlation_table,'RowName',Ks);
    
    % Table: active_indexExt
    str = get(handles.performance_table,'ColumnName');
    nfields = size(str,1);
    act = num2cell(logical(zeros(nfields,1)));
    str_c = cell(nfields,1);
    colors = color_fullhue(nfields);    
    for i = 1:nfields
        color = dec2hex(round(colors(i,:).*255));
        color = ['#',color(1,:),color(2,:),color(3,:)];
        str_tmp = num2str(colors(i,:)); %str2num should be used to get the color
        str_c{i} = strcat(['<html><body bgcolor="' color '" font color="' color '" text="' str_tmp '" width="80px">'], color);
    end
    act{1} = true;
    t = [str,str_c,act];
    set(handles.active_indexExt,'Data',t);   
    
    % Update external indexes
    update_performance(handles);
end    
