function vp = animate_path(igraph, path, world, x)
% Animates the search path
path = [0 path];
% k = 1;
hold on
for i = 1:numel(path)-1
    if i == 1
        vpath = igraph(path(i+1)).x - x;
        v_length = norm(vpath);
        path_dir = vpath/norm(vpath);
        for inc = 0:.1:round(v_length,2)
            vp = drawVisibility(x(1)+inc*path_dir(1), x(2)+inc*path_dir(2), {world.vertices}, .0000001, .005);
            pause(.004)
%             M(k) = getframe;
%             k = k+1;
        end        
    else
        vpath = igraph(path(i+1)).x - igraph(path(i)).x;
        v_length = norm(vpath);
        path_dir = vpath/norm(vpath);
        for inc = 0:.1:round(v_length,2)
            vp = drawVisibility(igraph(path(i)).x(1)+inc*path_dir(1), igraph(path(i)).x(2)+inc*path_dir(2), {world.vertices}, .0000001, .005);
            pause(.004)
%             M(k) = getframe;
%             k = k+1;            
        end        
    end
end
% v = VideoWriter('pathvid.mp4','MPEG-4');
% open(v);
% writeVideo(v, M);
% close(v);
end