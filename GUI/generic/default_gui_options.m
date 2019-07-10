function default_gui_options(handles)
%DEFAULT_GUI_OPTIONS

    FontName = 'default';
    FontUnits = 'points';
    PaperUnits = 'points';
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
        % PaperUnits
        try
            eval(['handles.' fields{(i)} '.PaperUnits=' sprintf('''%s''',PaperUnits) ';']);
        catch
        end      
        % FontUnits
        try
            eval(['handles.' fields{(i)} '.FontUnits=' sprintf('''%s''',FontUnits) ';']);
        catch
        end           
    end
end

