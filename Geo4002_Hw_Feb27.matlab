clear
clc
format compact
tic

% Before DEM

filename_before = 'ridgecrest_before.tif';
[a_before, r_before] = readgeoraster(filename_before);

% After DEM

filename_after = 'ridgecrest_after.tif';
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
imagesc(x,y,a_before)
colorbar
axis equal
axis xy
title('Ridgecrest BEFORE Earthquake')

% figure after

figure(2)
clf
imagesc(x,y,a_after)
colorbar
axis equal
axis xy
title('Ridgecrest AFTER Earthquake')

% Subtract after - before

difference = a_after - a_before;

% plot the different together

figure(3)
clf
imagesc(x,y,difference)
colorbar
axis equal
axis xy
title('Elevation Change (After - Before)')
colormap(cpolar)

function c = cpolar(m)

if nargin < 1, m = size(get(gcf,'colormap'),1); end

if mod(m,2)==0, m=m+1; end

  CR=[linspace(0,1,(m-1)/2+1),ones(1,(m-1)/2)]';
  
  CB=flipud(CR);
  CG=[linspace(0,1,(m-1)/2+1)]';CG=[CG;flipud(CG(1:(m-1)/2))];
  c=[CR,CG,CB];

end

toc