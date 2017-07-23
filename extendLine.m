function conservativeLine = extendLine(los, world)
minX = min(world.vertices(:,1));
maxX = max(world.vertices(:,1));
minY = min(world.vertices(:,2));
maxY = max(world.vertices(:,2));
worldSize = max([abs(maxX-minX) abs(maxY-minY)]);

v = (los(1,:)-los(2,:))/norm(los(1,:)-los(2,:))*worldSize(1);
extension = [los(1,:); los(1,:)+v];
[xi,yi] = polyxpoly(extension(:,1), extension(:,2), world.vertices(:,1), world.vertices(:,2));
xpoints = [xi yi];
xpoints = xpoints(~ismember(xpoints, los(1,:), 'rows'),:);
dists = pdist([los(1,:); xpoints]);
dists = dists(:,1:length(xpoints(:,1)));
[~, min_id] = min(dists);
nearestPoint = xpoints(min_id,:);
conservativeLine = [los(1,:) ; round(nearestPoint,5)];

end