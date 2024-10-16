%% Reset
clc;
clear all;
close all;

%% Set parameters
doPT = false; %false = only distance transform
drawFigure = false;
startXY = [1 1];
smartBackTrack = true;

iter = 1;
data = [];
while height(data)<200
    iter = iter+1;

    randomSeed = iter;

    mapHeightY = 15;
    mapWidthX = 15;
    numberOfObstacles = 4;
    obstacleMaxSize = 7;
    %% Generate map
    rng(randomSeed,"twister");

    omap = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles);

    %% Path planning
    [freeCells, pathLength, num90s, num180s, pathPerc] = fullPlan(doPT, drawFigure, startXY, omap, smartBackTrack);
    if ~isnan(pathLength)
        data = [data; freeCells, pathLength, num90s, num180s, pathPerc];
    end
end