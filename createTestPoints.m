function points = createTestPoints(line)
mp = midpoint(1,line');
v1 = 1.005*(line(1,:) - mp);
v2 = 1.005*(line(2,:) - mp);
points = [v1;v2]+[mp; mp];
end
