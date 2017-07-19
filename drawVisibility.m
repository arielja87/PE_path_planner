function out = drawVisibility(observer_x, observer_y, environment, epsilon, snap_distance) 
persistent p
persistent m
    %Make sure the selected point is in the environment
%     if ~in_environment( [observer_x observer_y] , environment , epsilon )
%         display('Selected points must be in the environment!');
% %         break;
%     end
    
    %Clear plot and form window with desired properties
%     clf; 
%     delete(h)
%     set(gcf,'position',[200 200 700 600]); 
% axis equal; axis off; axis([X_MIN X_MAX Y_MIN Y_MAX]); set(gca,'pos',[0 0 1 1]);

    %Plot environment
%     patch( environment{1}(:,1) , environment{1}(:,2) , 0.1*ones(1,length(environment{1}(:,1)) ) , ...
%            'w' , 'linewidth' , 1.5 , 'FaceColor' , [1 1 1] , 'faceAlpha', 1, 'EdgeColor', 'k');
%     for i = 2 : size(environment,2)
%         patch( environment{i}(:,1) , environment{i}(:,2) , 0.1*ones(1,length(environment{i}(:,1)) ) , ...
%                'k' , 'EdgeColor' , [0 0 0] , 'FaceColor' , [0.8 0.8 0.8] , 'linewidth' , 1.5, 'faceAlpha', 0 );
%     end

    
    %Plot observer
%     delete(m)
    delete(p)
    delete(m)
    m = plot3( observer_x , observer_y, 0.3, ...
           'o' , 'Markersize' , 7 , 'MarkerFaceColor' , 'k' );
    
    %Compute and plot visibility polygon    
    V{1} = visibility_polygon( [observer_x observer_y] , environment , epsilon , snap_distance );
%     delete(p)
    p = patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
           'r' , 'EdgeAlpha' , 0, 'FaceColor' , [.5 .9 .5], 'faceAlpha', .7);
%     h(4) = plot3( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
%            'b*' , 'Markersize' , 5 );
out = [m,p];
end
