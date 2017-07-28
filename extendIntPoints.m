
function morecLines = extendIntPoints(intPoints, world)
n=1;
morecLines = cell(1,numel(intPoints));
for i = 1:length(intPoints(:,1))
    for j = 1:length(intPoints(:,1))
        [~, iInVertices] = ismember(intPoints(i,:), world.vertices, 'rows');
        iInVertices = iInVertices + 1;
        worldLoop = [world.vertices(end-2,:); world.vertices; world.vertices(2,:)];
        if ~any(ismember(intPoints(j,:), worldLoop(iInVertices-1:iInVertices+1,:), 'rows'))
            los = [intPoints(i,:); intPoints(j,:)];
            %check if both sides of los are clear
            intx = lineSegmentIntersect({los}, world.edges);
            xi = intx.intMatrixX(intx.intAdjacencyMatrix)';
            yi = intx.intMatrixY(intx.intAdjacencyMatrix)';
            intxs = round([xi yi], 6);
            mp = midPoint(los(1,:), los(2,:));
%             ph = plot(los(:,1), los(:,2), 'k*');
%             los
%             conditions = [
%                 isempty(setdiff(intxs, los, 'rows'));
%                 inpolygon(mp(1), mp(2), world.vertices(:,1), world.vertices(:,2));
%                 checkBothSides(los, world)]
%             pause(5); 
%             delete(ph);
            if isempty(setdiff(intxs, los, 'rows')) &&...
                    inpolygon(mp(1), mp(2), world.vertices(:,1), world.vertices(:,2)) &&...
                        checkBothSides(los, world)
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