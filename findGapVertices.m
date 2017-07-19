function gv = findGapVertices(gapEdges, intPoints)
% creates a matrix of gap vertices unique to each conservative region
gv = zeros(numel(gapEdges),2);
for i = 1:numel(gapEdges)
    if ismember(gapEdges{i}(1,:), intPoints, 'rows')
        gv(i,:) = gapEdges{i}(1,:);
    end
end
end