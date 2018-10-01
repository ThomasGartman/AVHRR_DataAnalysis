%MatToCSV in AVHRRGeographyOfSpatialSynchronyReproduce
%Version 1.0.0  Last Editied October 1st, 2018
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
%   for the water or nodata are logged with a value of 2, which is higher
%   than the maximum NDVI.
%
%Structure of imported data:
%   avhrr_vpm_1989_2015_mxvi.mat contains the NDVI data, called mxvi, is a
%   2D array with dimensions 13251843x27, where the first dimension is the
%   data and the second is the year, starting at 1989 and ending at 2015.
%   Each data index represents a pixel on the map of the united states with
%   dimension 4587 by 2889. Each pixel is 1km by 1km and each data point is
%   the maximum NDVI data for that year in that pixel.
%
%   avhrr_cover_frac_nlcd2011.mat contains land cover codes. The codes are
%   0 for land, 1 for water, and 2 for no data (where no data means land
%   outside of the United States). The structure is a vector of dimension
%   13251843, where each index represents a land cover code for a 1km by
%   1km pixel.

clc;
clear all;

%load in datafiles
%load in location information, lamber projection
load('data/mat/avhrr_vpm_1989_2015_mxvi.mat') %NDVI
load('data/mat/avhrr_cover_frac_nlcd2011.mat') %Land Cover codes. Using to get water

%create matrix of water pixels
waterLocations = nlcd_cls_frac(:,1);
clear nlcd_cls_frac;
waterLocations = reshape(waterLocations, [4587, 2889]);
waterLocations = transpose(waterLocations);

for k = 1:27
    ndvi = mxvi(:,k);
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
    
    %make CSV Files
    fileName = char(strcat(string('AVHRR_NDVI_WaterRemoved_'), int2str(k + 1988), string('.csv')));
    csvwrite(fileName,ndvi);
    movefile *.csv data/csvFiles/;
end
clear mxvi;

%TODO Find updated autodoc
warning('off', 'MATLAB:nargchk:deprecated'); %Apparently this system is using a deperciated function...
m2html('mfiles', 'scripts' ,'htmldir', 'docs', 'recursive', 'on', 'global', 'on');