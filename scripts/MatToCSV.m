%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Gartman
% Reuman Lab
% This file allows for an exploration of the data and autodoc systems. It
% will eventually be converted to a mat to CSV reader for R
% Last Edited: September 26th, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%Thomas can do the same with lat and lin vectors
%maybe use find to find the lat and lon of the origin in the projection
%as an exercise

%LAT AND LON ARE IN DEGREES
lon = reshape(lon, [4587,2889]);
lat = reshape(lat, [2889,4587]);

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
imagesc(m);
%load in the actual NVDI data
