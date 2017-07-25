function holdoverGaps = findHoldoverGaps(g, n, graph, world, epsilon, snap_distance)
% Finds any holdover gap edges from the previous observation point

observerLine = [graph(g).x; graph(n).x];
% find the point where the observer transistions to a new region
x = lineSegmentIntersect({observerLine}, world.regionEdges);
crossPoint = [x.intMatrixX(x.intAdjacencyMatrix) x.intMatrixY(x.intAdjacencyMatrix)];

% find a point just after the transistion to compare gap edge angles
crossDir = (observerLine(2,:) - observerLine(1,:))/norm(observerLine(2,:) - observerLine(1,:));
testPoint = crossPoint + crossDir*.0001;

%find visibility polygon at test point
vp = visibility_polygon(testPoint, {world.vertices}, epsilon, snap_distance);
%Get edges from visibility polygon
vpEdges = makeEdges(vp);

%Determine which edges are gaps
gapEdges = findGapEdges(vpEdges, testPoint, world);
gapEdges = orderGapEdges(gapEdges, graph(n).gv);
% find the angles of the gap edges measured from the positive x-axis
childAngles = lineAngles(gapEdges);

% threshold angle (degrees) under which two gap edge angles are close
% enough to consider the new gap a holdover from the previous observation
% point
holdoverThreshold = .4;

% repeat above process for the parent observation point
newTestPoint = crossPoint - crossDir*.0001;
vp = visibility_polygon(newTestPoint, {world.vertices}, epsilon, snap_distance);
vpEdges = makeEdges(vp);
gapEdges = findGapEdges(vpEdges, newTestPoint, world);
gapEdges = orderGapEdges(gapEdges, graph(g).gv);
parentAngles = lineAngles(gapEdges);

% g
% n
% graph(g).gv
% graph(n).gv
% parentAngles
% childAngles
holdoverGaps = zeros(1,numel(childAngles));
for i = 1:length(childAngles)
    d = abs(childAngles(i) - parentAngles);
    d(360 - d < holdoverThreshold) = 360 - d(360 - d < holdoverThreshold);
    if any(d < holdoverThreshold)
        d(d >= holdoverThreshold) = inf;
        [~, holdoverGaps(i)] = min(d);
    else
        holdoverGaps(i) = 0;
    end
end
end