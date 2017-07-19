function [flag] = edge_checkCollision(vertices1,vertices2)
% Checks to see if two edges defined by corresponding endpoints in
% 'vertices1' and 'vertices2' are intersecting
vertices1 = vertices1';
vertices2 = vertices2';
line = [vertices1(:,2) - vertices1(:,1);0];
p1 = [vertices2(:,1) - vertices1(:,1);0];
p2 = [vertices2(:,2) - vertices1(:,1);0];

k1 = cross(line,p1);
k2 = cross(line,p2);

line = [vertices2(:,2) - vertices2(:,1);0];
p3 = [vertices1(:,1) - vertices2(:,1);0];
p4 = [vertices1(:,2) - vertices2(:,1);0];

k3 = cross(line,p3);
k4 = cross(line,p4);

if k1(3)*k2(3) < 0 && k3(3)*k4(3) < 0
    flag = true;
else
    flag = false;
end

end