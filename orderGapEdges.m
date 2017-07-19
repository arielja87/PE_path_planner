function edges = orderGapEdges(edges, v)
% puts gapEdges in the same order as the vertices by the first gapEdge
% vertex
e = [edges{:}];
e = reshape(e(1,:), 2, numel(edges))';
[~, loc] = ismember(v,e,'rows');
edges = edges(loc(loc>0));

end