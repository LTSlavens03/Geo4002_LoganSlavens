clear

filename = 'P403.NA.tenv3';
url = 'https://geodesy.unr.edu/gps_timeseries/IGS20/tenv3/NA/P403.NA.tenv3';

if ~isfile(filename)
    fprintf('Downloading %s...\n', filename);
    websave(filename, url); % Using Matlab's native websave instead of curl for stability
end

fid = fopen(filename);
% The .tenv3 format has 23 columns. 
% C{3}=Year, C{9}=East, C{10}=East_err, C{11}=North, C{12}=North_err, C{13}=Vertical, C{14}=Vert_err
C = textscan(fid, '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerlines', 1);
fclose(fid);

t = C{3};   % Decimal Year
e = C{9};   % East (meters)
e_err = C{10};
n = C{11};   % North (meters)
n_err = C{12};
v = C{13};   % Vertical (meters)
v_err = C{14};

figure(1)
clf

lightBlue = [0.7, 0.7, 1.0];
darkBlue  = [0, 0, 0.5];
lightRed  = [1.0, 0.7, 0.7];
darkRed   = [0.5, 0, 0];
lightGreen = [0.7, 1.0, 0.7];
darkGreen  = [0, 0.4, 0];

% Easting Plot
subplot(3,1,1)
errorbar(t, e, '.', 'Color', lightBlue, 'MarkerEdgeColor', darkBlue, 'CapSize', 3)
title('Station P403 Position Time Series')
ylabel('East (m)')
grid on

% Northing Plot
subplot(3,1,2)
errorbar(t, n, '.', 'Color', lightRed, 'MarkerEdgeColor', darkRed, 'CapSize', 3)
ylabel('North (m)')
grid on

% Vertical Plot
subplot(3,1,3)
errorbar(t, v, v_err, '.', 'Color', lightGreen, 'MarkerEdgeColor', darkGreen, 'CapSize', 3)
ylabel('Vertical (m)')
xlabel('Decimal Year')
grid on