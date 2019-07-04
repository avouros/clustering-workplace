function NewF = customBarplot(myData,varargin)
%CUSTOMBARPLOT 

    %% DEFAULT OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generic
    maximize_figure = 0; %flag; if 1 the generated figure is maximized
    overall_figure = 1;  %flag; if 1 figure is squared 
    visibility = 'on';   %make the figure visible
    stats = 'mean';
    
    % Labels 
    Xlabel = ''; %x-axis label
    Ylabel = ''; %y-axis label
    Title = '';  %figure title
    tickxl = ''; %x-tick labels
   
    % Fonts format
    FontSize_ticks = 13;  
    FontSize_labels = 14;
    FontSize_title = 15;
    FontWeight_ticks = 'bold';
    FontWeight_labels = 'bold';
    FontWeight_title = 'bold';
    FontName = 'Arial';    
      
    % Bar's aspects
    width_bar = 0.15;      %width of the bar; cell matrix can be given
    color_bar = 'cyan';    %color of the bar; cell matrix can be given
    width_line = 0.15;     %width of the outline; cell matrix can be given
    color_line = 'black';  %color of the outline; cell matrix can be given
    
    % Errorbars' aspects
    symbol_errorbars = 'o';    %symbol of the errorbars
    size_errorbars = 18;       %size of the errorbars
    width_errorbars = 1.5;     %width of the errorbars
    color_errorbars = 'black'; %color of the errorbars
    
    % Figure's aesthetics
    inGroupGap = 0.2;   %gap between each box of the same group
    outGroupGap = 0.5;  %gap between boxes of different groups
    extra_right = 0.2;  %gap before first box
    extra_left = 0.2;   %gap after last box
    extra_up = 10;      %gap between max value and top of the axes
    extra_down = 10;    %gap between min value and bottom of the axes
    YFixed = [];        %fixed y-axis bounds
    
    
    %% CUSTOM OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(varargin)
        % Generic
        if isequal(varargin{i},'maximize_figure')
            maximize_figure = varargin{i+1};
        elseif isequal(varargin{i},'overall_figure')
            overall_figure = varargin{i+1};
        elseif isequal(varargin{i},'visibility')
            visibility = varargin{i+1};
        % Labels    
        elseif isequal(varargin{i},'Xlabel')
            Xlabel = varargin{i+1};
        elseif isequal(varargin{i},'Ylabel')
            Ylabel = varargin{i+1};
        elseif isequal(varargin{i},'Title')
            Title = varargin{i+1};
        elseif isequal(varargin{i},'tickxl')
            tickxl = varargin{i+1};            
        % Fonts format
        elseif isequal(varargin{i},'FontSize_ticks')
            FontSize_ticks = varargin{i+1};
        elseif isequal(varargin{i},'FontSize_labels')
            FontSize_labels = varargin{i+1};
        elseif isequal(varargin{i},'FontSize_title')
            FontSize_title = varargin{i+1};
        elseif isequal(varargin{i},'FontWeight_ticks')
            FontWeight_ticks = varargin{i+1}; 
        elseif isequal(varargin{i},'FontWeight_labels')
            FontWeight_labels = varargin{i+1};
        elseif isequal(varargin{i},'FontWeight_title')
            FontWeight_title = varargin{i+1};
        elseif isequal(varargin{i},'FontName')
            FontName = varargin{i+1};             
        % Bar's aspects
        elseif isequal(varargin{i},'width_bar')
            width_bar = varargin{i+1}; 
        elseif isequal(varargin{i},'color_bar')
            color_bar = varargin{i+1};
        elseif isequal(varargin{i},'width_line')
            width_line = varargin{i+1};
        elseif isequal(varargin{i},'color_line')
            color_line = varargin{i+1};  
        % Errorbars' aspects
        elseif isequal(varargin{i},'symbol_errorbars')
            symbol_errorbars = varargin{i+1}; 
        elseif isequal(varargin{i},'size_errorbars')
            size_errorbars = varargin{i+1};
        elseif isequal(varargin{i},'width_errorbars')
            width_errorbars = varargin{i+1};
        elseif isequal(varargin{i},'color_errorbars')
            color_errorbars = varargin{i+1};                
        % Figure's aesthetics
        elseif isequal(varargin{i},'inGroupGap')
            inGroupGap = varargin{i+1};
        elseif isequal(varargin{i},'outGroupGap')
            outGroupGap = varargin{i+1};
        elseif isequal(varargin{i},'extra_right')
            extra_right = varargin{i+1};         
        elseif isequal(varargin{i},'extra_left')
            extra_left = varargin{i+1};         
        elseif isequal(varargin{i},'extra_up')
            extra_up = varargin{i+1};         
        elseif isequal(varargin{i},'extra_down')
            extra_down = varargin{i+1};         
        elseif isequal(varargin{i},'YFixed')
            YFixed = sort(varargin{i+1});
        end
    end
    

    %% Calculate the positions of the bars
    n = length(myData); %number of groups
    flag = 0;           %indicates when we change group
    pos = 0;            %position of each bar
    grs = zeros(1,n);   %number of groups
    for i = 1:n
        datagroup = myData{i};
        s1 = size(datagroup,2);
        for j = 1:s1
            if flag == 0
                %Same group
                pos = [pos,pos(end)+inGroupGap];
                grs(i) = grs(i)+1;
            else
                %Other group
                pos = [pos,pos(end)+outGroupGap];         
                grs(i) = grs(i)+1;
                flag = 0;
            end
        end
        flag = 1;
    end
    % Remove the first position and shift left by inGroupGap
    pos(1) = [];
    pos = pos-inGroupGap;
    % Add extra right
    pos = pos+extra_right;    

    
    %% Make the figure
    z = length(pos);
    if ~maximize_figure
        NewF = figure('Visible',visibility,'tag','NewF');
    else
        NewF = figure('Visible',visibility,'units','normalized','outerposition',[0 0 1 1],'tag','NewF');
    end 
    faxis = axes(NewF);
    hold(faxis,'on');
    xlim(faxis,[0 pos(end)+extra_left]);
    % Plot the bars one by one
    posi = 1;
    maxv = -inf;
    minv = +inf;
    for i = 1:n
        datagroup = myData{i};
        s1 = size(datagroup,2);
        for j = 1:s1
            if iscell(datagroup)
                data = datagroup{j};
            else
                data = datagroup(:,j);
            end
            %Find max and min
            if max(data) > maxv
                maxv = max(data);
            end
            if min(data) < minv
                minv = min(data);
            end    
            %See if we require errorbars
            mind = [];
            maxd = [];
            if size(data,1) > 1
                mind = min(data);
                maxd = max(data);
                switch stats
                    case 'mean'
                        data = mean(data);
                    case 'std'
                        data = std(data);
                    case 'cov'
                        tmp = std(data)./mean(data);
                        data = tmp;
                    case 'mad'
                        tmp = mean(abs(data-repmat(mean(data),size(data,1),1)));
                        data = tmp;                        
                    case 'var'
                        data = var(data);
                    case 'median'
                        data = median(data);                        
                    case 'iqr'
                        data = iqr(data);
                    case 'covr'
                        tmp = iqr(data)./median(data);
                        data = tmp;
                    case 'madr'
                        tmp = median(abs(data-repmat(median(data),size(data,1),1)));
                        data = tmp; 
                end
            end
            
            % Plot the bar
            b = bar(pos(posi),data,width_bar,'parent',faxis);
            
            % Bar FaceColor
            if ~iscell(color_bar)
                %All bars the same color
                set(b,'FaceColor', color_bar);
            else
                if length(color_bar) == grs
                    %Every group bars with different color
                    set(b,'FaceColor', color_bar{i});
                elseif length(color_bar) == z
                    %Each bar with different color
                    set(b,'FaceColor', color_bar{posi});             
                end
            end       
            
            % Bar EdgeColor
            if ~iscell(color_line)
                %All bars the same color
                set(b,'EdgeColor', color_line);
            else
                if length(color_line) == grs
                    %Every group bars with different color
                    set(b,'EdgeColor', color_line{i});
                elseif length(color_line) == z
                    %Each bar with different color
                    set(b,'EdgeColor', color_line{posi});             
                end
            end  
            
            % Bar outline width
            if ~iscell(width_line)
                %All bars the same color
                set(b,'LineWidth', width_line);
            else
                if length(width_line) == grs
                    %Every group bars with different color
                    set(b,'LineWidth', width_line{i});
                elseif length(width_line) == z
                    %Each bar with different color
                    set(b,'LineWidth', width_line{posi});             
                end
            end              
            
            % Plot the errorbars if needed
            if ~isempty(mind) && ~isempty(maxd)
                scatter(pos(posi),data,size_errorbars,symbol_errorbars,'MarkerEdgeColor',color_errorbars,'MarkerFaceColor',color_errorbars,'parent',faxis);              
                %upper
                plot([pos(posi),pos(posi)],[data,maxd],'Color',color_errorbars,'LineWidth',width_errorbars);
                plot([pos(posi)-width_bar/2,pos(posi)+width_bar/2],[maxd,maxd],'Color',color_errorbars,'LineWidth',width_errorbars);
                %lower
                plot([pos(posi),pos(posi)],[data,mind],'Color',color_errorbars,'LineWidth',width_errorbars);
                plot([pos(posi)-width_bar/2,pos(posi)+width_bar/2],[mind,mind],'Color',color_errorbars,'LineWidth',width_errorbars);                
            end
            posi = posi+1;
        end
    end
    
    % y-axes limits
    if minv == 0
        minv = -0.5;
    end
    if maxv == 0
        maxv = 0.5;
    end
    if length(YFixed) ~= 2
        set(faxis,'YLim',[ minv-abs(((extra_down/100)*minv)) , maxv+abs(((extra_up/100)*maxv)) ]);     
    else
        set(faxis,'YLim',[YFixed(1) , YFixed(2)]);
    end
        
    % Axes labels and title
    xlabel(Xlabel,'FontName',FontName,'FontSize',FontSize_labels,'FontWeight',FontWeight_labels);
    ylabel(Ylabel,'FontName',FontName,'FontSize',FontSize_labels,'FontWeight',FontWeight_labels);
    title(Title,'FontName',FontName,'FontSize',FontSize_title,'FontWeight',FontWeight_title); 
    
    % Axis XTicks and XTickLabels
    posi1 = 1;
    p = pos(cumsum(grs));
    tickx = zeros(1,n);
    for i = 1:n
        j = find(pos==p(i));
        tickx(i) = mean(pos(posi1:j));
        posi1 = j+1;
    end
    if isempty(tickxl)
        tickxl = num2str(([1:n])');
    end
    set(faxis,'XTick',tickx,'XTickLabel',tickxl,...
        'FontSize',FontSize_ticks,'FontName',FontName,'FontWeight',FontWeight_ticks);    
    
    % Overall
    if overall_figure
        set(NewF,'Color','w','papersize',[8,8], 'paperposition',[0,0,8,8]);    
    end
    box(faxis,'off');   
    hold(faxis,'off');
end

