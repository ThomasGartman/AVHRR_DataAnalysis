%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thomas Gartman
% Reuman Lab
% This file allows for an exploration of the data and autodoc systems. It
% will eventually be converted to a mat to CSV reader for R
% Last Edited: October 1st, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;

%load in datafiles
%load in location information, lamber projection
disp('Loading data....')
load('data/mat/avhrr_vpm_1989_2015_mxvi.mat') %NDVI
load('data/mat/avhrr_cover_frac_nlcd2011.mat') %Land Cover codes. Using to get water
disp('Data Loaded')

%create matrix of water pixels
waterLocations = nlcd_cls_frac(:,1);
clear nlcd_cls_frac;
waterLocations = reshape(waterLocations, [4587, 2889]);
waterLocations = transpose(waterLocations);

for k = 1:27
    disp(strcat(string('Year '), int2str(k), string(' of '), int2str(27)))
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
    fileName = char(strcat(string('AVHRR_NDVI_WaterRemoved_'), int2str(k + 1988), string('.csv')));
    csvwrite(fileName,ndvi);
    movefile *.csv data/csvFiles/;
end
clear mxvi;

%TODO Find updated autodoc
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
end