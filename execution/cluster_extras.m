function EXTRAS = cluster_extras(x)
%CLUSTER_EXTRAS computes extra measurements and stats

    % Extra stats
    %Compute Minimum Spanning Tree
    M = squareform(pdist(x));
    Mnorm = M./max(max(M)); 
    G = graph(Mnorm); %generate graph from M
    mst = minspantree(G); %generate Minimum Spanning Tree
    tmp = table2array(mst.Edges); %table to matrix
    EXTRAS.MST = tmp(:,3);
    % Compute LOF
    [EXTRAS.LOF,EXTRAS.ard,EXTRAS.density,EXTRAS.neighbors] = lof_paper(x,10);
end

