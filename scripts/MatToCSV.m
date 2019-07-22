%MatToCSV in AVHRRGeographyOfSpatialSynchronyReproduce
%Version 1.1.1  Last Editied June 25th, 2019
%
%Takes in matlab files for AVHRR Data and converts them to csv files
%
%Preconditions:
%   1. .mat files for the AVHRR data are located in a data folder which is 
%   not in the same folder as this script
%
%   2. This file must be located in a script folder which is in the same
%   project folder as the data folder
%
%   3. The m2html folder must be in the project path and located in the
%   same project folder as the script and data folders
%
%Postconditions:
%   .csv files for AVHRR data will be generated in data/csvFiles
%
%Data processing:
%   NDVI data for each year is reshaped into US shape, then pixel locations
%   for the water or nodata are logged with a value of NaN.
%
%Structure of imported data:
%   avhrr_vpm_1989_2015_mxvi.mat contains the NDVI data, called mxvi, is a
%   2D array with dimensions 13251843x30, where the first dimension is the
%   data and the second is the year, starting at 1989 and ending at 2015.
%   Each data index represents a pixel on the map of the united states with
%   dimension 4587 by 2889. Each pixel is 1km by 1km and each data point is
%   the maximum NDVI data for that year in that pixel.
%
%   avhrr_cover_frac_nlcd2011/2006/2001.mat contains land cover codes. The codes are
%   0 for land, 1 for water, and 2 for no data (where no data means land
%   outside of the United States). The structure is a vector of dimension
%   13251843, where each index represents a land cover code for a 1km by
%   1km pixel. It also contains information on 16 different land codes for
%   each AVHRR pixel.
%
%   avhrr_1km_pixel_latlon.mat provides the conversion between the AVHRR
%   coordinates and Lat/Lon.
%
%   landscan_avhrr_grid_2000_2017.mat contains population figures for AVHRR
%   coordinates for the years 2000 to 2017.

clc;
clear all;

%load in datafiles
%load in location information, lamber projection

load('../data/AVHRR_UpdatedData/vpm/mat/avhrr_vpm_1989_2018_mxvi.mat') %NDVI
load('../data/AVHRR_UpdatedData/nlcd/avhrr_cover_frac_nlcd2011.mat') %Land Cover codes. Using to get water
load('../data/AVHRR_UpdatedData/landscan/landscan_avhrr_grid_2000_2017.mat') %Landscan
load('../data/mat/avhrr_1km_pixel_latlon.mat') %lat and long for the pixels

%create matrix of water pixels
lat = transpose(reshape(avhrr_pixel_lat, [4587,2889]));
lon = transpose(reshape(avhrr_pixel_lon, [4587,2889]));
waterLocations = pct(:,1);

waterLocations = reshape(waterLocations, [4587, 2889]);
waterLocations = transpose(waterLocations);
disp("Starting data conversion....");
%for the NDVI values
for k = 1:30
    ndvi = mxvi(:,k);
    ndvi = reshape(ndvi, [4587,2889]);
    ndvi = transpose(ndvi);

    %Alter NDVI matrix by removing water/NonUS pixels
    for i = 1:2889
        for j = 1:4587
            if(waterLocations(i, j) == 1 || waterLocations(i, j) == 2)
                ndvi(i, j) = NaN;
            end
        end
    end
    
    %make CSV Files
    fileName = char(strcat("AVHRR_NDVI_WaterRemoved_", int2str(k + 1988), ".csv"));
    csvwrite(fileName,ndvi);
    movefile *.csv ../data/csvFiles/;
    disp(strcat("NDVI: ", int2str(k)));
end

for k = 1:18
    population = pop(:,k);
    population = reshape(population, [4587,2889]);
    population = transpose(population);
    
    %make CSV Files
    fileName = char(strcat("AVHRR_Landscan_Population_WaterRemoved_", int2str(k + 1999), ".csv"));
    csvwrite(fileName,population);
    movefile *.csv ../data/csvFiles/;
    disp(strcat("Landscan: ", int2str(k)));
end

% for k = 1:16
%     percent = pct(:,k);
%     percent = reshape(percent, [4587,2889]);
%     percent = transpose(percent);
%     
%     %Alter Percent matrix by removing water/NonUS pixels
%     for i = 1:2889
%         for j = 1:4587
%             if(waterLocations(i, j) == 1 || waterLocations(i, j) == 2)
%                 ndvi(i, j) = 0;
%             end
%         end
%     end
%     
%     %make CSV Files
%     fileName = char(strcat("AVHRR_NLCD_2011_WaterRemoved_", int2str(k),".csv"));
%     csvwrite(fileName,percent);
%     movefile *.csv ../data/csvFiles/;
%     disp(strcat("NLCD 2011: ", int2str(k)));
% end
% 
% load('../data/AVHRR_UpdatedData/nlcd/avhrr_cover_frac_nlcd2006.mat')
% for k = 1:16
%     percent = pct(:,k);
%     percent = reshape(percent, [4587,2889]);
%     percent = transpose(percent);
%     
%     %Alter Percent matrix by removing water/NonUS pixels
%     for i = 1:2889
%         for j = 1:4587
%             if(waterLocations(i, j) == 1 || waterLocations(i, j) == 2)
%                 ndvi(i, j) = 0;
%             end
%         end
%     end
%     
%     %make CSV Files
%     fileName = char(strcat("AVHRR_NLCD_2006_WaterRemoved_", int2str(k),".csv"));
%     csvwrite(fileName,percent);
%     movefile *.csv ../data/csvFiles/;
%     disp(strcat("NLCD 2006: ", int2str(k)));
% end
% 
% load('../data/AVHRR_UpdatedData/nlcd/avhrr_cover_frac_nlcd2001.mat')
% for k = 1:16
%     percent = pct(:,k);
%     percent = reshape(percent, [4587,2889]);
%     percent = transpose(percent);
%     
%     %Alter Percent matrix by removing water/NonUS pixels
%     for i = 1:2889
%         for j = 1:4587
%             if(waterLocations(i, j) == 1 || waterLocations(i, j) == 2)
%                 ndvi(i, j) = 0;
%             end
%         end
%     end
%     
%     %make CSV Files
%     fileName = char(strcat("AVHRR_NLCD_2001_WaterRemoved_", int2str(k),".csv"));
%     csvwrite(fileName,percent);
%     movefile *.csv ../data/csvFiles/;
%     disp(strcat("NLCD 2001: ", int2str(k)));
% end

fileName = char(strcat("AVHRR_LAT.csv"));
csvwrite(fileName,lat);
movefile *.csv ../data/csvFiles/;
fileName = char(strcat("AVHRR_LON.csv"));
csvwrite(fileName,lon);
movefile *.csv ../data/csvFiles/;

clear mxvi;

%TODO Find updated autodoc
warning('off', 'MATLAB:nargchk:deprecated'); %Apparently this system is using a deperciated function...
m2html('mfiles', 'scripts' ,'htmldir', 'docs', 'recursive', 'on', 'global', 'on');
