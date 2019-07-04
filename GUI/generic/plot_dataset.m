function plot_dataset(x,y,plot_data,plotDim1,plotDim2,plotDim3,generate_new_figure,method_norm,plot_centroids)
%PLOT_DATASET plots the dataset

    marker_size = 13;
    marker_size_centers = 20;
    markData = 'filled';
    markCenters = 'filled';
    markClusterCenters = 'hexagram';
    
    centers = [];
    cluster_centers = [];
    
    if nargin > 7
        mnx = get(method_norm,'String');
        i = get(method_norm,'Value');    
        num = str2double(mnx(i,:));
        if isnan(num)
            x = normalizations(x,mnx{i});
        else
            % Plot the initial centers
            centers = get(method_norm,'UserData');
        end
    end
    if  nargin > 8
        % Plot the final centers
        cluster_centers = plot_centroids;
    end

    dim1 = get(plotDim1,'String');
    i = get(plotDim1,'Value');
    dim1 = str2double(dim1(i,:));
    
    dim2 = get(plotDim2,'String');
    i = get(plotDim2,'Value');
    dim2 = str2double(dim2(i,:));

    dim3 = get(plotDim3,'String');
    i = get(plotDim3,'Value');
    dim3 = str2double(dim3(i,:));
    
    K = unique(y);
    colors = color_fullhue(length(K));
    cla(plot_data,'reset');
    hold(plot_data,'on');

    if dim2 == 0 && dim3 == 0
        %scatter 1D
        for i = 1:length(K)
        	scatter(ones(1,length(x(y==K(i)))),x(y==K(i),dim1),marker_size,markData,'MarkerFaceColor',colors(i,:),'parent',plot_data);
        end  
        if ~isempty(centers)
            scatter(ones(1,length(centers)),centers(:,dim1),marker_size_centers,markCenters,'MarkerFaceColor','black','parent',plot_data);
        end
        if ~isempty(cluster_centers)
            scatter(ones(1,length(cluster_centers)),cluster_centers(:,dim1),marker_size_centers,markClusterCenters,'MarkerFaceColor','black','MarkerEdgeColor','black','parent',plot_data);
        end
    elseif dim3 == 0
        %scatter 2D
        for i = 1:length(K)
        	scatter(x(y==K(i),dim1),x(y==K(i),dim2),marker_size,markData,'MarkerFaceColor',colors(i,:),'parent',plot_data);
        end  
        if ~isempty(centers)
            scatter(centers(:,dim1),centers(:,dim2),marker_size_centers,markCenters,'MarkerFaceColor','black','parent',plot_data);
        end 
        if ~isempty(cluster_centers)
            scatter(cluster_centers(:,dim1),cluster_centers(:,dim2),marker_size_centers,markClusterCenters,'MarkerFaceColor','black','MarkerEdgeColor','black','parent',plot_data);
        end        
    else
        %scatter3
        for i = 1:length(K)
        	scatter3(x(y==K(i),dim1),x(y==K(i),dim2),x(y==K(i),dim3),marker_size,markData,'MarkerFaceColor',colors(i,:),'parent',plot_data);
        end    
        if ~isempty(centers)
            scatter3(centers(:,dim1),centers(:,dim2),centers(:,dim3),marker_size_centers,markCenters,'MarkerFaceColor','black','parent',plot_data);
        end    
        if ~isempty(cluster_centers)
            scatter3(cluster_centers(:,dim1),cluster_centers(:,dim2),cluster_centers(:,dim3),marker_size_centers,markClusterCenters,'MarkerFaceColor','black','MarkerEdgeColor','black','parent',plot_data);
        end          
    end
    hold(plot_data,'off');
    %axis(handles.plot_dataset,'off');
    
    
    %% Generate another figure if requested
    genf = get(generate_new_figure,'Value');
    if genf
        f = findobj('type','figure','name','Dataset','tag','figure1');
        if ~isempty(f)
            close(f);
        end
        f = figure('name','Dataset','tag','figure1');
        axes(f);
        faxis = findobj(f,'Type','Axes');
        cla(faxis,'reset');
        hold(faxis,'on');
        marker_size = 12;
        if dim2 == 0 && dim3 == 0
            %scatter 1D
            for i = 1:length(K)
                scatter(ones(1,length(x(y==K(i)))),x(y==K(i),dim1),marker_size,'filled','MarkerFaceColor',colors(i,:),'parent',faxis);
            end  
            if ~isempty(centers)
                scatter(ones(1,length(centers)),centers(:,dim1),marker_size_centers,'filled','MarkerFaceColor','black','parent',faxis);
            end            
        elseif dim3 == 0
            %scatter 2D
            for i = 1:length(K)
                scatter(x(y==K(i),dim1),x(y==K(i),dim2),marker_size,'filled','MarkerFaceColor',colors(i,:),'parent',faxis);
            end  
            if ~isempty(centers)
                scatter(centers(:,dim1),centers(:,dim2),marker_size_centers,'filled','MarkerFaceColor','black','parent',faxis);
            end              
        else
            %scatter3
            for i = 1:length(K)
                scatter3(x(y==K(i),dim1),x(y==K(i),dim2),x(y==K(i),dim3),marker_size,'filled','MarkerFaceColor',colors(i,:),'parent',faxis);
            end     
            if ~isempty(centers)
                scatter3(centers(:,dim1),centers(:,dim2),centers(:,dim3),marker_size_centers,'filled','MarkerFaceColor','black','parent',faxis);
            end              
        end
        hold(faxis,'off');    
    end        

end

