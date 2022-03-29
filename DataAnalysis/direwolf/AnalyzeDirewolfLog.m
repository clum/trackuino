%Analyze a log file from Direwolf
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/25/22: Created
%03/27/22: Added altitude profile

clear
clc
close all

tic

%% User selections
logFile = '.\logs\22_03_23\2022-03-28.log';
logFile = '.\logs\2022-03-29.log';
% logFile = '.\logs\22_03_23\2022-03-24_edited.log';

%% Load data
T = readtable(logFile);

%Get lat and lon
lat_deg = T.latitude;
lon_deg = T.longitude;
altitude_m = T.altitude;

%% Plot using variuos geoplotting functions
figureTJ
plot(altitude_m)
grid on
xlabel("Sample number")
ylabel('Altitude (m)')

figure;
geoplot(lat_deg(1),lon_deg(1),'ro','LineWidth',2);
hold on
geoplot(lat_deg,lon_deg,'b-','LineWidth',2);
geoplot(lat_deg(end),lon_deg(end),'rx','LineWidth',2);

geobasemap('streets')
legend('start','trajectory','end')
title('Direwolf Data')

toc
disp('DONE!')
