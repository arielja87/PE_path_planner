function [found_split, parentLogical, childLogical, holdoverGaps] = splitOrAppear(g, n, graph, world, epsilon, snap_distance)
% determines the nature of the transition between graph indeces
% outputs a 1 for a split and a 0 for an appearance

observerLine = [graph(g).x; graph(n).x];
% find the point where the observer transistions to a new region
x = lineSegmentIntersect({observerLine}, world.regionEdges);
crossPoint = [x.intMatrixX(x.intAdjacencyMatrix) x.intMatrixY(x.intAdjacencyMatrix)];

% find a point just after the transistion to compare gap edge angles
crossDir = (observerLine(2,:) - observerLine(1,:))/norm(observerLine(2,:) - observerLine(1,:));
testPoint = crossPoint + crossDir*.001;

%find visibility polygon at test point
vp = visibility_polygon(testPoint, {world.vertices}, epsilon, snap_distance);
%     h = patch( vp(:,1) , vp(:,2) , 0.1*ones( size(vp,1) , 1 ) , ...
%            'r' , 'linewidth' , 1.5, 'FaceColor' , [.65 1 .65], 'faceAlpha', .5);
%Get edges from visibility polygon
vpEdges = makeEdges(vp);

%Determine which edges are gaps
gapEdges = findGapEdges(vpEdges, testPoint, world);
gapEdges = orderGapEdges(gapEdges, graph(n).gv);    
% find the angles of the gap edges measured from the positive x-axis

angles = lineAngles(gapEdges);

% threshold angle (degrees) under which two gap edge angles are close
% enough to consider them split
splitThreshold = .5;
m = dist(angles);
locs = any(ismember(m,min(m(m>0 & m<splitThreshold))));
if any(locs)
    found_split = true;
    childLogical = locs;
    gapAngle = angles(childLogical);
    gapAngle = gapAngle(1);
    % repeat above process to find parent gap edge
    newTestPoint = crossPoint - crossDir*.001;
    vp = visibility_polygon(newTestPoint, {world.vertices}, epsilon, snap_distance);
    vpEdges = makeEdges(vp);
    gapEdges = findGapEdges(vpEdges, newTestPoint, world);
    gapEdges = orderGapEdges(gapEdges, round(graph(g).gv,4));    
    parentAngles = lineAngles(gapEdges);
    parentLogical = abs(parentAngles - gapAngle) < splitThreshold | 360 - abs(parentAngles - gapAngle) < splitThreshold;
    holdoverGaps = findHoldoverGaps(g, n, graph, world, epsilon, snap_distance);
    holdoverGaps(childLogical) = 0;
else
    found_split = false;
    childLogical = [];
    parentLogical = [];
    holdoverGaps = findHoldoverGaps(g, n, graph, world, epsilon, snap_distance);

end
end