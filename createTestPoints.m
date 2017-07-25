function points = createTestPoints(line)
mp = midPoint([line(1,:) line(2,:)]);
v1 = 1.005*(line(1,:) - mp);
v2 = 1.005*(line(2,:) - mp);
points = [v1;v2]+[mp; mp];
end
