%% Setup Environment
clf
clc
world = -1;
while isequal(world,-1);
    fprintf('\nList of valid environment files:\n\n')
    fList = ls('*.dat');
    for i = 1:numel(fList(:,1))
        disp(fList(i,:))
    end
    filename = input('\nEnter the name of the file to use: ', 's');
    world = create_environment(filename);drawnow;
end
%% Conservative Lines
fprintf(['\nExtending rays from all edges into free space\nand away'...
' from interior points between which is a clear line of sight, and'...
' outside of which is free space...\n'])
conservativeLines = make_conservativeLines(world);
% plot
    cLinesMat = cell2mat(conservativeLines);
    l = line(cLinesMat(:,1:2:end), cLinesMat(:,2:2:end), 'color', [.5 .5 1]);
%% Conservative regions
[regionEdges, in] = separateEdges(conservativeLines, world);
% [regionEdges, in] = edgeInOn(regionEdges, world);
regions = make_conservativeRegions(regionEdges, in, world);
input('Press "Enter" to continue...')
clc
fprintf(['Separating the environment into "conservative regions," within which'...
    ' the gap edges\nof the visibility polygon don''t provide new information...\n']);
% plot
    col='ymcrgbk';
    p = zeros(1,numel(regions));
    for r = 1:numel(regions)
        p(r) = patch(regions{r}(:,1), regions{r}(:,2), col(mod(r,7)+1), 'faceAlpha', .2);
    end
%% Undirected graph
world.regionEdges = regionEdges;
points = regionCenters(regions);
% plot
    c = plot(points(:,1), points(:,2), 'k.', 'visible', 'off');
[h,graph] = points2graphFast(points, regionEdges(in), world);
input('Press "Enter" to continue...')
clc
fprintf('Connecting the centers of conservative regions into an undirected graph...\n')
set(h, 'Visible', 'on');set(c, 'Visible', 'on');
input('Press "Enter" to continue...')
clc
delete(l)
delete(p)
%% Information graph
fprintf(['Creating a directed information graph by examining the transitions between'...
    ' conservative regions...\n'])
t = plotIndeces(graph);
igraph = informationGraph(graph, world);
g = igraph(1).graph;
%% Path generation
gIdx = -1;
while true
    vp = [];
    pathHandle = [];
    % Get user input for starting position
    while ~ismember(gIdx, 1:numel(graph))
        gIdx = input('\nEnter starting position: ');
    end
    disp('Searching for a shortest complete path...')
    idxStart = g(gIdx).ii(end);
    s = plot(igraph(idxStart).x(1), igraph(idxStart).x(2), 'k.', 'markersize', 25);
    set(t, 'Visible', 'off');set(c, 'Visible', 'off');drawnow;
    % Generate Path
    path = iSearch(igraph, idxStart);
    if path == -1
        disp('No complete path found. This environment requires additional pursuers.')
        set(h, 'Visible', 'on');set(t, 'Visible', 'on');set(c, 'Visible', 'on');drawnow;        
    else
        pathHandle = plotPath(path, igraph);
        pause(2)
        set(h, 'Visible', 'off');drawnow;
        delete(s);
        vp = animate_path(igraph, path, world);
        pause(2);
        set(h, 'Visible', 'on');set(t, 'Visible', 'on');set(c, 'Visible', 'on');set(vp, 'Visible', 'off');drawnow;                
    end
    key = input('\nEnter a new starting location, press "N" to load a new environment, or "Q" to quit: ', 's');
    if strcmpi(key, 'n')
        pursuit_evasion_path_test
    elseif strcmpi(key, 'q')
        clc;
        return
    else
        gIdx = str2double(key);
    end
    delete(vp);delete(pathHandle);delete(s);
    set(h, 'Visible', 'on');set(t, 'Visible', 'on');set(c, 'Visible', 'on');drawnow;
    clc
end