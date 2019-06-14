%connect to database
javaaddpath('/usr/share/java/mysql-connector-java.jar')
dbconn = database('AVHRR', 'matlab', '');

%read in data from matlab vector files
load('../data/AVHRR_UpdatedData/vpm/mat/avhrr_vpm_1989_2018_mxvi.mat') %NDVI
load('../data/AVHRR_UpdatedData/nlcd/avhrr_cover_frac_nlcd2011.mat') %Land Cover codes. Using to get water
load('../data/AVHRR_UpdatedData/landscan/landscan_avhrr_grid_2000_2017.mat') %Landscan
load('../data/mat/avhrr_1km_pixel_latlon.mat') %lat and long for the pixels

%Create data table for xy-latlon
count = 0;
latlontable = zeros(13251843, 4);
for x = 1:4587
    for y = 1:2889
        count = count + 1;
        latlontable(count, 1) = x;
        latlontable(count, 2) = y;
        latlontable(count, 3) = avhrr_pixel_lat(count);
        latlontable(count, 4) = avhrr_pixel_lon(count);
    end
end
fileName = char(strcat("AVHRR_LATLON.csv"));
csvwrite(fileName,latlontable);
movefile *.csv ../data/csvFiles/;
sql = 'LOAD DATA LOCAL INFILE ''/media/thomas/ReumanDrive/Gartman/avhrr/AVHRR_DataAnalysis/data/csvFiles/AVHRR_LATLON.csv'' INTO TABLE XYLatLon FIELDS TERMINATED BY '','' ENCLOSED BY ''"'' LINES TERMINATED BY ''\n'';';
result = jdbcquery(dbconn, sql);

%Create data table for ndvi
count = 0;
ndvitable = zeros(397555290, 4);
for x = 1:4587
    x
    for y = 1:2889
        for t = 1:30
            count = count + 1;
            ndvitable(count, 1) = x;
            ndvitable(count, 2) = y;
            ndvitable(count, 3) = t;
            ndvitable(count, 4) = mxvi(count);
        end
    end
end
fileName = char(strcat("AVHRR_NVDI.csv"));
csvwrite(fileName,ndvitable);
movefile *.csv ../data/csvFiles/;
sql = 'LOAD DATA LOCAL INFILE ''/media/thomas/ReumanDrive/Gartman/avhrr/AVHRR_DataAnalysis/data/csvFiles/AVHRR_NDVI.csv'' INTO TABLE ndvi FIELDS TERMINATED BY '','' ENCLOSED BY ''"'' LINES TERMINATED BY ''\n'';';
result = jdbcquery(dbconn, sql);
