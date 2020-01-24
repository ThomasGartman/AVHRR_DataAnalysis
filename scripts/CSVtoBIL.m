%This function is designed to convert csv image files into .bil files for
%matlab.
myFolder = 'data\csvFiles';
filePattern = fullfile(myFolder, '*NaN.csv');
files = dir(filePattern);

for i = 1:length(files)
    baseName = files(i).name;
    fullName = fullfile(myFolder, baseName);
    if baseName ~= "AVHRR_CityCorrelationData.csv" && baseName ~= "AVHRR_LATLON.csv" && baseName ~= "AVHRR_LAT.csv" && baseName ~= "AVHRR_LON.csv"
        if contains(baseName, "NaN")
            disp(fullName)
            x = dlmread(fullName, ',', 1, 0);
            x = x';
            x = x(:);
            x(x == -100) = NaN;
            fid = fopen(string(strcat(extractBetween(baseName, "", ".csv"), '.bil')), 'wb');
            fwrite(fid, x, 'single');
            fclose(fid);
            copyfile('test1.hdr', string(strcat(extractBetween(baseName, "", ".csv"), '.hdr')));
        end
    end
end
movefile *.bil data/bilFiles/;
movefile *.hdr data/bilFiles/;