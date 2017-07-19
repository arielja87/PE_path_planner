function igraph = informationGraph(graph, world)
%% Constructs a directed information graph from a visibility graph

%Robustness constant
epsilon = 0.000000001;

%Snap distance (distance within which an observer location will be snapped to the
%boundary before the visibility polygon is computed)
snap_distance = 0.0001;

igraph = struct('neighbors', [], 'neighborsCost', [], 'g', [], 'backpointer', [], 'x', [], 'b', [], 'gv', [], 'i', []);
igraph(1) = [];

%% first loop: initialize information graph
for g = 1:numel(graph)
    %Obtain the visibility polygon for current graph node
    vp = visibility_polygon( [graph(g).x(1) graph(g).x(2)] , {world.vertices} , epsilon , snap_distance );
    vp = round(vp,4);
%     h = patch( vp(:,1) , vp(:,2) , 0.1*ones( size(vp,1) , 1 ) , ...
%            'r' , 'linewidth' , 1.5, 'FaceColor' , [.65 1 .65], 'faceAlpha', .5);

    %Get edges from visibility polygon
    vpEdges = makeEdges(vp);
    
    %Determine which edges are gap edges and count them
    gapEdges = findGapEdges(vpEdges, graph(g).x, world);
    nGaps = numel(gapEdges);
    
    %Create a node in the information graph for every possible combination
    %of gap edges, b vector
    idx = numel(igraph)+1:numel(igraph)+2^nGaps;
    [igraph(idx).x] = deal(graph(g).x);
    graph(g).ii = idx;
    
    %Put gap edges in graph
    graph(g).gapEdges = gapEdges;
    
    %Make cell array of all possble b vectors containing contamination of
    %edge specified by igraph.gv
    bCell = num2bin_vector(nGaps);
    [igraph(idx).b] = deal(bCell{:});
    
    %Assign the gap vertices that correspond to the gap edges. Each gap
    %edge has one unique endpoint that is an interior corner of the
    %environment. This is so the edges dont have to be parsed each time we
    %check the transitions between conservative regions. gv is a matrix of
    %points.
    
    intPoints = findInteriorPoints(world);
    gv = findGapVertices(gapEdges, intPoints);
    [igraph(idx).gv] = deal(gv);    
    graph(g).gv = gv;
    
    %Attach the index of the visibility graph to each superimposed node of
    %the information graph for reference
    [igraph(idx).i] = deal(g);    
    
%     pause(.1)
%     delete(h)
end

%% Main loop: construct neighbors within information graph according to the following rules:
% 1. a gap-edge disappears, do nothing;
% 2. a gap-edge appears, assign it a zero; 
% 3. two or more gap-edges merge into one, if any of them had a one label, assign a one to the new edge;
% 4. a gap-edge divides into multiple gap-edges, assign the new edges the same label as the original;

iList = 1:numel(igraph);
for g = 1:numel(graph)
    for n = graph(g).neighbors;
    % first scenario is trivial
    
        if length(graph(g).gv(:,1)) < length(graph(n).gv(:,1))
            % Either a split has occured or a new gap edge appeared
            % A split occured if the observer crossed a line between an old
            % gap vertex and a new gap vertex
            [found_split, parentLogical, childLogical, holdoverGaps] = splitOrAppear(g, n, graph, world, epsilon, snap_distance);
            %get the list of current igraph nodes
            if found_split
                for ig =  iList([igraph.i] == g);
                    for in =  iList([igraph.i] == n);
                        if all(igraph(ig).b(parentLogical) == igraph(in).b(childLogical)) && isequal(igraph(ig).b(holdoverGaps(holdoverGaps > 0)), igraph(in).b(holdoverGaps > 0)); %Scenario #4
                            igraph(ig).neighbors = [igraph(ig).neighbors in];
                            igraph(ig).neighborsCost = [igraph(ig).neighborsCost graph(g).neighborsCost(graph(g).neighbors == n)];
                        end
                    end
                end
            else    %appearance occured
                for ig =  iList([igraph.i] == g);
                    for in =  iList([igraph.i] == n);
                        if all(igraph(in).b(holdoverGaps == 0) == 0) && isequal(igraph(ig).b(holdoverGaps(holdoverGaps > 0)), igraph(in).b(holdoverGaps > 0)); %Scenario #2
                            igraph(ig).neighbors = [igraph(ig).neighbors in];
                            igraph(ig).neighborsCost = [igraph(ig).neighborsCost graph(g).neighborsCost(graph(g).neighbors == n)];
                        end
                    end
                end                
            end 
        elseif length(graph(g).gv(:,1)) > length(graph(n).gv(:,1))
            % Either two gap edges merged or one disappeared
            [found_split, parentLogical, childLogical, ~] = splitOrAppear(n, g, graph, world, epsilon, snap_distance);
            if found_split
                % A split with the position order reversed is a merge
                holdoverGaps = findHoldoverGaps(n, g, graph, world, epsilon, snap_distance);  
                holdoverGaps(childLogical) = 0;
                for ig =  iList([igraph.i] == g);
                    for in =  iList([igraph.i] == n);
                        if all(igraph(in).b(parentLogical) == max(igraph(ig).b(childLogical))) && isequal(igraph(in).b(holdoverGaps(holdoverGaps > 0)), igraph(ig).b(holdoverGaps > 0)); %Scenario #3
                            igraph(ig).neighbors = [igraph(ig).neighbors in];
                            igraph(ig).neighborsCost = [igraph(ig).neighborsCost graph(g).neighborsCost(graph(g).neighbors == n)];
                        end
                    end
                end
            else
                % A gap Edge disappeared
                holdoverGaps = findHoldoverGaps(g, n, graph, world, epsilon, snap_distance);
                for ig =  iList([igraph.i] == g);
                    for in =  iList([igraph.i] == n);
                        if isequal(igraph(ig).b(holdoverGaps(holdoverGaps > 0)), igraph(in).b(holdoverGaps > 0)); %None of the important scenarios occured
                            igraph(ig).neighbors = [igraph(ig).neighbors in];
                            igraph(ig).neighborsCost = [igraph(ig).neighborsCost graph(g).neighborsCost(graph(g).neighbors == n)];
                        end
                    end
                end  
            end
        else
            % Just keep the same values of the gap edges through the
            % transition
            holdoverGaps = findHoldoverGaps(g, n, graph, world, epsilon, snap_distance);
            for ig =  iList([igraph.i] == g);
                for in =  iList([igraph.i] == n);
                    if isequal(igraph(ig).b(holdoverGaps(holdoverGaps > 0)), igraph(in).b(holdoverGaps > 0)); %None of the important scenarios occured
                        igraph(ig).neighbors = [igraph(ig).neighbors in];
                        igraph(ig).neighborsCost = [igraph(ig).neighborsCost graph(g).neighborsCost(graph(g).neighbors == n)];
                    end
                end
            end              
        end
    end
end
igraph(1).graph = graph;
end