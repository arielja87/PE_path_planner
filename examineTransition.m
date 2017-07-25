function out = examineTransition(g, n, graph, world)
% Establishes a linear space near the conservative region transition over
% which to track the gap edges as they change
observerLine = [graph(g).x; graph(n).x];

% find the point where the observer transistions to a new region
x = lineSegmentIntersect({observerLine}, world.regionEdges);
crossPoint = [x.intMatrixX(x.intAdjacencyMatrix) x.intMatrixY(x.intAdjacencyMatrix)];
% plot(crossPoint(:,1), crossPoint(:,2), 'k*');
num_old_gaps = numel(graph(g).gv(:,1));
num_new_gaps = numel(graph(n).gv(:,1));

l_old = zeros(num_old_gaps*2, 2);
l_new = zeros(num_new_gaps*2, 2);

l_old(1:2:end,:) = repmat(crossPoint, num_old_gaps, 1);
l_old(2:2:end,:) = graph(g).gv;
l_old_cell = mat2cell(l_old, ones(1,num_old_gaps)*2);
parentAngles = lineAngles(l_old_cell);


l_new(1:2:end,:) = repmat(crossPoint, num_new_gaps, 1);
l_new(2:2:end,:) = graph(n).gv;
l_new_cell = mat2cell(l_new, ones(1,num_new_gaps)*2);
childAngles = lineAngles(l_new_cell);

[out.forward_log,out.forward_idx] = ismember(round(parentAngles,2), round(childAngles,2));
[out.backward_log,out.backward_idx] = ismember(round(childAngles,2), round(parentAngles,2));


end
