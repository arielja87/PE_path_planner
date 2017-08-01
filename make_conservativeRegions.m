function regions = make_conservativeRegions(regionEdges, in, world)
% takes region edges and a logical vector stating whether the edges are on
% the boundary or in the interior of the environment and returns distinct
% conservative regions

%create a queue of all edges, containing one entry for every boundaray edge
%and two entries for interior edges

edgeQueue = [regionEdges regionEdges(in)];
regions = cell(1,numel(regionEdges));
n = 1;
while ~isempty(edgeQueue)
    % take the first edge in the list and find out which side of it is free
    % space
    orientation = checkOrientation(edgeQueue{1}, regions, world);
    regionBoundary = findRegionBoundary(edgeQueue{1}, orientation, regionEdges);
    edgeQueue = removeRegionEdges(regionBoundary, edgeQueue);
    newRegion = unique(vertcat(regionBoundary{:}), 'rows');
    k = convhull(newRegion(:,1), newRegion(:,2));
    regions{n} = newRegion(k(1:end-1),:);
    n = n+1;
%     patch(regions{end}(:,1), regions{end}(:,2), 'b', 'facealpha', .5)
%     pause(.5)
    
end
regions = regions(~cellfun('isempty', regions));
end