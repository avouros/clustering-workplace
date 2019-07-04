function [x,y,lb1,lb_out,str] = load_dataset(varargin)
%LOAD_DATASET loads a dataset
% x     : the dataser
% y     : the cluster/label of each element of the dataset
% lb1   : the cluster/label of each element of the dataset (special)
% lb_out: the cluster/label of each element of the dataset (special)

    x=[];
    y=[];
    lb1=[];
    lb_out=[];
    str=[];  
            
    if isempty(varargin)
        [dfile,dpath] = uigetfile({'*.mat'},'File Selector');
        if isequal(dfile,0)      
            return
        else
            load(fullfile(dpath,dfile));
        end
    else
        switch varargin{1}{1}
            case 'Clustering basic benchmark'
                fn = fullfile(pwd,'datasets','Clustering basic benchmark');
                set = varargin{1}{2};
                number = varargin{1}{3};
                [y,x,~] = load_clustering_basic_dataset(fn,set,number);
                lb1 = y;
                lb_out = y;                
                str = [length(unique(y)),NaN];
                return
            case 'Yan and Ye'
                model = varargin{1}{2};
                if isempty(model)
                    return
                end
                [x,y] = YanYe_data(model,0);
                lb1 = y;
                lb_out = y;                
                str = [length(unique(y)),NaN];     
                return
            case 'Gap'
                model = varargin{1}{2};
                if isempty(model)
                    return
                end
                [x,y] = Gap_data(model,0);
                lb1 = y;
                lb_out = y;                
                str = [length(unique(y)),NaN];     
                return                
            otherwise
                error('Unknown load command');
        end
    end

    if isempty(y)
        y = x_labs;
        lb1 = y;
        lb_out = y;
        str = [NaN,length(unique(y))];
    else
        str = [length(unique(y)),NaN];
    end
       
end

