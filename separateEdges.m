function [regionEdges, in, xPoints] = separateEdges(conservativeLines, world)
%% Separate all edges into edges of conservative regions
% get intersections of all conservative lines with themselves
intxOut = lineSegmentIntersect(conservativeLines, conservativeLines);
xPoints = [intxOut.intMatrixX(intxOut.intAdjacencyMatrix) intxOut.intMatrixY(intxOut.intAdjacencyMatrix)];

% get intersections of all conservative lines with the world edges
intxOut = lineSegmentIntersect(conservativeLines, world.edges);
xPoints = [xPoints; intxOut.intMatrixX(intxOut.intAdjacencyMatrix) intxOut.intMatrixY(intxOut.intAdjacencyMatrix); world.vertices; cell2mat(conservativeLines')];
xPoints = unique(round(xPoints,6), 'rows');

%divide world edges into segments based on conservative line intersections
allEdges = [world.edges conservativeLines];
regionEdges = cell(1,numel(allEdges));
in = false(1,numel(allEdges));
n = 1;
for i = 1:numel(allEdges)
    flags = pointOnLine(xPoints, allEdges{i});
    if any(flags)
        edgePoints = xPoints(flags,:);
        dists = dist([allEdges{i}(1,:)', edgePoints']);
        [~,idx] = sort(dists(1,2:end));
        edgePoints = [allEdges{i}(1,:); edgePoints(idx,:); allEdges{i}(2,:)];
        for j = 1:length(edgePoints(:,1))-1
            regionEdges{n} = [edgePoints(j,:); edgePoints(j+1,:)];
            if i <= numel(world.edges)
                in(n) = false;
                n = n+1;
%                 plot(regionEdges{n-1}(:,1), regionEdges{n-1}(:,2), 'r');pause(1);
            else
                in(n) = true;
                n = n+1;
%                 plot(regionEdges{n-1}(:,1), regionEdges{n-1}(:,2), 'g');pause(1);               
            end
        end
    else 
        regionEdges(n) = allEdges(i);
        if i <= numel(world.edges)
            in(n) = false;
            n = n+1;
%             plot(regionEdges{n-1}(:,1), regionEdges{n-1}(:,2), 'r');pause(1);               
        else
            in(n) = true;
            n = n+1;
%             plot(regionEdges{n-1}(:,1), regionEdges{n-1}(:,2), 'g');pause(1);                           
        end
    end 
end

logi = ~cellfun('isempty',regionEdges);
regionEdges =  regionEdges(logi);
in = in(logi);
[regionEdges, uid] = uniquecell(regionEdges);
in = in(uid);
logi = cell2mat(cellfun(@(x) isequal(round(x(1,:),4), round(x(2,:),4)), regionEdges, 'UniformOutput', false));
regionEdges(logi) = [];
in(logi) = [];
end
    

