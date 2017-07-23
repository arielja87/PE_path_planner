function intPoints = findInteriorPoints(world)
    vertices = world.vertices;
    edges = [world.edges{end} world.edges world.edges{1}];
    n=1;
    for i = 1:length(vertices(:,1))
        ksign = checkCross(edges{i}, edges{i+1});
        if ksign < 0
            intPoints(n,:) = vertices(i,:);
            n = n+1;            
        end
    end
    intPoints = round(intPoints,5);
    intPoints = unique(intPoints, 'rows');
end