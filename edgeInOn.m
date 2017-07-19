function [regionEdges, in] = edgeInOn(regionEdges, world)
% returns a list of region edges and an n-edges x 1 logical with ones where
% region edges are interior and zeros for edges that are on the environment
% boundary

% find mindpoints of regionEdges
mp = round(midpoints(regionEdges),6);
% all edge points
edgePoints = unique(vertcat(regionEdges{:}), 'rows');
% determing if midpoints are very near world vertices and remove those
% midpoints and edges
flag = false(length(mp(:,1)),1);
for i = 1:length(mp(:,1))
    flag(i) = any(ismember([0 0], round(repmat(mp(i,:),length(edgePoints(:,1)), 1) - edgePoints,6), 'rows'));
end
% 
mp(flag,:) = [];
regionEdges(flag) = [];
% determine if midpoints are on boundaries
[~, on] = inpolygon(mp(:,1), mp(:,2), world.vertices(:,1), world.vertices(:,2));
% assign a 0 to boundary edges and a 1 to interior edges
in = ~on;
end