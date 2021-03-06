function v = custom_environment
% RANDOM_ENVIRONMENT allows a user to click points on a set of axes to 
% create polygonal environment
%% Draw axes and get click points
close all
clc
figure('Units', 'normalized', 'Position',[.55,.25,.4,.5],'Toolbar','none',...
                'MenuBar','none', 'name', 'Environment Builder', 'NumberTitle', 'off');
ax = axes('XLimMode', 'manual', 'YLimMode', 'manual');
set(ax, 'XLim', [-15 15], 'YLim', [-15 15]);
% axis square equal
hold on
disp('Left click to make points, right click to build the environment, and middle click to start over...')
edges = {};
i = 0;
while true
    i = i+1;
    [x, y, b] = ginput(1);
    p = [x,y];
    if i >= 4 && b == 3
        int = lineSegmentIntersect({vertices([end, 1],:)}, edges);
        xi = int.intMatrixX(int.intAdjacencyMatrix)';
        yi = int.intMatrixY(int.intAdjacencyMatrix)';
        intx = [xi yi];
        if any(intx(~ismember(intx, [vertices(end,:);vertices(1,:)], 'rows')))
            fprintf(['The last edge would intersect at least one of the other edges.\n' ...
                'Pick a new point or press the middle mouse button to start again.\n'])
            i = i-1;
        else
            edges{end+1} = [vertices(end,:);vertices(1,:)];
            plot(vertices([end, 1], 1), vertices([end, 1], 2), 'b');  
            break
        end
    elseif i < 4 && b ==3
        disp('Need moar points!')
    elseif b == 2
        cla
        clc
        disp('Left click to make points, right click to build the environment, and middle click to start over...')
        vertices = [];
        i = 0;
        edges = {};
    else
        if i > 2
            int = lineSegmentIntersect({[vertices(end,:); p]}, edges);
            xi = int.intMatrixX(int.intAdjacencyMatrix)';
            yi = int.intMatrixY(int.intAdjacencyMatrix)';
            intx = [xi yi];
            if any(intx(~ismember(intx, vertices(end,:), 'rows')))
                disp('Edges in the environment may not intersect. Pick a new point.')
                i = i-1;
            else
                vertices(i,:) = p;
                edges{i-1} = [vertices(i-1,:); p];
                plot(vertices(i-1:i,1), vertices(i-1:i,2), 'b');
                plot(x,y,'k.');
                disp(p);               
            end
        elseif i > 1  
            vertices(i,:) = p;
            edges{i-1} = [vertices(i-1,:); p];
            plot(vertices(i-1:i,1), vertices(i-1:i,2), 'b');
            plot(x,y,'k.');
            disp(p); 
        else
            vertices(i,:) = p;
            plot(x, y,'k.');
            disp(p); 
        end
    end
end
[v(:,1), v(:,2)] = poly2ccw(vertices(:,1), vertices(:,2));
clc
end