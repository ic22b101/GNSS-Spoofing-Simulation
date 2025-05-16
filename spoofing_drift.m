% Read GNSS data from NMEA file
filename = 'nmea_data.txt';
fileID = fopen(filename, 'r');

% Initialize storage for latitude and longitude
latitudes = [];
longitudes = [];

% extract relevant data
while ~feof(fileID)
    line = fgetl(fileID);
    if contains(line, '$GPGGA') || contains(line, '$GPRMC')
        data = strsplit(line, ',');

        % convert raw latitude into decimal degrees
        raw_lat = str2double(data{3});
        lat_deg = floor(raw_lat / 100);
        lat_min = mod(raw_lat, 100);
        lat = lat_deg + (lat_min / 60);
        if strcmp(data{4}, 'S')
            lat = -lat;
        end

        % convert raw longitude into decimal degrees
        raw_lon = str2double(data{5});
        lon_deg = floor(raw_lon / 100);
        lon_min = mod(raw_lon, 100);
        lon = lon_deg + (lon_min / 60);
        if strcmp(data{6}, 'W')
            lon = -lon;
        end

        % add converted values to arrays
        latitudes = [latitudes; lat];
        longitudes = [longitudes; lon];
    end
end
fclose(fileID);

% create spoofed GNSS data by applying a slight drift
latitudes_drift = latitudes;
longitudes_drift = longitudes;
drift_factor = 0.0001; % strength of spoofing

for i = 3:length(latitudes)
    latitudes_drift(i) = latitudes(i) + (i-2) * drift_factor;
    longitudes_drift(i) = longitudes(i) + (i-2) * drift_factor;
end

% Visualization
figure;
plot(longitudes, latitudes, 'bo-', 'LineWidth', 2); hold on;
plot(longitudes_drift, latitudes_drift, 'ro-', 'LineWidth', 2);
xlabel('Longitude'); ylabel('Latitude');
legend('Original', 'Spoofed');
title('Spoofed vs. Original GNSS Path');
grid on;
