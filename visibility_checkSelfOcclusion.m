function [flag]=visibility_checkSelfOcclusion(vertex,vertexPrev,vertexNext,x)
%checks for self occlusion between the point x and an ordered vertex by
%checking whether the line lies between the previous vertex and the next
%vertex
vertex = vertex';
vertexPrev = vertexPrev';
vertexNext = vertexNext';
x = x';
Vx = [(x-vertex)' 0];
Vn = [(vertexNext - vertex)' 0];
Vp = [(vertexPrev - vertex)' 0];
Kn = cross(Vx, Vn);
Kp = cross(Vx, Vp);
if round(Kn(3),1) >= 0 && round(Kp(3),1) <= 0
    flag = true;
else
    flag = false;
end
end