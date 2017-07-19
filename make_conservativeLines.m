function conservativeLines = make_conservativeLines(world)
edges = world.edges;
edges = [edges(end) edges edges(1)];
numEdges = length(edges);

n=1;
cLines = cell(1,numEdges);
intPoints = findInteriorPoints(world);
for i = 1:numel(intPoints(:,1))
    ipc = repmat({intPoints(i,:)}, 1, numel(world.edges));
    edge_log_id = cell2mat(cellfun(@(x,y) ismember(x,y,'rows'), ipc, world.edges, 'UniformOutput', false));
    attached_edges = world.edges(edge_log_id);
    for e = attached_edges
        edge = e{:};
        [~,row] = ismember(intPoints(i,:), edge, 'rows');
        if row == 2
            edge = flipud(edge);
        end
        cLines{n} = extendLine(edge, world);
        n = n+1;
    end
end
% plot(intPoints(:,1), intPoints(:,2), 'k*');
morecLines = extendIntPoints(intPoints, world);
cLines = [cLines morecLines];
cLines = uniquecell(cLines);
cLines = cLines(~cellfun('isempty',cLines));

% Need to check flip lines to check for duplicates with opposite
% orientations
for i = 1:numel(cLines)
    flipped_line = flipud(cLines{i});
    f = repmat({flipped_line}, 1, numel(cLines));
    dup_logi = cell2mat(cellfun(@(x,y) isequal(x,y), f, cLines, 'UniformOutput', false));
    cLines(dup_logi) = {[]};
end
cLines = cLines(~cellfun('isempty',cLines));

%return
conservativeLines = cLines;
end