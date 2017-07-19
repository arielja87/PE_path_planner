function attachedEdges = findAttachedSegments(edge, regionEdges)
% takes a particular edge and a list of possible edges and returns the
% edges in regionEdges attached to the second endpoint of 'edge'
n = 1;

for i = 1:numel(regionEdges)
    if  ~(isequal(edge, regionEdges{i}) || isequal(edge, flipud(regionEdges{i})))
        [is, idx] = ismember(round(edge(2,:),4), round(regionEdges{i},4), 'rows');
        if any(is)
            if idx == 2
                attachedEdges{n} = flipud(regionEdges{i});                
                n=n+1;
            else
                attachedEdges{n} = regionEdges{i};
                n=n+1;
            end
        end
    end
end
end