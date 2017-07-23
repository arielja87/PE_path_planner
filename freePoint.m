function out = freePoint(p, regions)
flag1 = false(numel(regions),1);
flag2 = false(numel(regions),1);
for i = 1:numel(regions)
    flag1(i) = inpolygon(p(1,1), p(1,2), regions{i}(:,1), regions{i}(:,2));
end
for i = 1:numel(regions)
    flag2(i) = inpolygon(p(2,1), p(2,2), regions{i}(:,1), regions{i}(:,2));
end
flag1 = any(flag1);
flag2 = any(flag2);
if ~any([flag1 flag2])
    out = p(1,:);
elseif all([flag1 flag2])
    ME = MException('VerifyOutput:OutOfBounds', ...
    'Error in freePoint, neither point was free');
    throw(ME);
elseif flag2
    out = p(1,:);
else
    out = p(2,:);
end