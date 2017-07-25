%% Setup Environment
clf
clc
clear all
format compact
world = -1;
while isequal(world,-1);
    fprintf('\nList of valid environment files:\n\n')
    fList = ls('*.dat');
    for i = 1:numel(fList(:,1))
        disp(fList(i,:))
    end
    filename = input('\nEnter the name of the file to use: ', 's');
    if isempty(strfind(filename, '.dat'))
        filename = strcat(filename, '.dat');
    end
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
disp(['Creating a directed information graph by examining the transitions between'...
    ' conservative regions...'])
% t = plotIndeces(graph);
igraph = informationGraph(graph, world);
fprintf('The superimposed directed information graph contains %d nodes.\n', numel(igraph))
g = igraph(1).graph;
%% Path generation
x = [inf inf];
while true
    a_count = 0;
    vp = [];
    pathHandle = [];
    key = 'a';
    % Get user input for starting position
    while ~inpolygon(x(1), x(2), world.vertices(:,1), world.vertices(:,2))
        disp('Use the mouse to select a starting position...')
        x = ginput(1);
    end
    disp('Searching for a shortest complete path...')
    if numel(igraph) > 2000
        disp('This may take several minutes...')
    elseif numel(igraph) > 1000 
        disp('This may take about a minute')
    end
    gIdx = findNearestNode(x, g, world);
    idxStart = g(gIdx).ii(end);
    s = plot(x(1), x(2), 'k.', 'markersize', 25);
    set(c, 'Visible', 'off');drawnow;
    % Generate Path
    path = iSearch(igraph, idxStart);
    while strcmpi(key, 'a')
        if path == -1
            disp('No complete path found. This environment requires additional pursuers.')
        else
            pathHandle = plotPath(path, igraph, x);
            if a_count == 0
                pause(2)
            end
            set(h, 'Visible', 'off');set(c, 'Visible', 'off');drawnow;
            delete(s);
            vp = animate_path(igraph, path, world, x);
            a_count = 1;
        end
        set(h, 'Visible', 'on');set(c, 'Visible', 'on');drawnow;
        key = input('\nPress "Enter" to choose a new starting location,\n"A" to animate the path again,\n"N" to load a new environment,\n"Q" to quit: ', 's');
        if strcmpi(key, 'n')
            pursuit_evasion_path_test
            return
        elseif strcmpi(key, 'q')
            clc;
            return
        elseif ~any(strcmpi(key, {'n', 'q', 'a'}))
            delete(vp);delete(pathHandle);
            x = ginput(1);
        end
    delete(vp);delete(pathHandle);delete(s);
    clc
    end
end
