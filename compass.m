clc; clear; close all;

%% simulate magnetometer heading data in degrees

num_samples = 10;
true_heading = linspace(90, 95, num_samples); % slight right curve 

%% create spoofed GNSS heading by injecting a sudden change

gnss_heading = true_heading;
gnss_heading(6) = 120; % Plötzlicher Kurswechsel (Spoofing)

%% calculate heading difference

heading_error = abs(gnss_heading - true_heading);

% correct for circular angle wraparound
heading_error = min(heading_error, 360 - heading_error);

%% detect spoofing it heading difference exceeds the threshold

threshold = 10; % detection threshold in degrees
spoofing_detected = heading_error > threshold;

%% Visualization
figure;
plot(true_heading, 'g', 'LineWidth', 2); hold on;
plot(gnss_heading, 'b--', 'LineWidth', 2);
scatter(find(spoofing_detected), gnss_heading(spoofing_detected), 50, 'ro', 'filled');
xlabel('Time [s]');
ylabel('Direction [°]');
legend('Magnetometer', 'GNSS', 'Spoofing Detected');
title('GNSS vs. Magnetometer');
grid on;
