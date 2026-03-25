clear
clc
close all

% Load Data
filename1 = 'UT_Before2015.tif';
filename2 = 'UT_After2019.tif';

[x2015,y2015,DEM2015] = load_one_DEM(filename1);
[x2019,y2019,DEM2019] = load_one_DEM(filename2);

% Cropping
xleft   = max(min(x2015), min(x2019));
xright  = min(max(x2015), max(x2019));
ybottom = max(min(y2015), min(y2019));
ytop    = min(max(y2015), max(y2019));

i2015 = find(y2015 >= ybottom & y2015 <= ytop);
j2015 = find(x2015 >= xleft & x2015 <= xright);

i2019 = find(y2019 >= ybottom & y2019 <= ytop);
j2019 = find(x2019 >= xleft & x2019 <= xright);

DEM2015_clip = DEM2015(i2015,j2015);
DEM2019_clip = DEM2019(i2019,j2019);

x_clip = x2015(j2015);
y_clip = y2015(i2015);

% my code ran great and produced my figures, but I kept having an error
% so copilot made/corrected this and it removed my error.
res2019 = x2019(2) - x2019(1);
res2015 = x2015(2) - x2015(1);

% This is subtracting the second element from the first, you get the grid spacing of each DEM in meters.
%  it tells you how "fine" each DEM is so smaller numbers = higher resolution.

coarsenFactor = round(res2015 / res2019);

% This calculates how many 2019 pixels fit inside one 2015 pixel.

DEM2019_coarse = blockproc(DEM2019_clip, [coarsenFactor coarsenFactor], ...
    @(block) max(block.data, [], 'all', 'omitnan'));

% This reduces the resolution of 2019 to roughly match 2015, while keeping the tallest features.

DEM2015_resized = imresize(DEM2015_clip, size(DEM2019_coarse), 'bilinear');

% This ensures both DEMs can be subtracted directly without dimension errors.

x_coarse = linspace(x_clip(1), x_clip(end), size(DEM2019_coarse,2));
y_coarse = linspace(y_clip(1), y_clip(end), size(DEM2019_coarse,1));

% This makes coordinate vectors that match the coarsened/resized DEMs.

% 2015 and 2019 map
hs2015 = hillshade(DEM2015_resized, x_coarse, y_coarse);
hs2019 = hillshade(DEM2019_coarse, x_coarse, y_coarse);

figure;
imagesc(x_coarse, y_coarse, hs2015)
axis xy equal tight
colormap(gray)
title('2015 Hillshade (Before)')
xlabel('Easting (m)')
ylabel('Northing (m)')

figure;
imagesc(x_coarse, y_coarse, hs2019)
axis xy equal tight
colormap(gray)
title('2019 Hillshade (After)')
xlabel('Easting (m)')
ylabel('Northing (m)')

% 2019 - 2015 Map

deltaZ = DEM2019_coarse - DEM2015_resized;

threshold = 0.5; % meters
deltaZ_filtered = deltaZ;
deltaZ_filtered(abs(deltaZ) < threshold) = NaN;

figure;
imagesc(x_coarse, y_coarse, deltaZ_filtered)
axis xy equal tight
colorbar
colormap(cpolar)

caxis([-5 5])

title('Elevation Change (2019 - 2015)')
xlabel('Easting (m)')
ylabel('Northing (m)')

% Funtions

function [x,y,a]=load_one_DEM(filename)
    [a,r]=readgeoraster(filename);

    x1=r.XWorldLimits(1);
    x2=r.XWorldLimits(2);
    dx=r.CellExtentInWorldX;
    x=(x1+dx/2):dx:(x2-dx/2);

    y1=r.YWorldLimits(1);
    y2=r.YWorldLimits(2);
    dy=r.CellExtentInWorldY;
    y=(y1+dy/2):dy:(y2-dy/2);

    a(a==-9999)=NaN;
    a=flipud(a);
end

function hs = hillshade(Z, x, y)
    [fx, fy] = gradient(Z, x, y);

    slope = atan(sqrt(fx.^2 + fy.^2));
    aspect = atan2(fy, -fx);

    az = deg2rad(315);
    alt = deg2rad(45);

    hs = sin(alt).*cos(slope) + ...
         cos(alt).*sin(slope).*cos(az - aspect);

    hs = max(hs, 0);
end

function c=cpolar(m)
    if nargin<1, m=size(get(gcf,'colormap'),1); end
    if mod(m,2)==0, m=m+1; end
    CR=[linspace(0,1,(m-1)/2+1),ones(1,(m-1)/2)]';
    CB=flipud(CR);
    CG=[linspace(0,1,(m-1)/2+1)]';
    CG=[CG; flipud(CG(1:(m-1)/2))];
    c=[CR,CG,CB];
end