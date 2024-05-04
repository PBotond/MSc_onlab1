function [path] = planner(wf, startXY)
%PLANNER Plan path on occupancy matrix
cX = startXY(1,1);
cY = startXY(1,2);

step = 0;
while((isnan(wf(cX, cY)) || wf(cX,cY) == 0) && step < numel(wf))
    % find next non nan cell in matrix
    if(cX - 1 >= 1)
        cX = cX - 1;
        step = step+1;
    else
        cX = width(wf);
        if(cY - 1 >= 1)
            cY = cY - 1;
            step = step+1;
        else
            cY = height(wf);
            step = step+1;
        end
    end
end

startXY = [cX, cY];

visited = isnan(wf);
path = [];

[path, visited] = move(wf, startXY, path, visited, [-1, 0]);
end

%%

function [path2, visited2] = move(wf, XY, path, visited, dir)
[nbr, nextDir] = findMaxNbrDT(wf, visited, XY, dir);
visited(XY(1), XY(2)) = visited(XY(1), XY(2)) + 1;
path = [path; XY];
while ~isempty(nbr)
    [path, visited] = move(wf, nbr, path, visited, nextDir);
    visited(XY(1), XY(2)) = visited(XY(1), XY(2)) + 1;
    path = [path; XY];
    [nbr, nextDir] = findMaxNbrDT(wf, visited, XY, dir);
end

path2 = path;
visited2 = visited;

end

% visited: tárolja, hogy hányszor léptem az adott mezőre!

%%

function [nbr, nextDir] = findMaxNbrDT(wf, visited, XY, prevDir)
% Define 4-connected neighbourhood
directions = [prevDir;-1, 0; 1, 0; 0, -1; 0, 1];
maxDT = -inf;
nbr = [];
nextDir = prevDir;

% Check all neighbours
for i = 1:length(directions)
    nextXY = XY + directions(i, :);

    % Check if next cell is within grid and not visited
    if nextXY(1) >= 1 && nextXY(1) <= size(wf, 1) && nextXY(2) >= 1 && nextXY(2) <= size(wf, 2) && ~visited(nextXY(1), nextXY(2))
        % Check if next cell has a higher distance transform
        if wf(nextXY(1), nextXY(2)) > maxDT
            nbr = nextXY;
            nextDir = directions(i,:);
            maxDT = wf(nextXY(1), nextXY(2));
        end
    end
end

end