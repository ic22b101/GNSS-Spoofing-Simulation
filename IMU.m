clc; clear; close all;

%%
filename = 'nmea_data.txt';
fileID = fopen(filename, 'r');

latitudes = [];
longitudes = [];
timestamps = [];

while ~feof(fileID)
    line = fgetl(fileID);
    if contains(line, '$GPGGA') || contains(line, '$GPRMC')
        data = strsplit(line, ',');
        time = str2double(data{2});
        
        raw_lat = str2double(data{3});
        lat_deg = floor(raw_lat / 100);
        lat_min = mod(raw_lat, 100);
        lat = lat_deg + (lat_min / 60);
        if strcmp(data{4}, 'S')
            lat = -lat;
        end
        
        raw_lon = str2double(data{5});
        lon_deg = floor(raw_lon / 100);
        lon_min = mod(raw_lon, 100);
        lon = lon_deg + (lon_min / 60);
        if strcmp(data{6}, 'W')
            lon = -lon;
        end
        
        latitudes = [latitudes; lat];
        longitudes = [longitudes; lon];
        timestamps = [timestamps; time];
    end
end

fclose(fileID);



%% calculate GNSS veelocity using positional changes

dt = 1; % time step in seconds
gnss_velocity = sqrt(diff(latitudes).^2 + diff(longitudes).^2) / dt;

% pad velocity array to match original data length
gnss_velocity = [gnss_velocity; gnss_velocity(end)]; 



%% simulate IMU data: constant forward acceleration

imu_accel_x = 0.02 * ones(size(latitudes)); % constant acceleration
imu_accel_y = zeros(size(latitudes));       % no lateral movement

% integrate acceleration to get velocity
imu_velocity_x = cumsum(imu_accel_x * dt);
imu_velocity_y = cumsum(imu_accel_y * dt);
imu_velocity = sqrt(imu_velocity_x.^2 + imu_velocity_y.^2);

%% detect spoofing by comparing IMU and GNSS velocities
velocity_error = abs(gnss_velocity - imu_velocity);
threshold = 0.005; % sensitivity threshold
spoofing_detected = velocity_error > threshold;

%% Plot IMU velocity and detected spoofing points
figure;
plot(imu_velocity, 'r--', 'LineWidth', 2);
plot(find(spoofing_detected), gnss_velocity(spoofing_detected), 'ko', 'MarkerFaceColor', 'r');
legend('IMU Velocity');
xlabel('Time [s]'); ylabel('Velocity [relative]');
title('IMU velocity curve');
grid on;