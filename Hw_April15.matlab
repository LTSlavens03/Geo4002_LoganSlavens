format compact
clear, clc

% Load

% South
filenameS='S1-GUNW-D-R-021-tops-20230210_20230129-033504-00035E_00035N-PP-8473-v2_0_6.nc';

xS = ncread(filenameS,'/science/grids/data/longitude');
yS = flipud(ncread(filenameS,'/science/grids/data/latitude'));
AS = flipud(ncread(filenameS,'/science/grids/data/amplitude')');
CS = flipud(ncread(filenameS,'/science/grids/data/coherence')');
US = flipud(ncread(filenameS,'/science/grids/data/unwrappedPhase')');

WS = mod(US,2*pi);

% North
filenameN='S1-GUNW-D-R-021-tops-20230210_20230117-033440-00036E_00037N-PP-3514-v2_0_6.nc';

xN = ncread(filenameN,'/science/grids/data/longitude');
yN = flipud(ncread(filenameN,'/science/grids/data/latitude'));
AN = flipud(ncread(filenameN,'/science/grids/data/amplitude')');
CN = flipud(ncread(filenameN,'/science/grids/data/coherence')');
UN = flipud(ncread(filenameN,'/science/grids/data/unwrappedPhase')');

WN = mod(UN,2*pi);

%Plot

figure(1), clf
ax1(1)=subplot(2,2,1);
imagesc(xS,yS,WS,'alphadata',~isnan(US))
axis xy
colorbar
title('South Wrapped Phase')

ax1(2)=subplot(2,2,2);
imagesc(xN,yN,WN,'alphadata',~isnan(UN))
axis xy
colorbar
title('North Wrapped Phase')

ax1(3)=subplot(2,2,3);
imagesc(xS,yS,US,'alphadata',~isnan(US))
axis xy
colorbar
title('South Unwrapped Phase')

ax1(4)=subplot(2,2,4);
imagesc(xN,yN,UN,'alphadata',~isnan(UN))
axis xy
colorbar
title('North Unwrapped Phase')

linkaxes(ax1,'xy')
colormap(jet)

% Cut

x1 = min([min(xS) min(xN)]);
x2 = max([max(xS) max(xN)]);
y1 = min([min(yS) min(yN)]);
y2 = max([max(yS) max(yN)]);

x1 = x1 + 0.02;
x2 = x2 - 0.02;
y1 = y1 + 0.02;
y2 = y2 - 0.02;

[~,ix1S]=min(abs(xS-x1));
[~,ix2S]=min(abs(xS-x2));
[~,iy1S]=min(abs(yS-y1));
[~,iy2S]=min(abs(yS-y2));

[~,ix1N]=min(abs(xN-x1));
[~,ix2N]=min(abs(xN-x2));
[~,iy1N]=min(abs(yN-y1));
[~,iy2N]=min(abs(yN-y2));

S.u = US(iy1S:iy2S, ix1S:ix2S);
S.w = WS(iy1S:iy2S, ix1S:ix2S);
S.c = CS(iy1S:iy2S, ix1S:ix2S);
S.a = AS(iy1S:iy2S, ix1S:ix2S);
S.x = xS(ix1S:ix2S);
S.y = yS(iy1S:iy2S);

N.u = UN(iy1N:iy2N, ix1N:ix2N);
N.w = WN(iy1N:iy2N, ix1N:ix2N);
N.c = CN(iy1N:iy2N, ix1N:ix2N);
N.a = AN(iy1N:iy2N, ix1N:ix2N);
N.x = xN(ix1N:ix2N);
N.y = yN(iy1N:iy2N);

nrows = min(size(S.u,1), size(N.u,1));
ncols = min(size(S.u,2), size(N.u,2));

S.u = S.u(1:nrows, 1:ncols);
S.w = S.w(1:nrows, 1:ncols);
S.c = S.c(1:nrows, 1:ncols);
S.a = S.a(1:nrows, 1:ncols);

N.u = N.u(1:nrows, 1:ncols);
N.w = N.w(1:nrows, 1:ncols);
N.c = N.c(1:nrows, 1:ncols);
N.a = N.a(1:nrows, 1:ncols);

S.x = S.x(1:ncols);
S.y = S.y(1:nrows);

N.x = N.x(1:ncols);
N.y = N.y(1:nrows);

% Plot

figure(2), clf
ax2(1)=subplot(2,2,1);
imagesc(S.x,S.y,S.w,'alphadata',~isnan(S.u))
axis xy
colorbar
title('South Cut Wrapped')

ax2(2)=subplot(2,2,2);
imagesc(N.x,N.y,N.w,'alphadata',~isnan(N.u))
axis xy
colorbar
title('North Cut Wrapped')

ax2(3)=subplot(2,2,3);
imagesc(S.x,S.y,S.u,'alphadata',~isnan(S.u))
axis xy
colorbar
title('South Cut Unwrapped')

ax2(4)=subplot(2,2,4);
imagesc(N.x,N.y,N.u,'alphadata',~isnan(N.u))
axis xy
colorbar
title('North Cut Unwrapped')

linkaxes(ax2,'xy')
colormap(jet)

% P1 

Stack.u = (S.u + N.u) / 2;
Stack.w = mod(Stack.u, 2*pi);

Stack.x = S.x;
Stack.y = S.y;

figure(3), clf
ax3(1)=subplot(1,2,1);
imagesc(Stack.x,Stack.y,Stack.w,'alphadata',~isnan(Stack.u))
axis xy
colorbar
title('STACKED Wrapped Phase (Average)')

ax3(2)=subplot(1,2,2);
imagesc(Stack.x,Stack.y,Stack.u,'alphadata',~isnan(Stack.u))
axis xy
colorbar
title('STACKED Unwrapped Phase (Average)')

linkaxes(ax3,'xy')
colormap(jet)

% P2

DiffS.u = S.u - Stack.u;
DiffN.u = N.u - Stack.u;

DiffS.w = mod(DiffS.u, 2*pi);
DiffN.w = mod(DiffN.u, 2*pi);

figure(4), clf
ax4(1)=subplot(2,2,1);
imagesc(Stack.x,Stack.y,DiffS.w,'alphadata',~isnan(DiffS.u))
axis xy
colorbar
title('South - Stack (Wrapped)')

ax4(2)=subplot(2,2,2);
imagesc(Stack.x,Stack.y,DiffN.w,'alphadata',~isnan(DiffN.u))
axis xy
colorbar
title('North - Stack (Wrapped)')

ax4(3)=subplot(2,2,3);
imagesc(Stack.x,Stack.y,DiffS.u,'alphadata',~isnan(DiffS.u))
axis xy
colorbar
title('South - Stack (Unwrapped)')

ax4(4)=subplot(2,2,4);
imagesc(Stack.x,Stack.y,DiffN.u,'alphadata',~isnan(DiffN.u))
axis xy
colorbar
title('North - Stack (Unwrapped)')

linkaxes(ax4,'xy')
colormap(jet)