function points = regionCenters(regions)
for i = 1:numel(regions)
    points(i,:) = mean(regions{i});
end
end