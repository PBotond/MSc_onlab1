%% Reset
clear;
clc;
close all;

%% Set parameters
randomMap = true;
randomSeed = 10;
mapWidth = 25;
mapLength = 20;
numberOfObstacles = 16;
obstacleMaxSize = 4;

startXY = [1 1];

%% Generate map
if (~randomMap)
    rng(randomSeed,"twister");
end

omap = create_map(mapLength, mapWidth, obstacleMaxSize, numberOfObstacles);

% Store map in matrix
omx = double(occupancyMatrix(omap));
omx(omx==1) = nan;

%% Wavefront algorythm
wf = wavefront(omx, startXY);

path = planner(wf, [1,1], [mapLength, mapWidth]);

%% Draw figure
fig = figure(1);
hm = heatmap(fig, wf);
hm.ColorbarVisible = false;
hm.NodeChildren(3).YDir='normal';
ax = axes;
line([0,0],[20,20]);
line( [20,20], [0,0]);
plot(path(:,1)-0.5, path(:,2)-0.5, 'r');
ax.YLim = [0,height(wf)];
ax.XLim = [0, width(wf)];
ax.Color = 'none';
ax.XTick = [];
ax.YTick = [];