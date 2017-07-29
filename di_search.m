function path = di_search(di_graph, igraph, idxStart)
% Uses matlab's graph search tool box to find a tree to all possible goal
% nodes, then finds the shortest path
iList = 1:numel(igraph);
goals = iList(cellfun(@(x) sum(x) == 0, {igraph.b}));
[tree_cell, distances]  = shortestpathtree(di_graph, idxStart, goals, 'OutputForm', 'cell');
[~,min_distance] = min(distances);
path = cell2mat(tree_cell(min_distance));
end