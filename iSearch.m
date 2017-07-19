function path = iSearch(igraph,idxStart)
%%  Implemets the graph search algorithm over an information graph
pq = priorityPrepare();
pq = priorityPush(pq, idxStart, 0);
used = zeros(1,numel(igraph));
used_idx = 0;
igraph(idxStart).g = 0;
tic
while ~isempty(pq)
    used_idx = used_idx+1;
    [current_node, pq] = priorityMinPop(pq);
    used(used_idx) = current_node;
    if sum(igraph(current_node).b) == 0
        break;
    end
    idxExpand = igraph(current_node).neighbors(...
            ~ismember(igraph(current_node).neighbors,used));
        if ~isempty(idxExpand)
            igraph = updateGraph(igraph, current_node, idxExpand);
            costs = getCosts(idxExpand, igraph);
            pq = priorityPush(pq,idxExpand,costs);
        end
end
if sum(igraph(current_node).b) ~= 0
    path = -1;
else
    path = buildPath(igraph, idxStart, current_node);
end
toc

%% subfunction

    function igraph = updateGraph(igraph, current_node, idxExpand)
        [igraph(idxExpand).backpointer] = deal(current_node);
        dists = igraph(current_node).neighborsCost(...
            ismember(igraph(current_node).neighbors,idxExpand));
        g = dists + igraph(current_node).g;
        g = num2cell(g);
        [igraph(idxExpand).g] = deal(g{:});
    end

    function graphPath = buildPath(igraph, idxStart, idxEnd)
        idx = idxEnd;
        graphPath = zeros(1,numel(igraph));
        graphPath(1) = idx;
        n = 2;
        while idx ~= idxStart
            graphPath(n) = igraph(idx).backpointer;
            n = n+1;
            idx = igraph(idx).backpointer;   
        end
        graphPath = graphPath(graphPath>0);
        graphPath = fliplr(graphPath);
    end

    function costs = getCosts(idxExpand, igraph)
        total_dists = [igraph(idxExpand).g];
        sums = cellfun(@sum, {igraph(idxExpand).b});
        costs = total_dists + sums;
    end
end

