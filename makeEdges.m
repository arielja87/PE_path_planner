function edges = makeEdges(vertices)
if ~isequal(vertices(end,:), vertices(1,:))
    vertices(end+1,:) = vertices(1,:);
end
edges = cell(1,length(vertices(:,1))-1);
    for i = 1:numel(edges)
        edges{i} = [vertices(i,:); vertices(i+1,:)];
    end
end