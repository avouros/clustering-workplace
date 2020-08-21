function gui_update(handles)
%GUI_UPDATE updates the GUI after a new dataset is loaded

    data = get(handles.button_load,'UserData');
    x = data{1}; %dataser
    y = data{2}; %labels
    [n,p] = size(x);
    str_p = 1:p;
    
    str_k = 1:100;           % K available values
    str_s = 1.1:0.1:sqrt(p); % S available values
    str_sk = 1:20;           % K step
    str_ss = 0.1:0.1:1;      % S step
    
   
    %% Features properties
    str_p = arrayfun(@(x)num2str(x),str_p,'Uniform',0);
    set(handles.features_values,'Enable','on');
    set(handles.hold_features_properties,'Enable','on');
    set(handles.features_values,'Items',str_p,'Value',str_p(1));
    
    %% Plot dimensions
    set(handles.generate_new_figure,'Enable','on');
    set(handles.plotDim1,'Enable','on');
    set(handles.plotDim2,'Enable','on');
    set(handles.plotDim3,'Enable','on');  
    set(handles.plotDim1,'Items',str_p,'Value',str_p(1)); 
    set(handles.plotDim2,'Items',str_p,'Value',str_p(1)); 
    set(handles.plotDim3,'Items',str_p,'Value',str_p(1));
    if p > 1
        set(handles.plotDim2,'Items',str_p,'Value',str_p(2)); 
        set(handles.plotDim3,'Items',str_p,'Value',str_p(2)); 
    else
        set(handles.plotDim2,'Items',str_p,'Value',str_p(1)); 
        set(handles.plotDim3,'Items',str_p,'Value',str_p(1)); 
    end
    if p > 2
        set(handles.plotDim3,'Items',str_p,'Value',str_p(3)); 
    end
    set(handles.generate_new_figure,'Value',0);  
    
    %% Clustering parameters
    if p == 1
        str_s = 1;
    end
    str_k = arrayfun(@(x)num2str(x),str_k,'Uniform',0);
    str_s = arrayfun(@(x)num2str(x),str_s,'Uniform',0);
    str_sk = arrayfun(@(x)num2str(x),str_sk,'Uniform',0);
    str_ss = arrayfun(@(x)num2str(x),str_ss,'Uniform',0);
    set(handles.k_start,'Items',str_k,'Value',str_k(1)); 
    set(handles.s_start,'Items',str_s,'Value',str_s(1)); 
    set(handles.k_end,'Items',str_k,'Value',str_k(1)); 
    set(handles.s_end,'Items',str_s,'Value',str_s(1)); 
    set(handles.k_step,'Items',str_sk,'Value',str_sk(1)); 
    set(handles.s_step,'Items',str_ss,'Value',str_ss(1)); 

    %% Classes/clusters info
    info = data{5};
    if isnan(info(1))
        txt1 = '-';
    else
        txt1 = num2str(info(1));
    end
    if isnan(info(2))
        txt2 = '-';
    else
        txt2 = num2str(info(2));
    end
    handles.TextArea.Value = ...
        {strcat('Points:',num2str(n)) ; strcat('Feats:',num2str(p)) ; ...
         strcat('Clusters:',txt1) ; strcat('Classes:',txt2)};
    
    %% Features table
    str1 = cell(p,1);
    str2 = cell(p,1);
    colors = color_fullhue(p);
    for i = 1:p
        str1{i} = sprintf('feature %d',i);
        %OLD MATLAB:
        %color = dec2hex(round(colors(i,:).*255));
        %color = ['#',color(1,:),color(2,:),color(3,:)];
        %str_tmp = num2str(colors(i,:)); %str2num should be used to get the color
        %str2{i} = strcat(['<html><body bgcolor="' color '" font color="' color '" text="' str_tmp '" width="80px">'], color);
        str2{i} = num2str(colors(i,:));
        sty = uistyle('BackgroundColor',colors(i,:),'FontColor',colors(i,:));
        addStyle(handles.dataset_feats,sty,'cell',[i,2]);
    end
    act = num2cell(true(p,1));
    t = [str1,str2,act];
    set(handles.dataset_feats,'Data',t);   
    set(handles.dataset_feats,'Enable','on')
    
    %% Results
    dat = get(handles.run_clustering,'UserData');
    if isempty(dat)
        set(handles.results_pop,'Enable','off');
    else
        set(handles.results_pop,'Enable','on');
    end
    
    %% Other GUI elements
    set(findall(handles.panel_clustering, '-property', 'Enable'), 'enable', 'on');
    set(handles.plotDim1,'Enable','on');
    set(handles.plotDim2,'Enable','on');
    set(handles.plotDim3,'Enable','on');
    set(handles.dataset_norm,'Enable','on');
    set(handles.save_clustering,'Enable','off');
end

