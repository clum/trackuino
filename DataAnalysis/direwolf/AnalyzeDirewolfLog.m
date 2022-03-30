%Analyze a log file from Direwolf
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/25/22: Created
%03/27/22: Added altitude profile
%03/29/22: updated

clear
clc
close all

tic

%% User selections
% logFile = '.\logs\22_03_23\2022-03-28.log';
% logFile = '.\logs\22_03_23\2022-03-24_edited.log';
% logFile = '.\logs\22_03_28\2022-03-28.log'; %just sitting in driveway
logFile = '.\logs\22_03_28\2022-03-29.log'; %just sitting in driveway

%% Load data
T = readtable(logFile);

%Get lat and lon
lat_deg = T.latitude;
lon_deg = T.longitude;
altitude_m = T.altitude;

utime = T.utime;

% T.isotime
% time = datetime(gps_date_year,gps_date_month,gps_date_day,gps_time_hour,gps_time_minute,gps_time_second);


%% Plot using variuos geoplotting functions
figure
plot(utime,altitude_m)
grid on
xlabel("utime")
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
