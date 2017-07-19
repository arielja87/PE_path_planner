
function edges = makeEdges(vertices)
edges = cell(1,length(vertices(:,1))-1);
    for i = 1: length(vertices(:,1))-1
        edges{i} = [vertices(i,:); vertices(i+1,:)];
    end
edges{end+1} = [vertices(end,:); vertices(1,:)];
end