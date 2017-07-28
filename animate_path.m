function vp = animate_path(igraph, path, world, x)
% Animates the search path
path = [0 path];
for i = 1:numel(path)-1
    if i == 1
        vpath = igraph(path(i+1)).x - x;
        v_length = norm(vpath);
        path_dir = vpath/norm(vpath);
        for inc = 0:.1:round(v_length,2)
            vp = drawVisibility(x(1)+inc*path_dir(1), x(2)+inc*path_dir(2), {world.vertices}, .0000001, .005);
            pause(.005)
        end        
    else
        vpath = igraph(path(i+1)).x - igraph(path(i)).x;
        v_length = norm(vpath);
        path_dir = vpath/norm(vpath);
        for inc = 0:.1:round(v_length,2)
            vp = drawVisibility(igraph(path(i)).x(1)+inc*path_dir(1), igraph(path(i)).x(2)+inc*path_dir(2), {world.vertices}, .0000001, .005);
            pause(.005)
        end        
    end
end
end