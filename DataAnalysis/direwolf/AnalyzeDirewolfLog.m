%Analyze a log file from Direwolf
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/25/22: Created

clear
clc
close all

tic

%% User selections
% logFile = '.\logs\22_03_23\2022-03-24.log';
logFile = '.\logs\22_03_23\2022-03-24_edited.log';

%% Load data
% [data,headers] = LoadNumericCSVWithHeader(logFile);
% headers

% xlsread(logFile)

% T = readtable(logFile,'NumHeaderLines',1)
T = readtable(logFile);

%Get lat and lon
lat_deg = T.latitude;
lon_deg = T.longitude;

%% Plot using variuos geoplotting functions
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
