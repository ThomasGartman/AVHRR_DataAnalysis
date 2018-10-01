%NDVIFigureGenerator in AVHRRGeographyOfSpatialSynchronyReproduce
%Version 1.0.0  Last Editied October 1st, 2018
%
%Takes in matlab files for AVHRR Data and creates figures to visual data
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
%   A .gif file will be created in the project folder.
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
load('data/mat/avhrr_vpm_1989_2015_mxvi.mat') %NDVI
load('data/mat/avhrr_cover_frac_nlcd2011.mat') %Land Cover codes. Using to get water

%create matrix of water pixels
waterLocations = nlcd_cls_frac(:,1);
clear nlcd_cls_frac;
waterLocations = reshape(waterLocations, [4587, 2889]);
waterLocations = transpose(waterLocations);

%Set up altered jet colormap
alteredJet = jet;
alteredJet(64,:) = 0;

%Set up gif creation
axis tight manual;
fileName = 'NDVI1989To2015.gif';
figNDVI = gobjects(27, 1);

for k = 1:27
    %Make figure of NDVI in the united states for all years
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
    
    figNDVI(k) = figureImageScaler(ndvi);
    set(figNDVI(k), 'Name', ['Normalized Difference Vegetation Index for ' int2str(1988 + k)], 'NumberTitle','off');
    title(['Normalized Difference Vegetation Index for '  int2str(1988 + k)]);
    caxis([0 1]);
    colormap(alteredJet);
    
    %finish making the gif
    frame = getframe(figNDVI(k));
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    
    if k == 1
        imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf);
    else
        imwrite(imind, cm, fileName, 'gif', 'WriteMode', 'append');
    end
end
clear mxvi;

%TODO Find updated autodoc
warning('off', 'MATLAB:nargchk:deprecated'); %Apparently this system is using a deperciated function...
m2html('mfiles', 'scripts' ,'htmldir', 'docs', 'recursive', 'on', 'global', 'on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figureImageScalar in AVHRRGeographyOfSpatialSynchronyReproduce
%Version 1.0.0 Last Editied October 1st, 2018
%
% Generates figures without declaring figures in other scripts. Uses jet as
% a default colormap
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
end