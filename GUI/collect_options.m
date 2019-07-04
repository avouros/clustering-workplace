function [method_norm,method_centers,method_cluster,x,KS,SS] = collect_options(handles)
%COLLECT_OPTIONS collects all the options prior to clustering

    method_norm = get(handles.init_norm,'String');
    i = get(handles.init_norm,'Value');
    method_norm = method_norm{i};
    method_centers = get(handles.init_centers,'String');
    i = get(handles.init_centers,'Value');
    method_centers = method_centers{i};    
    method_cluster = get(handles.init_clustering,'String');
    i = get(handles.init_clustering,'Value');
    method_cluster = method_cluster{i};   
    
    data = get(handles.button_load,'UserData');
    x = data{1};
    feats = get(handles.dataset_feats,'Data');
    i = find(cell2mat(feats(:,3))==0);
    x(:,i) = [];
    
    k1 = get(handles.k_start,'String');
    i = get(handles.k_start,'Value');
    k1 = str2double(k1(i,:));
    k2 = get(handles.k_end,'String');
    i = get(handles.k_end,'Value');
    k2 = str2double(k2(i,:));    
    ks = get(handles.k_step,'String');
    i = get(handles.k_step,'Value');
    ks = str2double(ks(i,:));     
    KS = k1:ks:k2;
    
    switch method_cluster
        case 'Sparse K-Means'
            s1 = get(handles.s_start,'String');
            i = get(handles.s_start,'Value');
            s1 = str2double(s1(i,:));
            s2 = get(handles.s_end,'String');
            i = get(handles.s_end,'Value');
            s2 = str2double(s2(i,:));    
            ss = get(handles.s_step,'String');
            i = get(handles.s_step,'Value');
            ss = str2double(ss(i,:));     
            SS = s1:ss:s2; 
        otherwise
            SS = 0;
    end
end

