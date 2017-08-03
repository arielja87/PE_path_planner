function out = drawVisibility(observer_x, observer_y, environment, epsilon, snap_distance) 
persistent p
persistent m

delete(p)
delete(m)
m = plot3( observer_x , observer_y, 0.3, ...
       'o' , 'Markersize' , 7 , 'MarkerFaceColor' , 'k' );

%Compute and plot visibility polygon    
V{1} = visibility_polygon( [observer_x observer_y] , environment , epsilon , snap_distance );
p = patch( V{1}(:,1) , V{1}(:,2) , 0.1*ones( size(V{1},1) , 1 ) , ...
       'r' , 'EdgeAlpha' , 0, 'FaceColor' , [.5 .9 .5], 'faceAlpha', .7);
out = [m,p];
end
