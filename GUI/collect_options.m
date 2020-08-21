function [method_norm,method_centers,method_cluster,x,KS,SS,iflag] = collect_options(handles)
%COLLECT_OPTIONS collects all the options prior to clustering

    iflag = 0;

    method_norm = get(handles.init_norm,'Value');
    method_centers = get(handles.init_centers,'Value');
    method_cluster = get(handles.init_clustering,'Value');
    
    data = get(handles.button_load,'UserData');
    x = data{1};
    feats = get(handles.dataset_feats,'Data');
    i = find(cell2mat(feats(:,3))==0);
    x(:,i) = [];
    
    k1 = str2double(get(handles.k_start,'Value'));
    k2 = str2double(get(handles.k_end,'Value'));
    ks = str2double(get(handles.k_step,'Value'));     
    KS = k1:ks:k2;
    
    switch method_cluster
        case 'Sparse K-Means'
            s1 = str2double(get(handles.s_start,'Value'));
            s2 = str2double(get(handles.s_end,'Value'));    
            ss = str2double(get(handles.s_step,'Value'));     
            SS = s1:ss:s2; 
        otherwise
            SS = 0;
    end
    
    if isequal(method_cluster,'K-Means (Hartigan-Wong)')
        try
            g03ef(rand(10,4),ones([10,1],'int64'),rand(1,4));
        catch
            errordlg('The NAG Toolbox for MATLAB is required to run this algorithm. The toolbox is available at https://www.nag.co.uk/nag-toolbox-matlab','Missing toolbox');
            iflag = 1;
        end
    end
end

