function [h, graph] = points2graph(points, regions, world)
s = struct('neighbors', [], 'neighborsCost', [], 'x', [], 'b', [], 'gv', []);
graph = repmat(s,length(points(:,1)),1);
n = 1;
h = zeros(1,numel(points)*2);
ci = 1:size(points,1);
for i = ci
    graph(i).x = points(i,:);
%     c = plot(points(i,1), points(i,2), 'r*', 'markersize', 10);
    x_edges = makeEdges(regions{i});
    in = edgeInOn(x_edges, world);
    n_neighbors = sum(in);
    c_dists = dist([points(i,:)' points(ci~=i,:)']);
    ids = [i ci(ci~=i)];
    [~,sorted_id] = sort(c_dists(1,:));
    ids = ids(sorted_id);
    n_linked = 0;
    checked_i = 1;
%     b = [];
    while n_linked < n_neighbors
        checked_i = checked_i + 1;
        nIdx = ids(checked_i);
        if sum(ismember(regions{i}, regions{nIdx}, 'rows')) == 2
%             b(n_linked+1) = plot(points(nIdx,1), points(nIdx,2), 'b.', 'markersize', 15);
            h(n) = line(points([i nIdx],1), points([i nIdx],2), [.2 .2], 'color', 'red', 'Visible', 'off');
            n=n+1;
            cost = norm(points(nIdx,:) - points(i,:));
            graph(i).neighbors = [graph(i).neighbors nIdx];
            graph(i).neighborsCost = [graph(i).neighborsCost cost];
            n_linked = n_linked+1;
        end
    end
%     pause(1)
%     delete(b)
%     delete(c)
end
h = h(h>0);
% set(h, 'Visible', 'on');drawnow;
end