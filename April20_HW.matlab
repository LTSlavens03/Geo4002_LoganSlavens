clear, clc

% Load

fileA = 'S1-GUNW-A-R-064-tops-20190710_20190628-015013-36885N_35006N-PP-a1b9-v2_0_2.nc';

A1.x = ncread(fileA,'/science/grids/data/longitude');
A1.y = flipud(ncread(fileA,'/science/grids/data/latitude'));
A1.u = flipud(ncread(fileA,'/science/grids/data/unwrappedPhase')');
A1.c = flipud(ncread(fileA,'/science/grids/data/coherence')');
A1.m = flipud(ncread(fileA,'/science/grids/data/connectedComponents')');
A1.a = flipud(ncread(fileA,'/science/grids/data/amplitude')');
A1.L = ncread(fileA,'/science/radarMetaData/wavelength');
A1.w = mod(A1.u,2*pi);

%

x1 = -118.3;
x2 = -117.0;
y1 = 35.2;
y2 = 36.3;

% indices
[~,A1.ix1] = min(abs(A1.x - x1));
[~,A1.ix2] = min(abs(A1.x - x2));
[~,A1.iy1] = min(abs(A1.y - y1));
[~,A1.iy2] = min(abs(A1.y - y2));

%

ObsA.u = A1.u(A1.iy1:A1.iy2, A1.ix1:A1.ix2);
ObsA.c = A1.c(A1.iy1:A1.iy2, A1.ix1:A1.ix2);
ObsA.m = A1.m(A1.iy1:A1.iy2, A1.ix1:A1.ix2);
ObsA.a = A1.a(A1.iy1:A1.iy2, A1.ix1:A1.ix2);
ObsA.w = A1.w(A1.iy1:A1.iy2, A1.ix1:A1.ix2);

ObsA.LOS = ObsA.u * A1.L / (4*pi);

% MODEL PARAMETERS

x0 = -117.5;
y0 = 35.7;

STRIKE = 250;
DIP = 85;

DEPTH = 10;
LENGTH = 42.5;
WIDTH = 13.75;

RAKE = 100;
SLIP = 5;
OPEN = 0;

%

xA = A1.x(A1.ix1:A1.ix2);
yA = A1.y(A1.iy1:A1.iy2);

[xmeshA, ymeshA] = meshgrid(xA, yA);

ymeshA_km = (ymeshA - y0) * 111.1;
xmeshA_km = (xmeshA - x0) * 111.1 .* cosd(y0);

%

[EA, NA, ZA] = okada85(xmeshA_km, ymeshA_km, DEPTH, STRIKE, DIP, LENGTH, WIDTH, RAKE, SLIP, OPEN);

%

IncAngle = 39;
HeadAngle_ascending = -10;

px = -sind(IncAngle) * cosd(HeadAngle_ascending);
py =  sind(IncAngle) * sind(HeadAngle_ascending);
pz =  cosd(IncAngle);

Model.LOS_ascending = EA*px + NA*py + ZA*pz;

Model.w_ascending = mod(Model.LOS_ascending / A1.L * 4*pi, 2*pi);

% Nans & RMS

MisA.LOS = ObsA.LOS - Model.LOS_ascending;
MisA.w   = mod(MisA.LOS / A1.L * 4*pi, 2*pi);
MisA.RMS = rms(MisA.LOS(:), 'omitnan');

disp(['ASCENDING RMS = ', num2str(MisA.RMS), ' m'])

% PLOTS

figure(1), clf

subplot(231)
imagesc(xA, yA, ObsA.w), axis xy
colorbar
title('Observed wrapped phase')

subplot(232)
imagesc(xA, yA, ObsA.LOS), axis xy
colorbar
title('Observed LOS (m)')

subplot(233)
imagesc(xA, yA, Model.w_ascending), axis xy
colorbar
title('Modeled wrapped phase')

subplot(234)
imagesc(xA, yA, Model.LOS_ascending), axis xy
colorbar
title('Modeled LOS (m)')

subplot(235)
imagesc(xA, yA, MisA.w), axis xy
colorbar
title('Misfit wrapped phase')

subplot(236)
imagesc(xA, yA, MisA.LOS), axis xy
colorbar
title(['Misfit LOS (m), RMS = ', num2str(MisA.RMS)])

colormap(jet)