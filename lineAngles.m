function angles = lineAngles(lines)
% outputs a vector of angles measured from the positive x-axis
% corresponding to the line inputs

v1 = [1 0 0];
for i = 1:numel(lines)
 
    v2 = [lines{i}(2,:) - lines{i}(1,:) 0];
    k = cross(v1/norm(v1),v2/norm(v2));
    angles(i) = atan2d(norm(cross(v2,v1)), dot(v2,v1));
    if k(3) < 0
        angles(i) = -angles(i);
    end    
end

end