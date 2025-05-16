# GNSS-Spoofing-Simulation



This project simulates GNSS spoofing scenarios and demonstrates how IMU, wheel encoders, and magnetometers can be used to detect spoofed data. It includes five MATLAB scripts and a small NMEA data sample.

## Contents
- `spoofing_drift.m` – introduces drift in GNSS coordinates
- `imu.m` – detects spoofing via IMU acceleration
- `wheel_encoders.m` – detects spoofing using wheel-based speed
- `compass.m` – heading comparison using magnetometer
- `sensorfusion.m` – combines all sensors for robust detection
- `nmea_data.txt` – input file for GNSS coordinates

## Author
Yasmin Farghally – [ic22b101@technikum-wien.at] or [yasminfarghally@gmail.com]
