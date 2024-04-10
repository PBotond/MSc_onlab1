%% Reset
clear;
clc;
close all;

%% Set parameters
randomMap = true;
randomSeed = 10;
mapHeightY = 100;
mapWidthX = 100;
numberOfObstacles = 250;
obstacleMaxSize = 6;

startXY = [1 1];

%% Generate map
if (~randomMap)
    rng(randomSeed,"twister");
end

omap = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles);

% Store map in matrix
omx = double(occupancyMatrix(omap));
omx(omx==1) = nan;

%% Wavefront algorythm
wf = wavefront(omx, startXY);

path = planner(wf, [mapHeightY, mapWidthX]);

%% Draw figure
fig = figure(1);
hm = heatmap(fig, wf);
hm.ColorbarVisible = false;
hm.NodeChildren(3).YDir='normal';
ax = axes;
line([0,0],[mapHeightY,mapWidthX]);
line( [mapHeightY,mapWidthX], [0,0]);
plot(path(:,2)-0.5, path(:,1)-0.5,'y','LineWidth',2);
ax.YLim = [0,height(wf)];
ax.XLim = [0, width(wf)];
ax.Color = 'none';
ax.XTick = [];
ax.YTick = [];