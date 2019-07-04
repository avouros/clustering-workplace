function [f,hStrings] = imagesc_adv(mymatrix, varargin)
%IMAGESC_ADV displays matrix as image with scaled colors and values in each
%box

%INPUT:
%mymatrix : double matrix, it can also be a vector.

%OUTPUT:
%f        : figure handle
%hStrings : text handle

%VARARGIN:
% - Default options:
%    colormap = inverse gray
%    numbers format = %0.2f
% - Custom options 
%   Except from the first the rest are Name-Value Pair Arguments
%    'DISPLAYOFF' : turns figure display off
%    'CMAP'       : colormap
%    'XTICKLABEL' : x-axis tick labels 
%    'YTICKLABEL' : y-axis tick labels 
%    'FORMAT'     : numbers format


% Author: Avgoustinos Vouros

% Thanks to: gnovice @stackoverflow.com
% https://bit.ly/2OOPwlx


    % Default values
    XTick = 1:size(mymatrix,2);
    YTick = 1:size(mymatrix,1);
    XTickLabel_ = num2str(XTick');
    YTickLabel_ = num2str(YTick');
    format = '%0.2f';
    
    % Generate the figure
    f = figure;
    hold on
    faxis = findobj(f,'Type','axes');
    imagesc(mymatrix,'parent',faxis); 
    colormap(flipud(gray));
    
    % Custom values
    for i = 1:length(varargin)
        if isequal(varargin{i},'CMAP')
            caxis(varargin{i+1});
        elseif isequal(varargin{i},'DISPLAYOFF')
            set(f,'Visible','off');
        elseif isequal(varargin{i},'XTICKLABEL')
            XTickLabel_ = varargin{i+1};
        elseif isequal(varargin{i},'YTICKLABEL')
            YTickLabel_ = varargin{i+1};
        elseif isequal(varargin{i},'FORMAT')
            format = varargin{i+1};
        end
    end

    %% MAIN
    
    %Create strings from the matrix values
    textStrings = num2str(mymatrix(:),format);  
    %Remove any space padding
    textStrings = strtrim(cellstr(textStrings));  
    %Create x and y coordinates for the strings
    [x,y] = meshgrid(1:length(XTick),1:length(YTick));   
    %Plot the strings
    hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
    %Get the middle value of the color range
    midValue = mean(get(gca,'CLim'));
    %Choose white or black for the
    %text color of the strings so
    %they can be easily seen over
    %the background color
    textColors = repmat(mymatrix(:) > midValue,1,3); 
    %Change the text colors
    set(hStrings,{'Color'},num2cell(textColors,2));  
    %Change the axes tick marks and tick labels
    set(faxis,'XTick',XTick,'XTickLabel',XTickLabel_,... 
            'YTick',YTick,'YTickLabel',YTickLabel_,...
            'TickLength',[0 0]);
end

