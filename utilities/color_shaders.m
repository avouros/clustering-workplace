function colors = color_shaders(hue,ncolors,option)
%COLOR_SHADERS generates color triplets (colormaps) using different 
%brightnesses of a selected hue. 
%Refer to http://colorizer.org/, which provides the hue (in degrees) of 
%every color.

% - hue:     Integer. Angle (in degrees) of a color
% - ncolors: Integer. Number of colors to be generated
% - option:  String. Specifies the brightness/saturation of the colors.
%            'light' starts from the 'hue' color until it is fully white.
%            'dark' starts from the 'hue' color until it is fully black. 
%            'both' generates colors so that 'hue' is in the middle, white
%                   in upper edge and black in the lower edge (default).
%            

%Extra info:
%Hue (h)       : Changes the color angle in the color wheel
%Saturation (s): Changes the brightness until white (Saturation = 0)
%Value (v):    : Changes the brightness until black (Value = 0)

% Author:
% Avgoustinos Vouros
% avouros1@sheffield.ac.uk


    if nargin < 3
        option = 'both';
    end
    [nn,mm] = size(hue);
    if nn~=1 || mm~=1
        error('Hue needs to be a scalar between [0 360]');
    end        
    if hue < 0 || hue > 360
        error('Hue needs to be a scalar between [0 360]');
    end

    % Convert 'hue' from degrees to [0-1]
    hue = hue/360;

    switch option
        case 'dark'
            % Reduce Value from 1 to 0, keep Saturation to 1
            vec = linspace(1,0,ncolors);
            colors = [hue*ones(ncolors,1),ones(ncolors,1),vec'];
            
        case 'light'
            % Reduce Saturation from 1 to 0 keep Value to 1
            vec = linspace(1,0,ncolors);
            colors = [hue*ones(ncolors,1),vec',ones(ncolors,1)];  
            
        otherwise %('both')
            ncolors_ = round(ncolors / 2);
            vec = linspace(1,0,ncolors_);
            d = [hue*ones(ncolors_,1),ones(ncolors_,1),vec'];
            if mod(ncolors,2) == 1 %odd
                l = [hue*ones(ncolors_,1),vec',ones(ncolors_,1)];   
            else
                % Just generate one more dark color
                ncolors_ = ncolors_ + 1;
                vec = linspace(1,0,ncolors_);
                l = [hue*ones(ncolors_,1),vec',ones(ncolors_,1)];   
            end
            colors = [flipud(l);d(2:end,:)];
    end
    
    % Convert to rgb
    colors = hsv2rgb(colors);
end