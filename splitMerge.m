function [s,m, merge_child] = splitMerge(ids)
% s: index of split gap edge in parent 
% m: index of merged gap edge in child

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
    
end