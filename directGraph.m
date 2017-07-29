function [igraph, g_mat] = directGraph(g, n, ids, ugraph, igraph, g_mat)
% connects the graph g according to the specified conditions
[a,b] = histc(ids.forward_idx,unique(ids.forward_idx));
m_occ = a(b);
m = ids.forward_idx(m_occ>1);
m = unique(m(m>0));
merge_child = false(1,numel(ids.backward_idx));
merge_child(m) = true;

[a,b] = histc(ids.backward_idx,unique(ids.backward_idx));
s_occ = a(b);
s = ids.backward_idx(s_occ>1);
s = unique(s(s>0));

% find holdover logicals: true in the parent for any gap that was not part
% of a merge, and true in the child for any gap that was not part of a
% split, where the gap is present in both visibility polygons

child_in_both = ids.backward_idx>0;

if ~isempty(ugraph(g).gv) && ~isempty(ugraph(n).gv)
    parent_holdovers = ids.backward_idx(child_in_both & ~ismember(ids.backward_idx,s) & ~merge_child);
    child_holdovers = ids.forward_idx(parent_holdovers);
    for ig = ugraph(g).ii
        for in = ugraph(n).ii
            m_vec = false(1,numel(m));
            for i = 1:numel(m)
                m_vec(i) = isequal(any(igraph(ig).b(ids.forward_idx == m(i))), igraph(in).b(m(i)));
            end
            s_vec = false(1,numel(s));
            for i = 1:numel(s)
                s_vec(i) = all(igraph(in).b(ids.backward_idx == s(i)) == igraph(ig).b(s(i)));
            end
%             g
%             ugraph(g).gv
%             n
%             ugraph(n).gv
            if all(m_vec) &&...
                            all(s_vec) &&...
                            isequal(igraph(ig).b(parent_holdovers), igraph(in).b(child_holdovers)) &&...
                            all(igraph(in).b(ids.backward_idx == 0) == 0)
%                 igraph(ig).neighbors = [igraph(ig).neighbors in];
%                 igraph(ig).neighborsCost = [igraph(ig).neighborsCost ugraph(g).neighborsCost(ugraph(g).neighbors == n)];
                n_dist = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
%                 cost = max(n_dist + sum(igraph(in).b)/n_dist - sum(~igraph(in).b)/n_dist, .000001);
%                 disp([ig in]);pause(1)
                g_mat(ig,in) = n_dist;
            end
        end
    end
elseif ~isempty(ugraph(g).gv)
%     [igraph(ugraph(g).ii).neighbors] = deal([ugraph(n).ii]);
%     [igraph(ugraph(g).ii).neighborsCost] = deal(ugraph(g).neighborsCost(ugraph(g).neighbors == n));
%     n_dist = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
    cost = .000001;
    g_mat(ugraph(g).ii,ugraph(n).ii) = cost;
end
end
