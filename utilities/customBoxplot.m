function NewF = customBoxplot(myData,varargin)

% INPUT:  
% - myData: Cell vector {1xC} or {Cx1} where each cell contains either a
%           column vector (Nx1), a matrix (NxM) or a cell column vector 
%           {Nx1}. For each column a boxplot is generated. The boxplots are
%           organized by groups where each cell of the cell vector
%           represents a group
%
% - varargin: Change default options (name-value pairs).
%             For the options that have the 'cell matrix can be given' tag, 
%             a cell matrix can be given where if the number of cells are
%             the number of generated boxplots then each boxplot will have
%             the option specified in the respective cell. Alternative,
%             each group of boxplots will have the option specified in the
%             respective cell.
%
% OUTPUT:
% - f: Figure's handle which is of class matlab.ui.Figure.

% Test datasets
% myData = {rand(10,3),rand(5,1),rand(10,4),rand(50,5)};
% myData = {rand(10,1),rand(10,2),rand(10,5),rand(10,8)};
% myData = {rand(20,4),rand(10,6),{rand(10,1),rand(20,1)},rand(10,2)};
% myData = {rand(10,1),rand(10,1),rand(10,1),rand(10,1)};
% myData = {{rand(10,1),rand(10,1),rand(200,1)},rand(10,2),rand(10,5)};

% Author:
% Avgoustinos Vouros
% avouros1@sheffield.ac.uk

    %% DEFAULT OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generic
    maximize_figure = 0; %flag; if 1 the generated figure is maximized
    overall_figure = 1;  %flag; if 1 figure is squared 
    visibility = 'on';   %make the figure visible
    
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
    
    % Figure's color aspects
    color_outlier = 'black';     %cell matrix can be given
    color_median = 'black';      %cell matrix can be given
    color_box = 'white';         %cell matrix can be given
    color_box_outline = 'black'; %cell matrix can be given
    
    % Figure's line aspects
    width_bar = 0.15;
    width_outlier = 2;
    width_median = 3;        %cell matrix can be given
    width_box_outline = 0.5; %cell matrix can be given
    width_whiskers = 2;
    
    % Figure's aesthetics
    symbol_outlier = '+'; %symbol for the outliers
    inGroupGap = 0.2;   %gap between each box of the same group
    outGroupGap = 0.5;  %gap between boxes of different groups
    extra_right = 0.2;  %gap before first box
    extra_left = 0.2;   %gap after last box
    extra_up = 10;      %gap between max value and top of the axes
    extra_down = 10;    %gap between min value and bottom of the axes
    
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
        % Figure's color aspects
        elseif isequal(varargin{i},'color_outlier')
            color_outlier = varargin{i+1}; 
        elseif isequal(varargin{i},'color_median')
            color_median = varargin{i+1};
        elseif isequal(varargin{i},'color_box')
            color_box = varargin{i+1};
        elseif isequal(varargin{i},'color_box_outline')
            color_box_outline = varargin{i+1};  
        % Figure's line aspects
        elseif isequal(varargin{i},'width_bar')
            width_bar = varargin{i+1}; 
        elseif isequal(varargin{i},'width_outlier')
            width_outlier = varargin{i+1};
        elseif isequal(varargin{i},'width_median')
            width_median = varargin{i+1};
        elseif isequal(varargin{i},'width_box_outline')
            width_box_outline = varargin{i+1};         
        elseif isequal(varargin{i},'width_whiskers')
            width_whiskers = varargin{i+1};         
        % Figure's aesthetics
        elseif isequal(varargin{i},'symbol_outlier')
            symbol_outlier = varargin{i+1}; 
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
        end
    end

    %% MAIN FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %% Calculate the positions of the bars
    n = length(myData); %number of groups
    flag = 0;           %indicates when we change group
    pos = 0;
    grs = zeros(1,n);
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
    if ~maximize_figure
        NewF = figure('Visible',visibility,'tag','NewF');
    else
        NewF = figure('Visible',visibility,'units','normalized','outerposition',[0 0 1 1],'tag','NewF');
    end 
    faxis = axes(NewF);
    hold(faxis,'on');
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
            boxplot(data,'Positions',pos(posi),'Symbol',symbol_outlier,'Width',width_bar,'parent',faxis);
            posi = posi+1;
            %boxplot resets the axis thus remake them
            hold(faxis,'on')
            xlim(faxis,[0 pos(end)+extra_left]);
        end
    end

    %% Figure aesthetics
    %faxis = findobj(f,'type','axes'); %axes
    h1 = findobj(NewF,'Tag','Box');      %boxes
    h2 = findobj(faxis, 'Tag', 'Outliers'); %outliers
    h3 = findobj(faxis, 'Tag', 'Median');   %medians
    z = length(h1);
    
    % y-axes limits
    if minv == 0
        minv = -0.5;
    end
    if maxv == 0
        maxv = 0.5;
    end
    set(faxis,'YLim',[ minv-abs(((extra_down/100)*minv)) , maxv+abs(((extra_up/100)*maxv)) ]);  
    
    % Change all the lines width (a way to chnage the whiskers width)
    set(findobj(NewF,'type','line'),'linew',width_whiskers);
    
    % Customize each part of the plot
    posi = 1;
    for i = 1:z
        %Box color. Make a patch on the location of the box and paint it
        if ~iscell(color_box)
            %All boxes the same color
            p = patch(get(h1(i),'XData'), get(h1(i),'YData'), color_box);
        else
            if length(color_box) == z
                %Each box with different color
                p = patch(get(h1(i),'XData'), get(h1(i),'YData'), color_box{i});
            elseif length(color_box) == grs
                %Every group with different color
                p = patch(get(h1(i),'XData'), get(h1(i),'YData'), color_box{posi});
            end
        end        
        % Outline color
        if ~iscell(color_box_outline)
            %All outlines the same color
            set(p,'EdgeColor', color_box_outline);
            set(h1,'Color', color_box_outline);
        else
            if length(color_box_outline) == z
                %Each bar outline with different color
                set(p,'EdgeColor', color_box_outline{i});
                set(h1,'Color', color_box_outline{i});
            elseif length(color_box_outline) == grs
                %Every group outlines with different color
                set(p,'EdgeColor', color_box_outline{posi});
                set(h1,'Color', color_box_outline{posi});                
            end
        end
        % Outline width
        if ~iscell(width_box_outline)
            %All bars the same width
            set(p,'LineWidth', width_box_outline);
            set(h1,'LineWidth', width_box_outline);
        else
            if length(width_box_outline) == z
                %Each bar with different width
                set(p,'LineWidth', width_box_outline{i});
                set(h1,'LineWidth', width_box_outline{i});
            elseif length(width_box_outline) == grs
                %Every group with different width
                set(p,'LineWidth', width_box_outline{posi});
                set(h1,'LineWidth', width_box_outline{posi});                
            end
        end   
        % Outliers color
        if ~iscell(color_outlier)
            %All outliers the same color
            set(h2(i), 'MarkerEdgeColor',color_outlier);
        else
            if length(color_outlier) == z
                %All bar outliers with different color
                set(h2(i), 'MarkerEdgeColor',color_outlier{i});
            elseif length(color_outlier) == grs
                %All group outliers with different color
                set(h2(i), 'MarkerEdgeColor',color_outlier{posi});
            end
        end
        % Outliers width
        if ~iscell(width_outlier)
            %All outliers the same width
            set(h2(i), 'LineWidth',width_outlier);
        else
            if length(width_outlier) == z
                %All bar outliers with different width
                set(h2(i), 'LineWidth',width_outlier{i});
            elseif length(width_outlier) == grs
                %All group outliers with different width
                set(h2(i), 'LineWidth',width_outlier{posi});
            end
        end        
        % Median. Make a line on the location of the median
        l = line('XData',get(h3(i),'XData'), 'YData',get(h3(i),'YData'));
        % Median color
        if ~iscell(color_median)
            %All medians the same color
            set(l, 'Color',color_median);
        else
            if length(color_median) == z
                %All medians with different color
                set(l, 'Color',color_median{i});
            elseif length(color_median) == grs
                %All group medians with different color
                set(l, 'Color',color_median{posi});
            end
        end      
        % Median width
        if ~iscell(width_median)
            %All medians the same width
            set(l, 'LineWidth',width_median);
        else
            if length(width_median) == z
                %All medians with different width
                set(l, 'LineWidth',width_median{i});
            elseif length(width_median) == grs
                %All group medians with different width
                set(l, 'LineWidth',width_median{posi});
            end
        end        
        
        % Update the counter (used only for the group colors and widths)
        if posi == n
            posi = posi+1;
        end
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