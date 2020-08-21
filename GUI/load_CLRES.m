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
    plot_dataset(ORIGINAL_DATA{1},ORIGINAL_DATA{2},handles.plotter,handles.plotDim1,handles.plotDim2,handles.plotDim3,handles.generate_new_figure);
    
    % Update the GUI (2): options selection
    % PARAMS.UI = {delFeatsIdx,method_norm,method_centers,method_cluster};
    set(handles.dataset_feats,'Data',PARAMS.UI{1});
    set(handles.init_norm,'Value',PARAMS.UI{2});
    set(handles.init_centers,'Value',PARAMS.UI{3});
    set(handles.init_clustering,'Value',PARAMS.UI{4});
    % PARAMS.k
    set(handles.k_start,'Value',num2str(PARAMS.k(1)));
    set(handles.k_end,'Value',num2str(PARAMS.k(end)));   
    if length(PARAMS.k) > 1
        st = PARAMS.k(2)-PARAMS.k(1);
    else
        st = 1;
    end
    set(handles.k_step,'Value',num2str(st)); 
    % PARAMS.s;
    if PARAMS.s(1)~=0
        p = size(PARAMS.UI{1},1);
        if p == 1
            str_s = 1;
        else
            str_s = 1.1:0.1:sqrt(p);
        end
        str_s = arrayfun(@(x)num2str(x),str_s,'Uniform',0);
        str_ss = arrayfun(@(x)num2str(x),0.1:0.1:1,'Uniform',0);
        if PARAMS.s(1) ~= 0
            set(handles.s_start,'Items',str_s,'Value',num2str(PARAMS.s(1)));
            set(handles.s_end,'Items',str_s,'Value',num2str(PARAMS.s(end)));
        else
            set(handles.s_start,'Items',str_s,'Value',str_s(1));
            set(handles.s_end,'Items',str_s,'Value',str_s(1));
        end
        if length(PARAMS.s) > 1
            st = PARAMS.s(2)-PARAMS.s(1);
        else
            st = 0.1;
        end    
        set(handles.s_step,'Items',str_ss,'Value',num2str(st)); 
    end
    
    ORIGINAL_DATA = get(handles.button_load,'UserData');
    set(handles.run_clustering,'UserData',{CL_RESULTS,DATA,PARAMS,EXTRAS,ORIGINAL_DATA});
    
    myGUI = findobj(handles.clustering_gui,'Enable','off');
    set(myGUI,'Enable','on');
end

