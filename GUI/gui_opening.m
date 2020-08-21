function gui_opening(handles)
%GUI_OPENING 

    % Activate parallel pool
    parfor i = 1:4
    end
    
    % Methods (in the future maybe I can write a cfg file for this)
    str_norms = {'none';'one';'n-norm';'z-score';'scale'};
    str_centroids = {'Random points';'First points';'K-Means++';'Kaufman';'ROBIN(D)';'ROBIN(S)';'Density K-Means++'};
    str_clustering = {'None';'K-Means (Lloyd)';'K-Means (Hartigan-Wong)';'K-Medians';'Sparse K-Means'};
    str_res = {'performance (internal)';'performance (external)';'centroids'};
    str_plots = {'boxplot'};
    
    % Deactivate everything
    myGUI = findobj(handles.clustering_gui,'Enable','on');
    for i = 1:length(myGUI)
        set(myGUI(i),'Enable','off'); 
    end
    set(handles.dataset_feats,'Enable','off'); 
    set(handles.TextArea,'Enable','off');
    
    % Activate menu items and load
    set(handles.load_more_data,'Enable','on');
    set(handles.button_load,'Enable','on');
    set(handles.dCBB,'Enable','on');
    set(handles.GeneratedatasetMenu,'Enable','on');
    set(handles.dBrodinova,'Enable','on');
    set(handles.dYY,'Enable','on');
    set(handles.dGap,'Enable','on');
    set(handles.dMixed,'Enable','on');
    
    % Data properties
    set(handles.dataset_norm,'Items',str_norms,'Value',str_norms(1));
    set(handles.features_values_plot,'Items',str_plots,'Value',str_plots(1)) 
    
    % Clustering properties
    set(handles.init_norm,'Items',str_norms,'Value',str_norms(1));
    set(handles.init_centers,'Items',str_centroids,'Value',str_centroids(1));
    set(handles.init_clustering,'Items',str_clustering,'Value',str_clustering(1));

    % Results
    set(handles.results_pop,'Items',str_res,'Value',str_res(1));
    
    set(handles.load_clustering,'Enable','on');
    set(handles.results_pop,'Enable','off');
end

