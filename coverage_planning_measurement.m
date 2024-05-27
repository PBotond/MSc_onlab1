%% Reset
clc;
close all;

%% Set parameters
doPT = false; %false = only distance transform
drawFigure = true;
startXY = [1 1];
smartBackTrack = true;

newMap = false;
randomMap = true;
randomSeed = 10;

mapHeightY = 50;
mapWidthX = 50;
numberOfObstacles = 18;
obstacleMaxSize = 4;
%% Generate map
if (~randomMap)
    rng(randomSeed,"twister");
end
if newMap
    omap = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles);
end

%% Path planning
[pathLength, num90s, num180s, pathPerc] = fullPlan(doPT, drawFigure, startXY, omap, smartBackTrack)