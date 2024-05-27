function [path, visited] = iterPlan(wf, startXY, omap)
%PLANNER Plan path on occupancy matrix
cX = startXY(1,1);
cY = startXY(1,2);

step=0;
% find closest non nan cell to startXY
while((isnan(wf(cX, cY)) || wf(cX,cY) == 0) && step < numel(wf))
    if(cX - 1 >= 1)
        cX = cX - 1;
        step = step+1;
    else
        cX = height(wf);
        if(cY - 1 >= 1)
            cY = cY - 1;
            step = step+1;
        else
            cY = width(wf);
            step = step+1;
        end
    end
end

visited = double(isnan(wf)); % keep track of visited cells and number of visits
visited(visited == 1) = inf;
path = []; % coordinates of each cell visited
dir = [-1, 0]; % initial direction - could be anything
looping = true;
planner = plannerAStarGrid(omap);
planner.DiagonalSearch = 'off';

while(looping)
    visited(cX, cY) = visited(cX, cY) + 1;
    path = [path; [cX, cY, 0]];
    dir = findMaxNbrDT(wf, visited, [cX, cY], dir);

    if isnan(dir)
        for i = 1:height(path)-1
            btdir = findMaxNbrDT(wf, visited, path(height(path)-i,1:2), dir);
            if ~isnan(btdir)
                cXnew = path(end-i,1)+btdir(1);
                cYnew = path(end-i,2)+btdir(2);
                planned = plan(planner, [cX cY], [cXnew cYnew]);
                path(end,:) = [];
                planned(end,:) = [];
                for j=1:length(planned)
                    visited(planned(j,1), planned(j,2)) = visited(planned(j,1), planned(j,2)) + 1;
                end
                path = [path; planned, ones(length(planned),1)];
                cX = cXnew;
                cY = cYnew;
                break;
            end
            if i == height(path)-1
                looping = false;
            end
        end
    else
        cX = cX + dir(1);
        cY = cY + dir(2);
    end
end

end
%%

function nextDir = findMaxNbrDT(wf, visited, XY, prevDir)
% Define 4-connected neighbourhood
directions = [-1, 0; 1, 0; 0, -1; 0, 1];
if(~isnan(prevDir))
    directions = [prevDir; directions];
end
maxDT = -inf;
nextDir = NaN;

% Check all neighbours
for i = 1:length(directions)
    nextXY = XY + directions(i, :);

    % Check if next cell is within grid and not visited
    if nextXY(1) >= 1 && nextXY(1) <= size(wf, 1) && nextXY(2) >= 1 && nextXY(2) <= size(wf, 2) && ~visited(nextXY(1), nextXY(2))
        % Check if next cell has a higher distance transform
        if wf(nextXY(1), nextXY(2)) > maxDT
            nextDir = directions(i,:);
            maxDT = wf(nextXY(1), nextXY(2));
        end
    end
end

end