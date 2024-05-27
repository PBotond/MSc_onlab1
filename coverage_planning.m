%% Reset
clc;
close all;

%% Set parameters
doPT = false; %false = only distance transform
drawFigure = false;
startXY = [1 1];
smartBackTrack = true;

iter = 1;
data = [];
while height(data)<100
    iter = iter+1;
    newMap = true;
    randomMap = false;
    randomSeed = iter;

    mapHeightY = 15;
    mapWidthX = 15;
    numberOfObstacles = 8;
    obstacleMaxSize = 4;
    %% Generate map
    if (~randomMap)
        rng(randomSeed,"twister");
    end
    if newMap
        omap = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles);
    end

    %% Path planning
    [freeCells, pathLength, num90s, num180s, pathPerc] = fullPlan(doPT, drawFigure, startXY, omap, smartBackTrack);
    if ~isnan(pathLength)
        data = [data; freeCells, pathLength, num90s, num180s, pathPerc];
    end
end