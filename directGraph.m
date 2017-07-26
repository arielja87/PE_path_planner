function igraph = directGraph(g, n, ids, graph, igraph)
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

if ~isempty(graph(g).gv) && ~isempty(graph(n).gv)
    parent_holdovers = ids.backward_idx(child_in_both & ~ismember(ids.backward_idx,s) & ~merge_child);
    child_holdovers = ids.forward_idx(parent_holdovers);
    for ig = graph(g).ii;
        for in = graph(n).ii;
                m_vec = [];
                for i = 1:numel(m)
                    m_vec(i) = isequal(any(igraph(ig).b(ids.forward_idx == m(i))), igraph(in).b(m(i)));
                end
                s_vec = [];
                for i = 1:numel(s)
                    s_vec(i) = all(igraph(in).b(ids.backward_idx == s(i)) == igraph(ig).b(s(i)));
                end
                conditions = [all(m_vec);
                              all(s_vec);
                              isequal(igraph(ig).b(parent_holdovers), igraph(in).b(child_holdovers));
                              all(igraph(in).b(ids.backward_idx == 0) == 0)];
                if all(conditions)
                    igraph(ig).neighbors = [igraph(ig).neighbors in];
                    igraph(ig).neighborsCost = [igraph(ig).neighborsCost graph(g).neighborsCost(graph(g).neighbors == n)];
                end
        end
    end
elseif ~isempty(graph(g).gv)
    [igraph(graph(g).ii).neighbors] = deal([graph(n).ii]);
    [igraph(graph(g).ii).neighborsCost] = deal(graph(g).neighborsCost(graph(g).neighbors == n));   
end
end
