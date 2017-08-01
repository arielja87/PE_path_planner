function [igraph, ugraph] = igraph_init(ugraph, world)
%% Constructs a directed information graph from a visibility graph

%Robustness constant
epsilon = 0.00000000001;

%Snap distance (distance within which an observer location will be snapped to the
%boundary before the visibility polygon is computed)
snap_distance = 0.0001;

igraph = struct('x', [], 'b', [], 'gv', [], 'i', []);
igraph(1) = [];

%% first loop: initialize information graph

intPoints = findInteriorPoints(world);
for g = 1:numel(ugraph)
    %Obtain the visibility polygon for current graph node
    vp = visibility_polygon( [ugraph(g).x(1) ugraph(g).x(2)] , {world.vertices} , epsilon , snap_distance );
%     h = patch( vp(:,1) , vp(:,2) , 0.1*ones( size(vp,1) , 1 ) , ...
%            'r' , 'linewidth' , 1.5, 'FaceColor' , [.65 1 .65], 'faceAlpha', .5);
    
    %Get edges from visibility polygon
    vpEdges = makeEdges(vp);
%     vpEdges{:}
    %Determine which edges are gap edges and count them
    gapEdges = findGapEdges(vpEdges, ugraph(g).x, world);
    nGaps = numel(gapEdges);
%     gapEdges{:}
    
    %Create a node in the information graph for every possible combination
    %of gap edges, b vector
    idx = numel(igraph)+1:numel(igraph)+2^nGaps;
    [igraph(idx).x] = deal(ugraph(g).x);
    ugraph(g).ii = idx;
    
    %Put gap edges in graph
    ugraph(g).gapEdges = gapEdges;

    %Make cell array of all possble b vectors containing contamination of
    %edge specified by igraph.gv
    bCell = num2bin_vector(nGaps);
    [igraph(idx).b] = deal(bCell{:});
    
    %Assign the gap vertices that correspond to the gap edges. Each gap
    %edge has one unique endpoint that is an interior corner of the
    %environment. This is so the edges dont have to be parsed each time we
    %check the transitions between conservative regions. gv is a matrix of
    %points.
    
    gv = findGapVertices(gapEdges, intPoints);
    [igraph(idx).gv] = deal(gv);    
    ugraph(g).gv = gv;
    
    %Attach the index of the visibility graph to each superimposed node of
    %the information graph for reference
    [igraph(idx).i] = deal(g);    
%     
%     pause(1)
%     delete(h)
end
end
