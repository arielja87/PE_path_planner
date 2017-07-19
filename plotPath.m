function handles = plotPath(path,igraph)
x = reshape([igraph(path).x]',2, numel(path))';
[handles{1}, handles{2}] = plot_dir(x(:,1),x(:,2));
handles = [handles{:}];
end