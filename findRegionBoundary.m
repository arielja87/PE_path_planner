function regionBoundary = findRegionBoundary(edge, orientation, regionEdges)
% takes an initial edge and orientation and finds a shortest closed loop
% from other conservative edges in regionEdges

persistent firstEdge boundary % b
if isempty(boundary)
    boundary = {edge};
%     v = edge(2,:) - edge(1,:);
%     b = quiver(edge(1,1), edge(1,2), v(1), v(2), 'color', [.5 0 1], 'linewidth', 2);
end
if isempty(firstEdge)
    firstEdge = edge;
elseif round(edge(2,:),4) == round(firstEdge(1,:),4)
    regionBoundary = boundary;
    clear boundary
    clear firstEdge
%     delete(b)
    return
end
attachedEdges = findAttachedSegments(edge, regionEdges);
nextEdge = chooseNextEdge(edge, orientation, attachedEdges);
% h = plot(nextEdge(:,1), nextEdge(:,2), 'color', 'g', 'linewidth', 2);
% pause(.2)
% delete(h)
boundary = [boundary {nextEdge}];
regionBoundary = findRegionBoundary(nextEdge, orientation, regionEdges);
end