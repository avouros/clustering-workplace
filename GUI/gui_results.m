function gui_results(handles,eventdata)
%GUI_RESULTS executes the results

    dat = get(handles.run_clustering,'UserData');
    if isempty(dat)
        return
    end
    
    % Switch selected result
    switch eventdata.Value
        case 'performance (internal)'
            gui_performance_internal(dat);
        case 'performance (external)'
            gui_performance_external(dat);
        case 'centroids'
            plotter_init_centers(dat);
        otherwise
            error('Unknown result');
    end

end

