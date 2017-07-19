function h = plotIndeces(graph)
xs = reshape([graph.x]',2,numel(graph))';
h = text(xs(:,1), xs(:,2), num2str([1:length(xs(:,1))]'));
end