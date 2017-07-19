function ksign = checkCross(edge1, edge2)
v1 = [edge1(2,:) - edge1(1,:) 0];
v2 = [edge2(2,:) - edge2(1,:) 0];
k = cross(v1, v2);
ksign = sign(k(3));
end