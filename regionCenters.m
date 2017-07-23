function points = regionCenters(regions)
points = zeros(numel(regions),2);
for i = 1:numel(regions)
    points(i,:) = mean(regions{i});
end
end