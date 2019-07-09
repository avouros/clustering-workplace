function gui_opening(handles)
%GUI_OPENING 

    % Activate parallel pool
    parfor i = 1:4
    end

    % Deactivate everything
    myGUI = findobj(handles.clustering_gui,'Enable','on');
    set(myGUI,'Enable','off'); 
    
    % Activate menu items and load
    set(handles.load_more_data,'Enable','on');
    set(handles.button_load,'Enable','on');
    set(handles.dCBB,'Enable','on');
    set(handles.dBrodinova,'Enable','on');
    set(handles.dYY,'Enable','on');
    set(handles.dGap,'Enable','on');
     
    % Clustering properties
    str_norms = {'none';'one';'n-norm';'z-score';'scale'};
    str_centroids = {'Random points';'First points';'K-Means++';'Kaufman';'ROBIN';'Density K-Means++'};
    str_clustering = {'None';'K-Means (Lloyd)';'K-Means (Hartigan-Wong)';'K-Medians';'Sparse K-Means'};
    set(handles.init_norm,'String',str_norms);
    set(handles.init_centers,'String',str_centroids);
    set(handles.init_clustering,'String',str_clustering);
    set(handles.init_norm,'Value',1);
    set(handles.init_centers,'Value',1);
    set(handles.init_clustering,'Value',1);   
    set(handles.dataset_norm,'String',str_norms);
    set(handles.dataset_norm,'Value',1);     
    
    % Results
    str_res = {'performance (internal)';'performance (external)';...
        'centroids'};
    set(handles.results_pop,'String',str_res);
    set(handles.results_pop,'Value',1);  
    
    set(handles.load_clustering,'Enable','on');
    set(handles.results_pop,'Enable','off');
end

