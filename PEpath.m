%% Setup Environment
% close all
clc
clear
format compact
world = -1;
while isequal(world,-1)
    fprintf('List of valid environment files:\n\n')
    fList = ls('*.dat');
    for i = 1:numel(fList(:,1))
        disp(fList(i,:))
    end
    filename = input('\nEnter the name of the file to use or press "C" to create your own environment: ', 's');
    if strcmpi(filename, 'c')
        v = custom_environment;
        filename = 'custom_env.dat';
        save(filename, 'v', '-ascii');
    else
        if ~contains(filename, '.dat')
            filename = strcat(filename, '.dat');
        end
    end
    world = create_environment(filename);drawnow;
end
%% Conservative Lines
clc
fprintf(['Extending rays from all edges into free space\nand away'...
' from interior corners between which is a clear line of sight, and'...
' outside of which is free space...\n'])
conservativeLines = make_conservativeLines(world);
% plot
cLinesMat = cell2mat(conservativeLines);
l = line(cLinesMat(:,1:2:end), cLinesMat(:,2:2:end), 'color', [.5 .5 1]);
%commandwindow
input('Press "Enter" to continue...');
clc
%% Conservative regions
fprintf(['Separating the environment into "conservative regions," within which\n'...
    'the contamination of the gap edges of the visibility polygon is constant.\n'...
    'Since every point within these conservative regions has the same B values,\n'...
    'it is only necessary to visit one point in each region.\n'...
    'For simplicity, we choose the centers...\n']);
[regionEdges, in, xPoints] = separateEdges(conservativeLines, world);
% environmentGraph(regionEdges, in, xPoints)
regions = make_conservativeRegions(regionEdges, in, world);
world.regionEdges = regionEdges;
points = regionCenters(regions);
% plot
c = plot(points(:,1), points(:,2), 'k.');
% col='ymcrgbk';
% p = zeros(1,numel(regions));
% for r = 1:numel(regions)
%     p(r) = patch(regions{r}(:,1), regions{r}(:,2), col(mod(r,7)+1), 'faceAlpha', .2);
% end
%commandwindow
input('Press "Enter" to continue...');
clc
%% Undirected graph
fprintf('Connecting the centers of adjacent conservative regions into an undirected graph...\n')
[h,ugraph] = points2graph(points, regionEdges, regions);
% plot
set(h, 'Visible', 'on')
%commandwindow
input('Press "Enter" to continue...');
clc
set(l, 'visible', 'off')
% delete(p)
%% Information graph
fprintf(['Creating a directed information graph by examining the transitions\nbetween'...
    ' conservative regions...\n'])
% t = plotIndeces(graph);
[igraph, di_graph] = informationGraph(ugraph, world);
env_fig = gcf;
dig_fig = figure('Units', 'normalized', 'Position',[.15,.25,.4,.5],'Toolbar','none',...
                'MenuBar','none', 'name', 'Directed Information Graph', 'NumberTitle', 'off', 'color', [1 1 1], 'visible', 'off');
axis off square equal
hold on
if numel(igraph) < 2000
    plot(di_graph);
    set(dig_fig, 'visible', 'on');
end
fprintf('The superimposed directed information graph contains %d nodes.\n', numel(igraph))
g = igraph(1).graph;
%% Path generation
x = [inf inf];
while true
    a_count = 0;
    vp = [];
    pathHandle = [];
    key = 'a';
    figure(env_fig)
    % Get user input for starting position
    while ~inpolygon(x(1), x(2), world.vertices(:,1), world.vertices(:,2))
        disp('Use the mouse to select a starting position...')
        x = ginput(1);
    end
    disp('Searching for a shortest complete path...')
    gIdx = findNearestNode(x, g, world);
    idxStart = g(gIdx).ii(end);
    s = plot(x(1), x(2), 'k.', 'markersize', 25);
    set(c, 'Visible', 'off');drawnow;
    % Generate Path
    path = di_search(di_graph, igraph, idxStart);
    while strcmpi(key, 'a')
        if isempty(path)
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
        %commandwindow;
        key = input('\nPress "Enter" to choose a new starting location,\n"A" to animate the path again,\n"N" to load a new environment,\n"Q" to quit: ', 's');
        if strcmpi(key, 'n')
            PEpath
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
