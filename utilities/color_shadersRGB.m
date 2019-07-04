function colors = color_shadersRGB(RGB,n,option)
%COLOR_SHADERSRGB generates color triplets (colormaps) using different 
%brightnesses of an RGB color triplet. 

% RGB:    An rgb triplet e.g. [1,0,0]
% n:      Number of shades
% Option: 'darker' or 'lighter'

% Author:
% Avgoustinos Vouros
% avouros1@sheffield.ac.uk

    
    % Default
    if nargin < 3
        option = 'darker';
    end
    
    % Check input
    [nn,m] = size(RGB);
    if nn~=1 || m~=3
        error('Input needs to be a 1x3 vector specifying an RGB color.');
    end
    
    switch option
        case 'darker'
            colors = rgb2hsv(RGB);
            values = linspace(0.5,1,n);
            colors = [colors(1,1).*ones(n,1),colors(1,2).*ones(n,1),values'];
            colors = hsv2rgb(colors);
            colors = flipud(colors);
        case 'lighter'
            colors = rgb2hsv(RGB);
            values = linspace(0.5,1,n);
            colors = [colors(1,1).*ones(n,1),values',colors(1,2).*ones(n,1)];
            colors = hsv2rgb(colors);
            colors = flipud(colors);   
        otherwise
            error('Wrong option.');
    end
end

