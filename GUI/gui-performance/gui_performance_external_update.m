function gui_performance_external_update(handles)
%Update the gui_performance_external based on user's selections

    dat = get(handles.refresh_plots,'UserData');
    CL_RESULTS = dat{1};
    DATA = dat{2};
    PARAMS = dat{3};
    EXTRAS = dat{4}; %MST and LOF
    ORIGINAL_DATA = dat{5};
    indexes = get(handles.gui_performance_external,'UserData');
    
    Ks = PARAMS.k;
    Ss = PARAMS.s;
    nSs = length(Ss);
    
    % Plot options
    LineWidth = 1.5;
    MarkerSize = 5;
    MarkerEdgeColor = [0,0,0];
    FontSize = 11;
    FontWeight = 'bold';
    
    % Collect data based on user selections
    id = get(handles.active_indexExt,'Data'); 
    pl_i = find(cell2mat(id(:,3))==1);
    StructFields = fieldnames(indexes);
    vals = nan(length(pl_i),nSs);
    for i1 = 1:length(pl_i)
        sf = StructFields{pl_i(i1)};
        for i2 = 1:nSs
            vals(i1,i2) = getfield(indexes(i2),sf);
        end
    end    

    % Plot performance indexes
    cla(handles.plot_performance_ext,'reset');
    hold(handles.plot_performance_ext,'on');
    if nSs > 1
        % Plot lines
        for i1 = 1:length(pl_i)
            % Get the color of the index
            c = strfind(id{pl_i(i1),2},'"');
            color = str2num(id{pl_i(i1),2}(c(5)+1:c(6)-1));
            % Plot the index
            plot(Ss,vals(i1,:),'-o','Color',color,'LineWidth',LineWidth,...
                'MarkerSize',MarkerSize,'MarkerFaceColor',color,'MarkerEdgeColor',MarkerEdgeColor,...
                'parent',handles.plot_performance_ext);          
        end
        xlabel('Sparsity','parent',handles.plot_performance_ext);
    else
        % Plot bars
        for i1 = 1:length(pl_i)
            % Get the color of the index
            c = strfind(id{pl_i(i1),2},'"');
            color = str2num(id{pl_i(i1),2}(c(5)+1:c(6)-1));
            % Plot the index
            bar(i1,vals(i1),0.1,'FaceColor',color,'EdgeColor',MarkerEdgeColor,'parent',handles.plot_performance_ext);      
        end   
        xlabel('Sparsity','parent',handles.plot_performance_ext);
        tmp = get(handles.plot_performance_ext,'XTickLabel');
        for t = 1:length(tmp)
            tmp{t} = '';
        end
        mid = round(length(tmp)/2);
        tmp{mid} = Ss;
        set(handles.plot_performance_ext,'XTickLabel',tmp);
    end
    ylabel('Ext Index Value','parent',handles.plot_performance_ext);
    set(handles.plot_performance_ext,'FontSize',FontSize,'FontWeight',FontWeight);
    hold(handles.plot_performance_ext,'off');      
end
