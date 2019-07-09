function gui_results(handles,eventdata)
%GUI_RESULTS executes the results

    dat = get(handles.run_clustering,'UserData');
    if isempty(dat)
        return
    end
    
    % Get selected result
    ev = eventdata.Source.String;
    i = eventdata.Source.Value;
    
    % Switch selected result
    switch ev{i}
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

