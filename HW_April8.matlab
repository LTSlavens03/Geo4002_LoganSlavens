clear

% S = South, N = North, x = long, y = lat, A = Amp, C = Coh, U = Unwrap

% South interferogram (35E, 35N)
  filenameS='S1-GUNW-D-R-021-tops-20230210_20230129-033504-00035E_00035N-PP-8473-v2_0_6.nc';

  xS=ncread(filenameS,'/science/grids/data/longitude');
  yS=ncread(filenameS,'/science/grids/data/latitude');
  AS=ncread(filenameS,'/science/grids/data/amplitude')';
  CS=ncread(filenameS,'/science/grids/data/coherence')';
  US=ncread(filenameS,'/science/grids/data/unwrappedPhase')';


  WS=mod(US,2*pi);

  % North interferogram (36E, 37N)
  filenameN='S1-GUNW-D-R-021-tops-20230210_20230117-033440-00036E_00037N-PP-3514-v2_0_6.nc';

  xN=ncread(filenameN,'/science/grids/data/longitude');
  yN=ncread(filenameN,'/science/grids/data/latitude');
  AN=ncread(filenameN,'/science/grids/data/amplitude')';
  CN=ncread(filenameN,'/science/grids/data/coherence')';
  UN=ncread(filenameN,'/science/grids/data/unwrappedPhase')'; 

  WN=mod(UN,2*pi);

% Plot the interferogram components

  % South
  figure(1)
  clf
  hS=imagesc(xS,yS,WS);
  set(hS,'AlphaData',CS>0.5)
  axis xy
  colorbar
  title('South Interferogram')
  colormap(jet)

  % North
  figure(2)
  clf
  hN=imagesc(xN,yN,WN);
  set(hN,'AlphaData',CN>0.5)
  axis xy
  colorbar
  title('North Interferogram')
  colormap(jet)

  % Plot both 
  figure(3)
  clf

  ax(1)=subplot(121);
  h1=imagesc(xS,yS,WS);
  set(h1,'AlphaData',CS>0.5)
  axis xy
  colorbar
  

  ax(2)=subplot(122);
  h2=imagesc(xN,yN,WN);
  set(h2,'AlphaData',CN>0.5)
  axis xy
  colorbar

  colormap(jet)
  linkaxes(ax,'xy')

  % Bonus: plot both on same figure
  figure(4)
  clf
  h3=imagesc(xS,yS,WS);
  set(h3,'AlphaData',CS>0.5)
  axis xy
  hold on
  h4=imagesc(xN,yN,WN);
  set(h4,'AlphaData',CN>0.5)
  title('Bonus Interferogram')
  colorbar
  colormap(jet)