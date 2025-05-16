clc; clear; close all;

%% simulate base values for velocity and heading
n = 10;
dt = 1;

true_velocity = linspace(3.5, 4.2, n);         % realistic speed 
true_heading = linspace(90, 95, n);            % right turn

% GNSS with spoofing
gnss_velocity = true_velocity;
gnss_velocity(6) = gnss_velocity(6) + 0.2; % velocity jump

gnss_heading = true_heading;
gnss_heading(6) = 120; % heading spike

% simulate IMU and magnetometer with small noise
imu_velocity = true_velocity + 0.01 * randn(1, n);  % slight noise
wheel_velocity = true_velocity;                    % clean data
magnetometer_heading = true_heading + 0.5 * randn(1, n);  % slightly noisy

%% calculate absolute error between GNSSa and other sensors
error_velocity_imu   = abs(gnss_velocity - imu_velocity);
error_velocity_wheel = abs(gnss_velocity - wheel_velocity);
error_heading         = abs(gnss_heading - magnetometer_heading);
error_heading         = min(error_heading, 360 - error_heading);

%% define detection threshold and identify spoofing per sensor


threshold_vel = 0.05;
threshold_heading = 10;

spoofing_imu     = error_velocity_imu   > threshold_vel;
spoofing_wheel   = error_velocity_wheel > threshold_vel;
spoofing_heading = error_heading        > threshold_heading;

% flag spoofing if at least 2/3 sensors disagree with GNSS
spoofing_fused = (spoofing_imu + spoofing_wheel + spoofing_heading) >= 2;



%% Plot
figure;

yyaxis left
plot(gnss_velocity, 'b', 'LineWidth', 2); hold on;
plot(imu_velocity, 'g--', 'LineWidth', 2);
plot(wheel_velocity, 'm-.', 'LineWidth', 2);
ylabel('Velocity [m/s]');

yyaxis right
plot(magnetometer_heading, 'r:', 'LineWidth', 2);
ylabel('Heading [°]');

yyaxis left
scatter(find(spoofing_fused), gnss_velocity(spoofing_fused), 60, 'ko', 'filled');

legend({'GNSS Velocity', 'IMU Velocity', 'Wheel Encoder', 'Magnetometer Heading', 'Spoofing Detected'}, 'Location', 'northwest');
xlabel('Time [s]');
title('GNSS vs. Sensor Fusion');
grid on;

