function [wf] = wavefront(omx, goalXY)
%% Run a wavefront through an occupancy matrix

cX = goalXY(1,1);
cY = goalXY(1,2);

if(isnan(omx(cX, cY)))
    disp("Starting point obstructed.")
    wf = omx;
    return;
end

dist = 1;
omx(cX, cY) = dist;
wf = propagateWf(omx, cX, cY, dist);

end

%%

function [wf] = propagateWf(omx, cX, cY, dist)
nbrs = [cX-1, cY; cX+1, cY; cX, cY-1; cX, cY+1];

for i = 1:4
    if(nbrs(i,1) <= height(omx) && nbrs(i,1) > 0 && nbrs(i,2) <= width(omx) && nbrs(i,2) > 0)
        if(omx(nbrs(i,1), nbrs(i,2)) == 0 || omx(nbrs(i,1), nbrs(i,2)) > dist+1)
            omx(nbrs(i,1), nbrs(i,2)) = dist+1;
            omx = propagateWf(omx, nbrs(i,1), nbrs(i,2), dist+1);
        end
    end
end
wf = omx;

end