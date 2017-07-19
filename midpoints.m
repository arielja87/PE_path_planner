function out = midpoints(lines)
out = zeros(numel(lines),2);
for i = 1:numel(lines)
    out(i,:) = [mean([lines{i}(1,1), lines{i}(2,1)]) mean([lines{i}(1,2), lines{i}(2,2)])];
end
end