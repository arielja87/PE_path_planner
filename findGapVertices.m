function gv = findGapVertices(gapEdges, intPoints)
% creates a matrix of gap vertices unique to each conservative region
gv = inf(numel(gapEdges),2);
for i = 1:numel(gapEdges)
    if ismember(round(gapEdges{i}(1,:),3), round(intPoints, 3), 'rows')
        gv(i,:) = gapEdges{i}(1,:);
    end
end
gv = gv(~isinf(gv(:,1)),:);
end