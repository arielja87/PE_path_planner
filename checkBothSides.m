function clear = checkBothSides(line, world)
testPoints = createTestPoints(line);
[in, on] = inpolygon(testPoints(:,1), testPoints(:,2), world.vertices(:,1), world.vertices(:,2));
clear = ~any([~in; on]);
end