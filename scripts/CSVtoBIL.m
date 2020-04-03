%This function is designed to convert csv image files into .bil files for
%matlab.
myFolder = 'data\csvFiles';
filePattern = fullfile(myFolder, '*NaN.csv');
files = dir(filePattern);

for i = 1:length(files)
    baseName = files(i).name;
    fullName = fullfile(myFolder, baseName);
    if (baseName == "AVHRR_Synchrony1990to2018USANaN.csv" || baseName == "AVHRR_SynchronySpearman1990to2018USANaN.csv" || baseName == "AVHRR_NDVItempAveMatrixLongNaN.csv" ...
        || baseName == "AVHRR_NLCD_Development_Average_2001and2006NaN.csv" || baseName == "AVHRR_Landscan_2004NaN.csv" || baseName == "AVHRR_NLCD_Agriculture_Average_2001and2006NaN.csv" ...
        || baseName == "AVHRR_USGS_MeanElevationPreparedNaN.csv" || baseName == "AVHRR_USGS_StandardDeviationPreparedNaN.csv" || baseName == "AVHRR_LowerTailDependence1990to2018USANaN.csv" ...
        || baseName == "AVHRR_UpperTailDependence1990to2018USANaN.csv" || baseName == "AVHRR_SynchronyNo2010USANaN.csv" || baseName == "AVHRR_SynchronySpearmanNo2010USANaN.csv" ...
        || (contains(baseName, "AVHRR_NDVI_WaterRemoved_") && contains(baseName, "NaN.csv"))) 
        disp(fullName)
        x = dlmread(fullName, ',', 1, 0);
        x = x';
        x = x(:);
        x(x == -100) = NaN;
        fid = fopen(string(strcat(extractBetween(baseName, "", ".csv"), '.bil')), 'wb');
        fwrite(fid, x, 'single');
        fclose(fid);
        copyfile('data/bilFiles/template.hdr', string(strcat(extractBetween(baseName, "", ".csv"), '.hdr')));
    end
end
movefile *.bil data/bilFiles/;
movefile *.hdr data/bilFiles/;