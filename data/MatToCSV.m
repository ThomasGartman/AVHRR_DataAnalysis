%load in location information, lamber projection
%load('mat/avhrr_1km_file_coords.mat')
load('mat/avhrr_1km_map_coords.mat')
xlam = avhrr_lamaz_map_coord_x;
ylam = avhrr_lamaz_map_coord_y;
clear avhrr_lamaz_map_coord_x;
clear avhrr_lamaz_map_coord_y;

%Load in location information, lat-long
load('mat/avhrr_1km_pixel_latlon.mat')
lat = avhrr_pixel_lat;
lon = avhrr_pixel_lon;
clear avhrr_pixel_lat;
clear avhrr_pixel_lon;

%Reshape to make matrix
xlam = reshape(xlam, [4587,2889]);
ylam = reshape(ylam, [2889,4587]);

xlam = transpose(xlam);
ylam = transpose(ylam);

xlam(1:10,1:10);
xlam(1:10,4578:4587);
xlam(2880:2889,1:10);
xlam(2880:2889,4578:4587);

ylam(1:10,1:10);
ylam(1:10,2880:2889);
ylam(4578:4587,1:10);
ylam(4578:4587,2880:2889);

%Thomas can do the same with lat and lin vectors
%maybe use find to find the lat and lon of the origin in the projection
%as an exercise

%plot some lat and long isoclines, as an exercise

%load in the actual NVDI data
