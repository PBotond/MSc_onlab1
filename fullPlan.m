function [freeCells, pathLength, num90s, num180s, pathPerc] = fullPlan(doPT, drawFigure, startXY, omap,  smartBackTrack)
% Store map in matrix
omx = double(occupancyMatrix(omap));
if (doPT == true)
    dt = bwdist(omx);
    dt(dt>4) = NaN;
    dt(dt==0) = NaN;
    dt = 4 -dt;
    dt = round(dt);
    dt(isnan(dt)) = 0;
    dt = dt.^(2);
end

omx(omx==1) = nan;

%% Wavefront algorythm
if (doPT == false)
    wf = wavefront(omx, startXY);
else
    wf = pathtransform(omx, startXY, dt);
    %wf = wavefront(omx, startXY) + dt;
end

if min(min(wf)) == 0
    disp("Bad map");
    freeCells = NaN;
    pathLength = NaN;
    num90s = NaN;
    num180s = NaN;
    pathPerc = NaN;
    return;
end
%% Path planning
%path = planner(wf, [height(omx), width(omx)]);
if ~smartBackTrack
    [path, visited] = iterPlan(wf, [height(omx), width(omx)], omap);
else
    [path, visited] = iterPlan2(wf, [height(omx), width(omx)], omap, omx);
end
%% Path metrics
freeCells = length(omx(omx==0));
pathLength = length(path);
pathPerc = pathLength/freeCells*100;
num90s = 0;
num180s = 0;
for j=2:length(path)-1
   if path(j-1, 1) == path(j+1,1) && path(j-1,2) == path(j+1, 2)
       num180s = num180s+1;
   elseif path(j-1, 1) ~= path(j+1,1) && path(j-1,2) ~= path(j+1, 2)
       num90s = num90s+1;
   end
end

%% Draw figure
if drawFigure
    fig = figure();
    hm = heatmap(fig, wf);
    s=struct(hm);
    s.XAxis.Visible='off';
    s.YAxis.Visible='off';
    hm.ColorbarVisible = false;
    hm.NodeChildren(3).YDir='normal';
    ax = axes;
    line([0,0],[height(omx), width(omx)]);
    line( [height(omx), width(omx)], [0,0]);
    hold on
    for i=1:length(path)-1
        if path(i, 3) == 1
            quiver(ax, path(i,2)-0.65, path(i,1)-0.65, path(i+1,2)-path(i,2), path(i+1,1)-path(i,1),0.8,'m-','LineWidth', 2,'MaxHeadSize','5');
        else
            quiver(ax, path(i,2)-0.5, path(i,1)-0.5, path(i+1,2)-path(i,2), path(i+1,1)-path(i,1),0.8,'y','LineWidth', 2,'MaxHeadSize','5');
        end
    end
    plot(path(1,2)-0.5, path(1,1)-0.5, 'go', 'MarkerSize', 20, 'LineWidth', 2);
    plot(path(end,2)-0.5, path(end,1)-0.5, 'ro', 'MarkerSize', 20, 'LineWidth', 2);

    hold off
    ax.YLim = [0,height(wf)];
    ax.XLim = [0, width(wf)];
    ax.Color = 'none';
    ax.XTick = [];
    ax.YTick = [];
    fontname("Times New Roman");

    set (gca,'Position',[0 0 1 1]);
    hm.InnerPosition = [0 0 1 1];
end

