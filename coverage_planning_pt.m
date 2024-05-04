%% Reset
clear;
clc;
close all;

%% Set parameters
randomMap = true;
randomSeed = 10;
mapHeightY = 25;
mapWidthX = 20;
numberOfObstacles = 15;
obstacleMaxSize = 8;

startXY = [1 1];

%% Generate map
if (~randomMap)
    rng(randomSeed,"twister");
end

omap = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles);

% Store map in matrix
omx = double(occupancyMatrix(omap));
dt = bwdist(omx);
dt = round((1./dt).*10);
dt(dt==inf) = 0;
omx(omx==1) = nan;

%% Wavefront algorythm
wf = pathtransform(omx, startXY, dt);

path = planner(wf, [mapHeightY, mapWidthX]);

%% Draw figure
fig = figure(2);
hm = heatmap(fig, wf);
hm.ColorbarVisible = false;
hm.NodeChildren(3).YDir='normal';
ax = axes;
line([0,0],[mapHeightY,mapWidthX]);
line( [mapHeightY,mapWidthX], [0,0]);
plot(path(:,2)-0.5, path(:,1)-0.5,'y-.','LineWidth',2);
ax.YLim = [0,height(wf)];
ax.XLim = [0, width(wf)];
ax.Color = 'none';
ax.XTick = [];
ax.YTick = [];