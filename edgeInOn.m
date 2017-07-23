function in = edgeInOn(edges, world)
% returns a list of region edges and an n-edges x 1 logical with ones where
% region edges are interior and zeros for edges that are on the environment
% boundary

d_threshold = .00001;
in = false(numel(edges),1);
for i = 1:numel(edges)
    mp = midpoint(1,edges{i}');
    lineDir = (edges{i}(2,:) - edges{i}(1,:))/norm(edges{i}(2,:) - edges{i}(1,:));
    orthoDir = lineDir*d_threshold*[0 -1;1 0];
    p(1,:) = mp + orthoDir;
    p(2,:) = mp - orthoDir;
%     h = plot(p(:,1), p(:,2), 'k*');%pause(2);delete(h);
    p_in = inpolygon(p(:,1), p(:,2), world.vertices(:,1), world.vertices(:,2));
    in(i) = all(p_in);
end
end