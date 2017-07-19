
function edgeQueue = removeRegionEdges(regionBoundary, edgeQueue)
% removes regionBoundary edges from edgeQueue

for i = 1:numel(regionBoundary)
    j = 1;
    done = false;
    while ~done
        if isequal(round(regionBoundary{i},4), round(edgeQueue{j},4)) || isequal(round(regionBoundary{i},4), flipud(round(edgeQueue{j},4)))
            edgeQueue(j) = [];
            done = true;            
        else
            j = j+1;
        end 
    end
end