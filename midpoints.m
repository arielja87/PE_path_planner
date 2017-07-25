function out = midpoints(lines)
out = zeros(numel(lines),2);
for i = 1:numel(lines)
    out(i,:) = midPoint([lines{i}(1,:) lines{i}(2,:)]);
end
end