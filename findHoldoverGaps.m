function holdoverGaps = findHoldoverGaps(g, n, graph, world, epsilon, snap_distance)
% Finds any holdover gap edges from the previous observation point

observerLine = [graph(g).x; graph(n).x];
% find the point where the observer transistions to a new region
x = lineSegmentIntersect({observerLine}, world.regionEdges);
crossPoint = [x.intMatrixX(x.intAdjacencyMatrix) x.intMatrixY(x.intAdjacencyMatrix)];

% find a point just after the transistion to compare gap edge angles
crossDir = (observerLine(2,:) - observerLine(1,:))/norm(observerLine(2,:) - observerLine(1,:));
testPoint = crossPoint + crossDir*.001;

%find visibility polygon at test point
vp = visibility_polygon(testPoint, {world.vertices}, epsilon, snap_distance);

%Get edges from visibility polygon
vpEdges = makeEdges(vp);

%Determine which edges are gaps
gapEdges = findGapEdges(vpEdges, testPoint, world);
gapEdges = orderGapEdges(gapEdges, round(graph(n).gv,4));

% find the angles of the gap edges measured from the positive x-axis
childAngles = lineAngles(gapEdges);

% threshold angle (degrees) under which two gap edge angles are close
% enough to consider the new gap a holdover from the previous observation
% point
holdoverThreshhold = 1;

% repeat above process for the parent observation point
newTestPoint = crossPoint - crossDir*.001;
vp = visibility_polygon(newTestPoint, {world.vertices}, epsilon, snap_distance);
vpEdges = makeEdges(vp);
gapEdges = findGapEdges(vpEdges, newTestPoint, world);
gapEdges = orderGapEdges(gapEdges, round(graph(g).gv,4));
parentAngles = lineAngles(gapEdges);

holdoverGaps = zeros(1,numel(childAngles));
for i = 1:length(childAngles)
    for j = 1:length(parentAngles)
        d = abs(childAngles(i) - parentAngles(j));
        if d < holdoverThreshhold || 360 - d < holdoverThreshhold
            holdoverGaps(i) = j;
            break
        end
    end
end  
end