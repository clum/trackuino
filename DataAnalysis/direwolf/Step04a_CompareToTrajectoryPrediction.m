%Compare to a predicted trajectory csv file
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/21/22: Created

clear
clc
close all

tic

%% User selections
filteredLogFileName     = 'Step01b_FilterLogFileResults.mat';
parsedCommentFileName   = 'Step01c_ParsedComments.mat';
timeZone                = 'America/Los_Angeles';
deltaT_s                = 60*60*2;
csvFile = ['C:\Users\chris\OneDrive\Documents\misc\BISEAClub\Events\21_10_01_HighAltitudeBalloon\Software\TrajectoryPrediction\Data\021\flight_path (4).csv'];

%% Load data
%Load filteredLogFileName
temp = load(filteredLogFileName);
T_filtered = temp.T_filtered;

% chan            = T_filtered.chan;
utime           = T_filtered.utime;
% isotime         = T_filtered.isotime;
% source          = T_filtered.source;
% heard           = T_filtered.heard;
% level           = T_filtered.level;
% error           = T_filtered.error;
% dti             = T_filtered.dti;
% name            = T_filtered.name;
% symbol          = T_filtered.symbol;
latitude_rad    = deg2rad(T_filtered.latitude);
longitude_rad   = deg2rad(T_filtered.longitude);
% speed_mps       = T_filtered.speed;
% course_rad      = deg2rad(T_filtered.course);
altitude_m      = T_filtered.altitude;
% frequency       = T_filtered.frequency;
% offset          = T_filtered.offset;
% tone            = T_filtered.tone;
% system          = T_filtered.system;
% status          = T_filtered.status;
% telemetry       = T_filtered.telemetry;
% comment         = T_filtered.comment;

%Convert time
utimePacific = datetime(utime,'ConvertFrom','posixtime','TimeZone',timeZone);


%% Prediction data
csvData = load(csvFile);

csvTime     = csvData(:,1);
csvLat_deg  = csvData(:,2);
csvLon_deg  = csvData(:,3);
csvAlt_m      = csvData(:,4);

csvutimePacific = datetime(csvTime,'ConvertFrom','posixtime','TimeZone',timeZone);

%% Plot using various geoplotting functions
figure;
geoplot(rad2deg(latitude_rad),rad2deg(longitude_rad),'b-','LineWidth',2);
hold on
geoplot(csvLat_deg,csvLon_deg,'r-','LineWidth',2)
geobasemap('streets')
legend('actual trajectory','predicted trajectory')
title('Compare Direwolf Data with Prediction')

%% Altitude profile
figure
hold on
% plot(utimePacific,MtoFt(altitude_m),'b-','LineWidth',2)

figure
plot(csvutimePacific,MtoFt(csvAlt_m),'b-','LineWidth',2)
grid on
ylabel('Altitude (ft)')
legend('actual trajectory','predicted trajectory')

toc
disp('DONE!')
