%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Gartman
% Reuman Lab
% This file allows for an exploration of the data and autodoc systems. It
% will eventually be converted to a mat to CSV reader for R
% Last Edited: September 26th, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;

%load in datafiles
%load in location information, lamber projection
load('mat/avhrr_1km_map_coords.mat') %lamber projection
load('mat/avhrr_1km_pixel_latlon.mat') 
load('mat/avhrr_vpm_1989_2015_mxvi.mat') %NDVI
load('mat/avhrr_vpm_1989_2015_mxdt.mat') %Growing Season

%Rename variables
xlam = avhrr_lamaz_map_coord_x;
ylam = avhrr_lamaz_map_coord_y;
clear avhrr_lamaz_map_coord_x;
clear avhrr_lamaz_map_coord_y;

lat = avhrr_pixel_lat;
lon = avhrr_pixel_lon;
clear avhrr_pixel_lat;
clear avhrr_pixel_lon;

%Reshape to make matrix
xlam = reshape(xlam, [4587,2889]);
ylam = reshape(ylam, [2889,4587]);

xlam = transpose(xlam);
ylam = transpose(ylam);

%Make figures from lamber projection
figXlam = figureImageScaler(xlam);
set(figXlam, 'Name', 'X Lamber Projection', 'NumberTitle', 'off');
title('X Lamber Projection');
figYlam = figureImageScaler(ylam);
set(figYlam, 'Name', 'Y Lamber Projection', 'NumberTitle', 'off');
title('Y Lamber Projection');

%LAT AND LON ARE IN DEGREES 
lon = reshape(lon, [4587,2889]);
lat = reshape(lat, [2889,4587]);
lon = transpose(lon);
lat = transpose(lat);

%Make figures from pure lat/lon values. Should be skewed
figLon = figureImageScaler(lon);
set(figLon, 'Name', 'Longitude', 'NumberTitle','off');
title('Longitude');
figLat = figureImageScaler(lat);
set(figLat, 'Name', 'Latitude', 'NumberTitle','off');
title('Latitude');

%plot some lat and long isoclines, as an exercise
%imagesc(xlam, ylam, mxvi);
m = mxdt(:,1);
 %   for i = [1:2889]
 %       for j = [1:4587]
 %           m(i + j - 1) = mxdt(2890 - i + 4588 - j,1);
 %       end
 %       disp(i);
 %   end
m = reshape(m, [4587,2889]);
%imagesc(m);
%load in the actual NVDI data

warning('off', 'MATLAB:nargchk:deprecated'); %Apparently this system is using a deperciated function...
m2html('mfiles', 'scripts' ,'htmldir', 'docs', 'recursive', 'on', 'global', 'on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Since this function is temperary, the full matlab documentation structure 
% will not be implemented to document figureImageScaler
%
% This function's purpose is to generate multiple figures without declaring
% multiple figures in the script itself
%
% Args:
%   data - a vector of data to form an image from
%
% Returns:
%   Figure of data image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = figureImageScaler(data)
    f = figure;
    imagesc(data);
    colormap('jet');
    colorbar;
end