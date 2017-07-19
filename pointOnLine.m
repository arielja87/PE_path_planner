function flags = pointOnLine(points, line)
% Takes Npoints x 2 matrix of points, returns Npoints x 1 logical of points that are on the line    
v1 = line(2,:) - line(1,:);
v2 = v1*[0 1;-1 0];   
flags = false(numel(points(:,1)),1);
for i = 1:length(flags)
    vp = points(i,:) - line(1,:);
    vj = points(i,:) - line(2,:);
    dp1 = dot(v1,vp)/norm(v1)^2;
    dp2 = dot(v2,vp);
    if (0 < dp1) && (dp1 < 1) && norm(vp) > .0005 && norm(vj) > .0005 
        if round(dp2,3) == 0 
            flags(i) = 1;
        end
    end
end
end