function out = midpoints(lines)
out = zeros(numel(lines),2);
for i = 1:numel(lines)
    out(i,:) = midpoint(1,lines{i}');
end
end