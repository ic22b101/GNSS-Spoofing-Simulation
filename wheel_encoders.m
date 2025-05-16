clc; clear; close all;

%% set up simulated wheel encoder values

num_samples = 10; % number of time steps
wheel_circumference = 2; % circumference in meters per wheel rotation

% simulate increasing wheel rotations per second
rotations_per_sec = linspace(1.8, 2.5, num_samples); % Umdrehungen pro Sekunde

% convert rotations to velocity
wheel_velocity = rotations_per_sec * wheel_circumference;


%% simulate spoofed GNSS velocity

% start with GNSS matching wheel encoder, then inject a spike
gnss_velocity = wheel_velocity; 
gnss_velocity(5) = gnss_velocity(5) + 0.06; % introduce spoofing at sample 5

%% comparison GNSS and wheel encoders
velocity_error = abs(gnss_velocity - wheel_velocity);
threshold = 0.04;
spoofing_detected = velocity_error > threshold;

%% Plot
figure;
plot(wheel_velocity, 'g', 'LineWidth', 2); hold on;
plot(gnss_velocity, 'b--', 'LineWidth', 2);
scatter(find(spoofing_detected), gnss_velocity(spoofing_detected), 50, 'ro', 'filled');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
legend('Wheel Encoder', 'GNSS', 'Spoofing Detected');
title('GNSS vs. Wheel Encoder');
grid on;
