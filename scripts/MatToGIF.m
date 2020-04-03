load('data/MATLABFiles/avhrr_vpm_1989_2018_mxvi.mat') %NDVI
load('data/MATLABFiles/avhrr_cover_frac_nlcd2001.mat') %Land Cover codes.

waterLocations = pct(:,1);

waterLocations = reshape(waterLocations, [4587, 2889]);
waterLocations = transpose(waterLocations);

axis tight manual;

ndviArray = zeros(2889, 4587, 30);
for k = 1:30
    
disp(strcat("Figure ", int2str(k), " of ", int2str(30)))
    %Make figure of NDVI in the united states for all years
    ndvi = mxvi(:,k);
    ndvi = reshape(ndvi, [4587,2889]);
    ndvi = transpose(ndvi);
    %Alter NDVI matrix by removing water/NonUS pixels
    for i = 1:2889
        for j = 1:4587
            if(waterLocations(i, j) == 1 || waterLocations(i, j) == 2)
                ndvi(i, j) = 0;
            end
        end
    end
    ndviArray(:,:,k) = ndvi;
end

imageCreator(ndviArray, 1:4587, 1:2889, "NVDIUSA1989to2018.gif", 'Normalized Difference Vegetation Index - USA ');
imageCreator(ndviArray, 3601:3650, 1301:1330, "NVDICharleston1989to2018.gif", 'Normalized Difference Vegetation Index - Charleston, WV ');
imageCreator(ndviArray, 3051:3095, 1001:1045, "NVDIChicago1989to2018.gif", 'Normalized Difference Vegetation Index - Chicago ');
imageCreator(ndviArray, 676:720, 1591:1610, "NVDILasVegas1989to2018.gif", 'Normalized Difference Vegetation Index - Las Vegas ');
imageCreator(ndviArray, 2551:2610, 701:770, "NVDIMinneapolis1989to2018.gif", 'Normalized Difference Vegetation Index - Minneapolis ');
imageCreator(ndviArray, 2976:3035, 2351:2380, "NVDINewOrleans1989to2018.gif", 'Normalized Difference Vegetation Index - New Orleans ');
imageCreator(ndviArray, 4171:4250, 851:910, "NVDINewYork1989to2018.gif", 'Normalized Difference Vegetation Index - New York ');
imageCreator(ndviArray, 1028:1035, 1578:1585, "NVDIPage1989to2018.gif", 'Normalized Difference Vegetation Index - Page, AZ ');
imageCreator(ndviArray, 891:990, 1911:1990, "NVDIPhoenix1989to2018.gif", 'Normalized Difference Vegetation Index - Phoenix ');
imageCreator(ndviArray, 361:381, 1141:1180, "NVDIReno1989to2018.gif", 'Normalized Difference Vegetation Index - Reno ');
imageCreator(ndviArray, 1031:1075, 1146:1180, "NVDISaltLakeCity1989to2018.gif", 'Normalized Difference Vegetation Index - Salt Lake City ');
imageCreator(ndviArray, 2851:2931, 1386:1435, "NVDISaintLouis1989to2018.gif", 'Normalized Difference Vegetation Index - Saint Louis ');
imageCreator(ndviArray, 91:160, 1261:1380, "NVDISanFrancisco1989to2018.gif", 'Normalized Difference Vegetation Index - San Francisco ');

function g = imageCreator(data, x, y, fileName, Figtitle)
    alteredJet = jet;
    alteredJet(1,:) = 0;
    
    for k = 1:30
        figNDVI(k) = figureImageScaler(data(y,x,k));
        set(figNDVI(k), 'Name', strcat(Figtitle,  int2str(1988 + k)), 'NumberTitle','off');
        title(strcat(Figtitle,  int2str(1988 + k)));
        caxis([0 1]);
        colormap(alteredJet);

        %finish making the gif
        frame = getframe(figNDVI(k));
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);

        if k == 1
            imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, 'DelayTime', 1);
        else
            imwrite(imind, cm, fileName, 'gif', 'WriteMode', 'append', 'DelayTime', 1);
        end
    end
    close all;
end

function f = figureImageScaler(data)
    f = figure;
    imagesc(data);
    colormap('jet');
    colorbar;
end