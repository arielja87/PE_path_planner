function world = create_environment(filename)

fid = fopen(filename);
if fid == -1
    clc
    fprintf('Could not find that file, try again.\n\n')
    world = -1;
    return
else
    C = textscan(fid,'%f %f');
    vertices = [C{1} C{2}];
    closeresult = fclose(fid);
    if closeresult ~= 0
        disp('File close not successful')
        return
    end
end
if ~isequal(vertices(end,:), vertices(1,:))
    vertices(end+1,:) = vertices(1,:);
end
vertices = round(vertices,2);
edges = makeEdges(vertices);
indeces = 1:length(vertices(:,1));
indeces(end) = 1;
world = struct('indeces', {indeces}, 'vertices', {vertices}, 'edges', {edges});
set(gcf, 'Units', 'normalized', 'Position',[.55,.25,.4,.5],'Toolbar','none',...
                'MenuBar','none', 'name', 'Pursuit Evasion Path Planner', 'NumberTitle', 'off');
clf
drawWorld(world.vertices)
line(world.vertices(:,1), world.vertices(:,2), .31*ones(size(world.vertices,1), 1), 'color', 'k');
end
    