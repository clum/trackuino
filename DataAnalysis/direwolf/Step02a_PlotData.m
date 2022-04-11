%Process a log file by filtering for a specific call sign
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/29/22: Created
%03/31/22: Continued working

clear
clc
close all

tic

%% User selections
% filteredLogFileName = 'Step01b_FilterLogFileResults.mat';
% filteredLogFileName = 'Step01b_FilterLogFileResults_KG7QEC_11.mat';
filteredLogFileName = 'Step01b_FilterLogFileResults_Unfiltered.mat';

plotType    = 'scatter';     %'trajectory' = connecting lines, 'scatter' = scatter plots

%% Load data
temp = load(filteredLogFileName);
T_filtered = temp.T_filtered;

chan            = T_filtered.chan;
utime           = T_filtered.utime;
isotime         = T_filtered.isotime;
source          = T_filtered.source;
heard           = T_filtered.heard;
level           = T_filtered.level;
error           = T_filtered.error;
dti             = T_filtered.dti;
name            = T_filtered.name;
symbol          = T_filtered.symbol;
latitude_rad    = deg2rad(T_filtered.latitude);
longitude_rad   = deg2rad(T_filtered.longitude);
speed_mps       = T_filtered.speed;
course_rad      = deg2rad(T_filtered.course);
altitude_m      = T_filtered.altitude;
frequency       = T_filtered.frequency;
offset          = T_filtered.offset;
tone            = T_filtered.tone;
system          = T_filtered.system;
status          = T_filtered.status;
telemetry       = T_filtered.telemetry;
comment         = T_filtered.comment;

%% Plot using various geoplotting functions
figure
plot(utime,altitude_m)
grid on
xlabel('utime')
ylabel('Altitude (m)')

figure;
switch plotType
    case 'trajectory'
        geoplot(rad2deg(latitude_rad(1)),rad2deg(longitude_rad(1)),'ro','LineWidth',2);
        hold on
        geoplot(rad2deg(latitude_rad),rad2deg(longitude_rad),'b-','LineWidth',2);
        geoplot(rad2deg(latitude_rad(end)),rad2deg(longitude_rad(end)),'rx','LineWidth',2);
        
        geobasemap('streets')
        legend('start','trajectory','end')
        
    case 'scatter'
        dotSize = 100;
        dotColor = [255 0 174]/255;
        geoscatter(rad2deg(latitude_rad),rad2deg(longitude_rad),dotSize,dotColor,'filled');
        
        geobasemap('streets')
        legend('data')
        
    otherwise
        error('Unsupported plotType')
end
title('Direwolf Data')

toc
disp('DONE!')
