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
load('data/mat/avhrr_1km_map_coords.mat') %lamber projection
load('data/mat/avhrr_1km_pixel_latlon.mat') 
load('data/mat/avhrr_vpm_1989_2015_mxvi.mat') %NDVI
load('data/mat/avhrr_vpm_1989_2015_mxdt.mat') %Growing Season
load('data/mat/avhrr_cover_frac_nlcd2011.mat') %Land Cover codes. Using to get water

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

%create matrix of water pixels
waterLocations = nlcd_cls_frac(:,1);
clear nlcd_cls_frac;
waterLocations = reshape(waterLocations, [4587, 2889]);
waterLocations = transpose(waterLocations);

%Make figure of NDVI in the united states for the year 1989
ndvi = mxvi(:,1);
clear mxvi;
ndvi = reshape(ndvi, [4587,2889]);
ndvi = transpose(ndvi);

%Alter NDVI matrix by removing water/NonUS pixels
for i = 1:2889
    for j = 1:4587
        if(waterLocations(i, j) == 1 || waterLocations(i, j) == 2)
            ndvi(i, j) = 2;
        end
    end
end

%setup colormap
alteredJet = jet;
alteredJet(64,:) = 0;

figNDVI = figureImageScaler(ndvi);
set(figNDVI, 'Name', 'Normalized Difference Vegetation Index for 1989', 'NumberTitle','off');
title('Normalized Difference Vegetation Index for 1989');
caxis([0 1]);
colormap(alteredJet);

warning('off', 'MATLAB:nargchk:deprecated'); %Apparently this system is using a deperciated function...
m2html('mfiles', 'scripts' ,'htmldir', 'docs', 'recursive', 'on', 'global', 'on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Since this function is temporary, the full matlab documentation structure 
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