%% Reset
clc;
close all;

%% Set parameters
doPT = false; %false = only distance transform
drawFigure = true;
startXY = [1 1];
smartBackTrack = false;

newMap = false;
randomMap = true;
randomSeed = 10;

mapHeightY = 12;
mapWidthX = 12;
numberOfObstacles = 1;
obstacleMaxSize = 5;
%% Generate map
if (~randomMap)
    rng(randomSeed,"twister");
end
if newMap
    omap = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles);
end

%% Path planning
[freeCells, pathLength, num90s, num180s, pathPerc] = fullPlan(doPT, drawFigure, startXY, omap, smartBackTrack)