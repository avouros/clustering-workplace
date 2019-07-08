function gui_performance_internal_update(handles)
%Update the gui_performance_internal based on user's selections

    dat = get(handles.refresh_plots,'UserData');
    CL_RESULTS = dat{1};
    DATA = dat{2};
    PARAMS = dat{3};
    EXTRAS = dat{4}; %MST and LOF
    ORIGINAL_DATA = dat{5};
    indexes = get(handles.gui_performance_internal,'UserData');
       
    [n,p] = size(DATA);
    
    Ks = PARAMS.k;
    Ss = PARAMS.s;
    nKs = length(Ks);
    nSs = length(Ss);
    
    str = fieldnames(indexes);
    nfields = size(str,1);
    
    feats_t = PARAMS.UI{1};
    nf = length(find(cell2mat(feats_t(:,3))==1));

    % Plot options
    LineWidth = 1.5;
    MarkerSize = 5;
    MarkerEdgeColor = [0,0,0];
    FontSize = 11;
    FontWeight = 'bold';
    
    % Collect data based on user selections
    DARKER = handles.darker_colors.Value;    
    kd = get(handles.active_k,'Data');
    id = get(handles.active_index,'Data');
    wd = get(handles.active_w,'Data');
    pl_k = find(cell2mat(kd(:,3))==1);
    pl_i = find(cell2mat(id(:,3))==1);
    pl_w = find(cell2mat(wd(:,3))==1);  
    % Collect all data
    wdata = nan(nKs,nSs,nf);
    for z = 1:nf          %z: features weights
        for i = 1:nKs     
            for j = 1:nSs %y: s values
                wdata(i,j,z) = CL_RESULTS(i,j).w(z);
            end
        end
    end         
    idata = nan(nKs,nSs,nfields);
    for i = 1:nKs      %x: k values
        for j = 1:nSs  %y: s values, %z: Indexes
            idata(i,j,:) = cell2mat(struct2cell(indexes(i,j)));
        end
    end    
    % Keep only the ones we need
    iplot = idata(pl_k,:,pl_i);
    wplot = wdata(pl_k,:,pl_w);
    
    % Plot performance indexes
    [x,y,z] = size(iplot);
    cla(handles.plot_performance,'reset');
    hold(handles.plot_performance,'on');    
    if y > 1 
        %Plot lines (indexes per s)
        for i1 = 1:x
            for i2 = 1:z
                %Get the color of the index
                c = strfind(id{pl_i(i2),2},'"');
                color = str2num(id{pl_i(i2),2}(c(5)+1:c(6)-1));
                if DARKER
                    color = color_shadersRGB(color,x);
                    color = color(i1,:);
                end
                %Plot the index
                plot(Ss,iplot(i1,:,i2),'-o','Color',color,'LineWidth',LineWidth,...
                    'MarkerSize',MarkerSize,'MarkerFaceColor',color,'MarkerEdgeColor',MarkerEdgeColor,...
                    'parent',handles.plot_performance);
                xlabel('Sparsity','parent',handles.plot_performance);
            end
        end
    else    
        %Plot bars. Here we need to compute the positions
        strs = nan(x,1);
        bp = nan(x,z);
        bpcell = cell(x,1);
        for i1 = 1:x
            for i2 = 1:z
                bp(i1,i2) = iplot(i1,1,i2);
            end
            bpcell{i1} = bp(i1,:);
        end
        if x > 0 && z > 0
            [pos,mid] = bar_positions(bpcell);
            pi = 1;
            for i1 = 1:x
                for i2 = 1:z
                    % Get the color of the index
                    c = strfind(id{pl_i(i2),2},'"');
                    color = str2num(id{pl_i(i2),2}(c(5)+1:c(6)-1));
                    if DARKER
                        color = color_shadersRGB(color,x);
                        color = color(i1,:);
                    end
                    % Plot the index
                    bar(pos(pi),iplot(i1,1,i2),0.1,'FaceColor',color,'EdgeColor',MarkerEdgeColor,'parent',handles.plot_performance);
                    xlabel('K','parent',handles.plot_performance);
                    strs(i1,1) = kd{pl_k(i1),1};
                    pi = pi+1;
                end
            end   
            set(handles.plot_performance,'XTick',mid);
            set(handles.plot_performance,'XTickLabel',num2str((1:x)'));
        end
    end    
    ylabel('Index Value','parent',handles.plot_performance);
    set(handles.plot_performance,'FontSize',FontSize,'FontWeight',FontWeight);
    hold(handles.plot_performance,'off');
    
    % Plot weights
    [x,y,z] = size(wplot);
    cla(handles.plot_weights,'reset');
    hold(handles.plot_weights,'on');
    if y > 1
        for i1 = 1:x
            for i2 = 1:z
                % Get the color of the index
                c = strfind(wd{pl_w(i2),2},'"');
                color = str2num(wd{pl_w(i2),2}(c(5)+1:c(6)-1));
                if DARKER
                    color = color_shadersRGB(color,x);
                    color = color(i1,:);
                end
                % Plot the index
                plot(Ss,wplot(i1,:,i2),'-o','Color',color,'LineWidth',LineWidth,...
                    'MarkerSize',MarkerSize,'MarkerFaceColor',color,'MarkerEdgeColor',MarkerEdgeColor,...
                    'parent',handles.plot_weights);
                xlabel('Sparsity','parent',handles.plot_weights);
            end
        end
    else
        % Plot bars. Here we need to compute the positions
        strs = nan(x,1);
        bp = nan(x,z);
        bpcell = cell(x,1);
        for i1 = 1:x
            for i2 = 1:z
                bp(i1,i2) = wplot(i1,1,i2);
            end
            bpcell{i1} = bp(i1,:);
        end
        if x > 0 && z > 0
            [pos,mid] = bar_positions(bpcell);
            pi = 1;
            for i1 = 1:x
                for i2 = 1:z
                    % Get the color of the index
                    c = strfind(wd{pl_w(i2),2},'"');
                    color = str2num(wd{pl_w(i2),2}(c(5)+1:c(6)-1));
                    if DARKER
                        color = color_shadersRGB(color,x);
                        color = color(i1,:);
                    end
                    % Plot the index
                    bar(pos(pi),wplot(i1,1,i2),0.1,'FaceColor',color,'EdgeColor',MarkerEdgeColor,'parent',handles.plot_weights);
                    xlabel('K','parent',handles.plot_weights);
                    strs(i1,1) = kd{pl_k(i1),1};
                    pi = pi+1;
                end
            end   
            set(handles.plot_weights,'XTick',mid);
            set(handles.plot_weights,'XTickLabel',num2str((1:x)'));  
        end
    end
    ylabel('Weight Value','parent',handles.plot_weights);
    set(handles.plot_weights,'FontSize',FontSize,'FontWeight',FontWeight);    
    hold(handles.plot_weights,'off');    
end    
