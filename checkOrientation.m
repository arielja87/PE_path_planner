function orientation = checkOrientation(edge, regions, world)
% returns -1 if free space is to the left of the edge from the first point
% to the second, 1 if free space is to the right, and 0 if both sides of
% the edge are free
%     persistent h
    mp = midpoints({edge});
    lineDir = (edge(2,:) - edge(1,:))/norm(edge(2,:) - edge(1,:));
    orthoDir = lineDir*0.000001*[0 -1;1 0];
    p(1,:) = mp + orthoDir;
    p(2,:) = mp - orthoDir;
%     delete(h)
%     h = plot(p(:,1), p(:,2), 'k*');
    in = inpolygon(p(:,1), p(:,2), world.vertices(:,1), world.vertices(:,2));
    if sum(in) == 1
        p = p(in,:);
        v = [p - edge(1,:), 0];
        k = cross(v, [lineDir, 0]);
        if k(3) < 0 
            orientation = -1;
        else
            orientation = 1;   
        end
    elseif sum(in) == 2
        if ~all(cellfun('isempty',regions))
            p = freePoint(p, regions);
            v = [p - edge(1,:), 0];
            k = cross(v, [lineDir, 0]);
            if k(3) < 0 
                orientation = -1;
            else
                orientation = 1;   
            end   
        else
            orientation = -1;
        end
    else
        ME = MException('VerifyOutput:OutOfBounds', ...
        'First edge was not along boundary');
        throw(ME);
    end
end