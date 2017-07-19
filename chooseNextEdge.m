function nextEdge = chooseNextEdge(edge, orientation, attachedEdges)
% takes an edge and compares the attached edges to determine the next edge
% in the loop according to the orientation
if numel(attachedEdges) == 1
    nextEdge = attachedEdges{:};
else
    vEdge = [edge(2,:) - edge(1,:), 0];
    angle = zeros(numel(attachedEdges),1);
    for i = 1:numel(attachedEdges)
%         r(i) = plot(attachedEdges{i}(:,1), attachedEdges{i}(:,2), 'color', 'r', 'linewidth', 2);pause(1) 
        v = [attachedEdges{i}(2,:) - attachedEdges{i}(1,:), 0];
        k = cross(vEdge/norm(vEdge),v/norm(v));
        angle(i) = atan2d(norm(cross(vEdge,v)), dot(vEdge,v));
        if k(3) < 0
            angle(i) = -angle(i);
        end
    end
    if orientation < 0
        nextEdge = attachedEdges{angle == max(angle)};
    else
        nextEdge = attachedEdges{angle == min(angle)};
    end
%         g(i) = plot(nextEdge(:,1), nextEdge(:,2), 'color', 'g', 'linewidth', 2);pause(1);delete(r);delete(g)
end
end