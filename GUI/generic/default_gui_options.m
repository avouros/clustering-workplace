function default_gui_options(handles)
%DEFAULT_GUI_OPTIONS

    FontName = 'default';
    Units = 'character';
    
    fields = fieldnames(handles);
    for i = 1:length(fields)
        % FontName
        try
            eval(['handles.' fields{(i)} '.FontName=' sprintf('''%s''',FontName) ';']);
        catch
        end
        % Units
        try
            eval(['handles.' fields{(i)} '.Units=' sprintf('''%s''',Units) ';']);
        catch
        end        
    end
end

