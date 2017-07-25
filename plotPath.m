function handles = plotPath(path, igraph, x)
x = [x; reshape([igraph(path).x]',2, numel(path))'];
handles = plot(x(:,1), x(:,2), 'LineStyle', '--', 'Color', [.1 0 .9], 'LineWidth', 2);
end