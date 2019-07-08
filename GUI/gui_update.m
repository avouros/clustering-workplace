function gui_update(handles)
%GUI_UPDATE updates the GUI after a new dataset is loaded

    data = get(handles.button_load,'UserData');
    x = data{1};
    y = data{2};
    [n,p] = size(x);
    
    %% Features properties
    set(handles.features_properties,'Enable','on');
    set(handles.hold_features_properties,'Enable','on');
    set(handles.features_properties,'String',[1:p]);
    set(handles.features_properties,'Value',1);
    
    %% Plot dimensions
    set(handles.generate_new_figure,'Enable','on');
    set(handles.plotDim1,'Enable','on');
    set(handles.plotDim1,'String',num2str(1));
    set(handles.plotDim2,'String',num2str(0));
    set(handles.plotDim3,'String',num2str(0));
    set(handles.plotDim1,'Value',1);
    set(handles.plotDim2,'Value',1);   
    set(handles.plotDim3,'Value',1); 
    set(handles.plotDim2,'Enable','off');
    set(handles.plotDim3,'Enable','off');   
    if size(x,2) > 1
        set(handles.plotDim2,'Enable','on');
        set(handles.plotDim1,'String',['1';'2']);
        set(handles.plotDim2,'String',['1';'2']);
        set(handles.plotDim1,'Value',1);
        set(handles.plotDim2,'Value',2);   
        set(handles.plotDim3,'String',num2str(0));
        set(handles.plotDim3,'Value',1); 
        set(handles.plotDim3,'Enable','off'); 
    end
    if size(x,2) > 2
        set(handles.plotDim3,'Enable','on');    
        set(handles.plotDim1,'String',num2str([1:1:size(x,2)]'));
        set(handles.plotDim2,'String',num2str([1:1:size(x,2)]'));
        set(handles.plotDim3,'String',num2str([1:1:size(x,2)]'));
        set(handles.plotDim1,'Value',1);
        set(handles.plotDim2,'Value',2);  
        set(handles.plotDim3,'Value',3);  
    end   
    set(handles.generate_new_figure,'Value',0);   
    
    %% Clustering parameters
    str_k = 1:100;           % K available values
    str_s = 1.1:0.1:sqrt(p); % S available values
    str_sk = 1:20; 
    if p == 1
        str_s = 1;
    else
        str_ss = 0.1:0.1:1;
    end
    set(handles.k_start,'String',str_k);
    set(handles.s_start,'String',str_s);    
    set(handles.k_end,'String',str_k);
    set(handles.s_end,'String',str_s);    
    set(handles.k_step,'String',str_sk);
    set(handles.s_step,'String',str_ss);  
    set(handles.k_start,'Value',1);
    set(handles.s_start,'Value',1);    
    set(handles.k_end,'Value',1);
    set(handles.s_end,'Value',1);    
    set(handles.k_step,'Value',1);
    set(handles.s_step,'Value',1);  
    
    %% Classes/clusters info
    info = data{5};
    if ~isnan(info(1))
        set(handles.corrk,'String',info(1));
    else
        set(handles.corrk,'String','-');
    end
    if ~isnan(info(2))
        set(handles.corrc,'String',info(2));
    else
        set(handles.corrc,'String','-');
    end
    
    %% Features table
    [~,p] = size(x);
    str1 = cell(p,1);
    str2 = cell(p,1);
    colors = color_fullhue(p);
    for i = 1:p
        str1{i} = strcat('feature_',num2str(i));
        color = dec2hex(round(colors(i,:).*255));
        color = ['#',color(1,:),color(2,:),color(3,:)];
        str_tmp = num2str(colors(i,:)); %str2num should be used to get the color
        str2{i} = strcat(['<html><body bgcolor="' color '" font color="' color '" text="' str_tmp '" width="80px">'], color);
    end
    act = num2cell(true(p,1));
    t = [str1,str2,act];
    set(handles.dataset_feats,'Data',t);    
    
    %% Resulta
    dat = get(handles.run_clustering,'UserData');
    if isempty(dat)
        set(handles.results_pop,'Enable','off');
    else
        set(handles.results_pop,'Enable','on');
    end
end

