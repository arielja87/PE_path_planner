
function morecLines = extendIntPoints(intPoints, world)
n=1;
morecLines = cell(1,numel(intPoints));
for i = 1:length(intPoints(:,1))
    for j = 1:length(intPoints(:,1))
        [~, iInVertices] = ismember(intPoints(i,:), world.vertices, 'rows');
        iInVertices = iInVertices + 1;
        worldLoop = [world.vertices(end,:); world.vertices; world.vertices(1,:)];
        if ~any(ismember(intPoints(j,:), worldLoop(iInVertices-1:iInVertices+1,:), 'rows'))
            los = [intPoints(i,:); intPoints(j,:)];
            %check if both sides of los are clear
            intx = lineSegmentIntersect({los}, world.edges);
            xi = intx.intMatrixX(intx.intAdjacencyMatrix)';
            yi = intx.intMatrixY(intx.intAdjacencyMatrix)';
            mp = midpoints({los});
            if isempty(setdiff([xi yi], los, 'rows')) &&...
                    inpolygon(mp(1), mp(2), world.vertices(:,1), world.vertices(:,2)) &&...
                        checkBothSides(los, world);
                possible1 = extendLine(los, world);
                possible2 = extendLine(flipud(los), world);
                if all(size(possible1) == [2,2]) && all(size(possible2) == [2,2])
                    morecLines{n} = possible1;
                    n=n+1;
                    morecLines{n} = possible2;
                    n=n+1;
                end
            end
        end
    end
end

end