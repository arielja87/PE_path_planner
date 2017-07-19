function gapEdges = findGapEdges(vpEdges, x, world)
% compares the edges in vp with the edges in the world to determine gap
% edges

[vpEdges, in] = edgeInOn(vpEdges, world);
gapEdges = vpEdges(in);
for i = 1:numel(gapEdges)
    if norm(gapEdges{i}(2,:) - x) < norm(gapEdges{i}(1,:) - x)
        gapEdges{i} = flipud(gapEdges{i});
    end
end

gapEdges = cellfun(@(x) round(x,4), gapEdges, 'UniformOutput', false);

end