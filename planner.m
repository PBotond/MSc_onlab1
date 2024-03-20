function [path] = planner(wf, goalXY, startXY)
%PLANNER Plan path on occupancy matrix
visited = zeros([width(wf), height(wf)]);
cX = startXY(1);
cY =startXY(2);

path = [cX, cY];
visited(cX, cY) = 1;
[path, visited] = move(wf, goalXY, cX, cY, path, visited)

end

%%

function [path2, visited2] = move(wf, goalXY, cX, cY, path, visited)

visited(cX, cY) = 1;
nbrs = [cX-1, cY; cX+1, cY; cX, cY-1; cX, cY+1];

hi_wf = 0;
hi_i = 0;

for(i = 1:4)
    if(nbrs(i,1) <= width(wf) && nbrs(i,1) > 0 && nbrs(i,2) <= height(wf) && nbrs(i,2) > 0 && ~(isnan(wf(nbrs(i,1), nbrs(i,2)))))
        if(visited(nbrs(i,1), nbrs(i,2)) == 0)
           if(hi_wf < wf(nbrs(i,1), nbrs(i,2)))
               hi_wf = wf(nbrs(i,1), nbrs(i,2));
               hi_i = i;
           end
        end
    end
end

if(hi_i ~= 0)
    path(end+1,:) = [nbrs(hi_i,1), nbrs(hi_i,2)];
    [path, visited] = move(wf, goalXY, nbrs(hi_i,1), nbrs(hi_i,2), path, visited);
end

path(end+1,:) = [cX, cY];

path2 = path;
visited2 = visited;

end