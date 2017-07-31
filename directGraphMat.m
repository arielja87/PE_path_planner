function g_mat = directGraphMat(g, n, ids, ugraph, igraph, g_mat)
[s,m, merge_child] = splitMerge(ids);
child_in_both = ids.backward_idx>0;
parent_holdovers = ids.backward_idx(child_in_both & ~ismember(ids.backward_idx,s) & ~merge_child);
child_holdovers = ids.forward_idx(parent_holdovers);
ig = ugraph(g).ii;
in = ugraph(n).ii;
bg = vertcat(igraph(ig).b);
bn = vertcat(igraph(in).b);
if ~isempty(ugraph(n).gv) && ~isempty(ugraph(g).gv)
    % More or same number of gaps in child vp
    % Match child b matrices
    merged_b = zeros(size(bg,1),numel(m));
    for i = 1:numel(m)
        merged_b(:,i) = any(bg(:,ids.forward_idx == m(i))')';
    end
    bg_compare = [merged_b,...
        bg(:,ids.backward_idx(ismember(ids.backward_idx, s))),...
        zeros(size(bg,1),sum(ids.backward_idx == 0)),...
        bg(:,parent_holdovers)];
    
    num_s = sum(ismember(ids.backward_idx,s));
    split_b = zeros(size(bn,1),num_s);
    si = 1;
    for i = 1:numel(s)
        s_logi = ids.backward_idx == s(i);
        split_b(:,si:si + sum(s_logi) - 1) = bn(:,s_logi);
        si = si+sum(s_logi);
    end
    bn_compare = [bn(:,m),...
        split_b,...
        bn(:,ismember(ids.backward_idx, 0)),...
        bn(:,child_holdovers)];
    if size(bg_compare,1) <= size(bn_compare,1)
        [in_logi, ig_loc] = ismember(bn_compare, bg_compare, 'rows');
        g_mat(sub2ind(size(g_mat),ig(ig_loc(in_logi)), in(in_logi))) = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
    else
        [ig_logi, in_loc] = ismember(bg_compare, bn_compare, 'rows');
        g_mat(sub2ind(size(g_mat),ig(ig_logi),in(in_loc(ig_logi)))) = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
    end
elseif isempty(ugraph(n).gv)
    % Child vp has no gap edges 
    g_mat(ugraph(g).ii,ugraph(n).ii) = .0000001;
end