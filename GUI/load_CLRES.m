function err = load_CLRES(handles)
%LOAD_CLRES load a .mat file generated using this GUI
    err = 0;
    [dfile,dpath] = uigetfile({'*.mat'},'File Selector');
    if isequal(dfile,0)      
        return
    else
        load(fullfile(dpath,dfile));
        if ~exist('CL_RESULTS','var') || ~exist('DATA','var') || ~exist('PARAMS','var') ||...
            ~exist('EXTRAS','var') || ~exist('ORIGINAL_DATA','var')
            errordlg('Wrong file','Error');
            err = 1;
            return
        end
    end
    
    gui_opening(handles);

    % Update the GUI (1): load data
    set(handles.button_load,'UserData',ORIGINAL_DATA);
    gui_update(handles);
    plot_dataset(ORIGINAL_DATA{1},ORIGINAL_DATA{2},handles.plot_dataset,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure);
    
    % Update the GUI (2): options selection
    % PARAMS.UI = {delFeatsIdx,method_norm,method_centers,method_cluster};
    set(handles.dataset_feats,'Data',PARAMS.UI{1});
    str = get(handles.init_norm,'String');
    i = find(strcmp(str,PARAMS.UI{2})==1);
    set(handles.init_norm,'Value',i);
    str = get(handles.init_centers,'String');
    i = find(strcmp(str,PARAMS.UI{3})==1);
    set(handles.init_centers,'Value',i);
    str = get(handles.init_clustering,'String');
    i = find(strcmp(str,PARAMS.UI{4})==1);
    set(handles.init_clustering,'Value',i);
    % PARAMS.k
    tmp = str2num(get(handles.k_start,'String'));
    i = find((tmp==PARAMS.k(1))==1);
    set(handles.k_start,'Value',i);
    tmp = str2num(get(handles.k_end,'String'));
    i = find((tmp==PARAMS.k(end))==1);
    set(handles.k_end,'Value',i);   
    if length(PARAMS.k) > 1
        st = PARAMS.k(2)-PARAMS.k(1);
    else
        st = 1;
    end
    tmp = str2num(get(handles.k_step,'String'));
    i = find((tmp==st)==1);
    set(handles.k_step,'Value',i); 
    % PARAMS.s;
    if PARAMS.s(1)~=0
        tmp = str2num(get(handles.s_start,'String'));
        i = find((tmp==PARAMS.s(1))==1);
        set(handles.s_start,'Value',i);
        tmp = str2num(get(handles.s_end,'String'));
        i = find((tmp==PARAMS.s(end))==1);
        set(handles.s_end,'Value',i);   
        if length(PARAMS.s) > 1
            st = PARAMS.s(2)-PARAMS.s(1);
        else
            st = 0.1;
        end    
        tmp = str2num(get(handles.s_step,'String'));
        i = find((tmp==st)==1);
        if ~isempty(i)
            set(handles.s_step,'Value',i);
        end
    end
    
    ORIGINAL_DATA = get(handles.button_load,'UserData');
    set(handles.run_clustering,'UserData',{CL_RESULTS,DATA,PARAMS,EXTRAS,ORIGINAL_DATA});
    
    myGUI = findobj(handles.clustering_gui,'Enable','off');
    set(myGUI,'Enable','on');
end

