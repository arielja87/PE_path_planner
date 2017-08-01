function di_graph = directGraphMat(igraph, ugraph, world)
%% Main loop: construct neighbors within information graph according to the following rules:
% 1. a gap-edge disappears, do nothing;
% 2. a gap-edge appears, assign it a zero; 
% 3. two or more gap-edges merge into one, if any of them had a one label, assign a one to the new edge;
% 4. a gap-edge divides into multiple gap-edges, assign the new edges the same label as the original;

n_edges = numel([ugraph([igraph.i]).neighbors]);
try
    g_mat = zeros(2,n_edges, 'uint32');
%     g_mat = zeros(numel(igraph), 'single');
catch
    fprintf(['Unfortunately, there are too many gap edges at the nodes in the undirected graph.\n'...
        'The information graph would require too much RAM to build.\n']);
    input('Press "Enter" to go back to the start...');
    PEpath
    return
end

weights = zeros(1,n_edges, 'single');
edge_idx = 1;    
for g = 1:numel(ugraph)
    for n = ugraph(g).neighbors
        ids = examineTransition(g, n, ugraph, world);
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
                edge_idx = edge_idx:(edge_idx + sum(in_logi) - 1);
                weights(edge_idx) = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
                g_mat(:,edge_idx) = [ig(ig_loc(in_logi)); in(in_logi)];
                edge_idx = edge_idx(end)+1;
%                 g_mat(sub2ind(size(g_mat),ig(ig_loc(in_logi)), in(in_logi))) = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
            else
                [ig_logi, in_loc] = ismember(bg_compare, bn_compare, 'rows');
                edge_idx = edge_idx:(edge_idx + sum(ig_logi) - 1);
                weights(edge_idx) = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
                g_mat(:,edge_idx) = [ig(ig_logi); in(in_loc(ig_logi))];
                edge_idx = edge_idx(end)+1;
%                 g_mat(sub2ind(size(g_mat),ig(ig_logi),in(in_loc(ig_logi)))) = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
            end
        elseif isempty(ugraph(n).gv)
            % Child vp has no gap edges 
            src_cell =  arrayfun(@(x) repmat(x,1,numel(in)), ig, 'UniformOutput', false);
            tgt = repmat(in,1,numel(src_cell));
            ig_in = [[src_cell{:}];tgt];
            edge_idx = edge_idx:(edge_idx + sum(size(ig_in,2)) - 1);
            weights(edge_idx) = ugraph(g).neighborsCost(ugraph(g).neighbors == n);
            g_mat(:,edge_idx) = ig_in;
            edge_idx = edge_idx(end)+1;%             g_mat(ugraph(g).ii,ugraph(n).ii) = .0000001;
        end
    end
end
g_mat = g_mat(:,~ismember(g_mat',[0;0]', 'rows'));
weights = weights(weights>0);
di_graph = digraph(g_mat(1,:), g_mat(2,:), weights);
clear g_mat
end