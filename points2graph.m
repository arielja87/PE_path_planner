function [h, graph] = points2graph(points, regionEdges, regions)
s = struct('neighbors', [], 'neighborsCost', [], 'x', [], 'b', [], 'gv', []);
graph = repmat(s,length(points(:,1)),1);
n = 1;
h = zeros(1,numel(points)*2);
for i = 1:length(points(:,1))
    graph(i).x = points(i,:);
    num_
    for j = 1:length(points(:,1))
        testEdge = [points(i,:); points(j,:)];
        out = lineSegmentIntersect({testEdge}, regionEdges);
        intersections = [out.intMatrixX' out.intMatrixY'];
        intersections = intersections(out.intAdjacencyMatrix,:); 
        if numel(intersections) == 2
            h(n) = line(testEdge(:,1), testEdge(:,2), [.5 .5], 'color', 'red');set(h(n), 'Visible', 'off');
            n=n+1;
            cost = norm(testEdge(2,:) - testEdge(1,:));
            graph(i).neighbors = [graph(i).neighbors j];
            graph(i).neighborsCost = [graph(i).neighborsCost cost];
        end
    end       
end
h = h(h>0);
% set(h, 'Visible', 'on');drawnow;
end