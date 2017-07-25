function gIdx = findNearestNode(x, g, world)
% Finds the nearest node in graph g to x

gxs = vertcat(g.x);
intx.intAdjacencyMatrix = true;
while any(intx.intAdjacencyMatrix)
    d = dist([x' gxs']);
    [~,gIdx] = min(d(1,2:end));
    intx = lineSegmentIntersect({[x;g(gIdx).x]}, world.edges);
    if any(intx.intAdjacencyMatrix)
        gxs(gIdx, :) = [inf inf];
    end
end
end