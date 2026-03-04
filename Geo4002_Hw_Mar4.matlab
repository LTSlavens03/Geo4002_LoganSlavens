clear
clc

% Before DEM

filename_before = 'WabashRiver_2013_ground.tif';
[a_before, r_before] = readgeoraster(filename_before);

% After DEM

filename_after = 'WabashRiver_2017_ground_.tif';
[a_after, r_after] = readgeoraster(filename_after);

a_after(a_after == -9999) = NaN;
a_after = flipud(a_after);

x1 = r_before.XWorldLimits(1);
x2 = r_before.XWorldLimits(2);
dx = r_before.CellExtentInWorldX;
x = (x1+dx/2):dx:(x2-dx/2);

y1 = r_before.YWorldLimits(1);
y2 = r_before.YWorldLimits(2);
dy = r_before.CellExtentInWorldY;
y = (y1+dy/2):dy:(y2-dy/2);

a_before(a_before == -9999) = NaN;

a_before = flipud(a_before);

% figure before

figure(1)
clf
subplot(121)
imagesc(x,y,a_before)
colorbar
axis equal
axis xy
title('River before (2013)')
hold on
subplot(122)
imagesc(x,y,a_after)
colorbar
axis equal
axis xy
title('River After (2017)')

% Fig 2 : Co-registered DEMs

% load variable
[x1, y1, z1] = load_one_DEM('WabashRiver_2013_ground.tif');
[x2, y2, z2] = load_one_DEM('WabashRiver_2017_ground_.tif');

% y limits
ytop = min(max(y1), max(y2)); 
ybottom = max(min(y1), min(y2)); 

% x limits
xleft = max(min(x1), min(x2));
xright = min(max(x1), max(x2));

% indices
i1 = find(y1 < ytop & y1 > ybottom);
j1 = find(x1 < xright & x1 > xleft);

i2 = find(y2 < ytop & y2 > ybottom);
j2 = find(x2 < xright & x2 > xleft);

%

z1_smaller = z1(i1, j1);
z2_smaller = z2(i2, j2);

x_smaller = x1(j1);
y_smaller = y1(i1);

% Fig 2 : DEM Difference

z_difference = z2_smaller - z1_smaller;

figure(2)
clf
imagesc(x_smaller, y_smaller, z_difference)
axis xy
axis equal
colorbar
title('DEM Difference (After - Before)')
colormap(flipud(cpolar))  % flipped colormap like Figure 5c
caxis([-2,2])

% Function 

 function [x,y,a]=load_one_DEM(filename)
    %load the file
    [a,r]=readgeoraster(filename);

    % Make the x and y vectors for the DEM grid
    x1=r.XWorldLimits(1);
    x2=r.XWorldLimits(2);
    dx=r.CellExtentInWorldX;
    x=(x1+dx/2):dx:(x2-dx/2);

    y1=r.YWorldLimits(1);
    y2=r.YWorldLimits(2);
    dy=r.CellExtentInWorldY;
    y=(y1+dy/2):dy:(y2-dy/2);

    % find all the pseudo-NaNs and make them actual NaNs
    iNaNs=find(a==-9999);
    a(iNaNs)=NaN;

    % flip the image upside down so that it is a proper map
    a=flipud(a);
 end
