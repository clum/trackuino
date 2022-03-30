%Process a log file by filtering for a specific call sign
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/29/22: Created

clear
clc
close all

tic

%% User selections
% logFile = '.\logs\22_03_23\2022-03-28.log';
% logFile = '.\logs\22_03_23\2022-03-24_edi ted.log';
% logFile = '.\logs\22_03_28\2022-03-28.log'; %just sitting in driveway
% logFile = '.\logs\22_03_28\2022-03-29.log'; %seems to have problem loading file
% logFile = '.\logs\22_03_28\2022-03-29_edited.csv'; %problems
% logFile = '.\logs\22_03_28\2022-03-29_edited2.csv'; %works but only data near home
% logFile = '.\logs\22_03_28\2022-03-29_LastLineOK.csv'; %works
logFile = '.\logs\22_03_28\2022-03-29_LastLineProblem.csv'; %the last line of this file appears to break readtable
logFile = '.\logs\22_03_28\2022-03-29_LastLineProblem2.csv'; %works but it contains the same line as above

% logFile = '.\logs\22_03_28\LastLineOK.txt'; %the last line of this file appears to break readtable
% logFile = '.\logs\22_03_28\LastLineProblem.txt'; %the last line of this file appears to break readtable


callSgin = 'KG7QEC';
ssid = '11';

%% Load data
T = readtable(logFile);

%Get lat and lonf
lat_deg = T.latitude;
lon_deg = T.longitude;
altitude_m = T.altitude;

utime = T.utime;

% T.isotime
% time = datetime(gps_date_ayear,gps_date_month,gps_date_day,gps_time_hour,gps_time_minute,gps_time_second);


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
