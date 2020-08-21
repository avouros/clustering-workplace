function [x,y,lb1,lb_out,str] = load_dataset(data_name_selector)
%LOAD_DATASET loads a dataset
% x     : the dataset
% y     : the cluster/label of each element of the dataset
% lb1   : the cluster/label of each element of the dataset (special)
% lb_out: the cluster/label of each element of the dataset (special)

    x=[];
    y=[];
    lb1=[];    %unused for now
    lb_out=[]; %unused for now
    str=[];  
    
    % Open GUI to select data set
    switch data_name_selector
        case 'Load Dataset'
            %Open file selector
            [dfile,dpath] = uigetfile({'*.mat'},'File Selector');
            if isequal(dfile,0)      
                return
            else
                load(fullfile(dpath,dfile));
                if ~exist('y','var')
                    %Real world or custom data set
                    y = x_labs;
                    lb1 = y;
                    lb_out = y;
                    str = [NaN,length(unique(y))];
                else
                    %Brodinova data set
                    str = [length(unique(y)),NaN];
                end
                return
            end
        case 'Clustering basic benchmark'
            list = {'A-sets 1','A-sets 2','A-sets 3',...
                'S-sets 1','S-sets 2','S-sets 3','S-sets 4'};
        case 'Yan and Ye'
            list = {'Model 1','Model 2','Model 3','Model 4','Model 5','Model 6'};
        case 'Gap'
            list = {'Model 1','Model 2','Model 3','Model 4','Model 5'};
        case 'Mixed'
            list = {'Model 1','Model 2','Model 3','Model 4'};
        otherwise
            error('Unknown dataset option');
    end
    index = listdlg('ListString',list,'SelectionMode','single');
    
    % Load the selected dataset
    if isempty(index)
        return
    else
        name = strsplit(list{index},' ');
        set = name{1};
        number = str2double(name{2});
        switch data_name_selector
            case 'Clustering basic benchmark'
                fn = fullfile(pwd,'datasets','cbb');
                [y,x,~] = load_clustering_basic_dataset(fn,set,number);
            case 'Yan and Ye'
                [x,y] = YanYe_data(number,0);
            case 'Gap'
                [x,y] = Gap_data(number,0);
            case 'Mixed'
                [x,y] = mixed_cluster_data(number,0);
            otherwise
                error('Cannot loaddata set');
        end
    end
            
    lb1 = y;
    lb_out = y;                
    str = [length(unique(y)),NaN];
end

