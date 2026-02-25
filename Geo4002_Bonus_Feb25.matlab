clear; clc;
tic

%  Load Mount Rainier Point Cloud

filename = 'Mt.Rainer_Bonus.laz';  

lasreader = lasFileReader(filename);
ptcloud   = readPointCloud(lasreader);

px = ptcloud.Location(:,1);
py = ptcloud.Location(:,2);
pz = ptcloud.Location(:,3);

% Fig 1
figure(1); clf
plot3(px, py, pz, '.')
grid on

% Fig 2
figure(2); clf
scatter(px, py, 5, pz, '.')
colorbar

% Fig 3
figure(3); clf
scatter3(px, py, pz, 5, pz, '.')
colorbar
grid on

% Fig 4
figure(4); clf
pcshow(ptcloud)

filename = 'MtRainer.output.tin.tif';
[a, r] = readgeoraster(filename);

x1 = r.XWorldLimits(1);
x2 = r.XWorldLimits(2);
dx = r.CellExtentInWorldX;
x  = (x1 + dx/2) : dx : (x2 - dx/2);

y1 = r.YWorldLimits(1);
y2 = r.YWorldLimits(2);
dy = r.CellExtentInWorldY;
y  = (y1 + dy/2) : dy : (y2 - dy/2);

 iNaNs=find(a==-9999);
  a(iNaNs)=NaN;
% Fig 5

figure(5)
clf
imagesc(x,y,a)
colorbar

toc