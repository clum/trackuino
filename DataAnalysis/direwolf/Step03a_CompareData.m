%Compare two data sets
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/27/22: Created

clear
clc
close all

tic

%% User selections
filteredLogFileName_A   = 'HX1_01_Step01b_FilterLogFileResults.mat';
parsedCommentFileName_A = 'HX1_01_Step01c_ParsedComments.mat';

filteredLogFileName_B   = 'HX1_04_Step01b_FilterLogFileResults.mat';
parsedCommentFileName_B = 'HX1_04_Step01c_ParsedComments.mat';

% filteredLogFileName_B   = 'HX1_03_Step01b_FilterLogFileResults.mat';
% parsedCommentFileName_B = 'HX1_03_Step01c_ParsedComments.mat';

plotType                = 'scatter';     %'trajectory' = connecting lines, 'scatter' = scatter plots
timeZone                = 'America/Los_Angeles';

%% Load data
%Set A
temp_A = load(filteredLogFileName_A);
T_filtered_A = temp_A.T_filtered;

chan_A          = T_filtered_A.chan;
utime_A         = T_filtered_A.utime;
isotime_A       = T_filtered_A.isotime;
source_A        = T_filtered_A.source;
heard_A         = T_filtered_A.heard;
level_A         = T_filtered_A.level;
error_A         = T_filtered_A.error;
dti_A           = T_filtered_A.dti;
name_A          = T_filtered_A.name;
symbol_A        = T_filtered_A.symbol;
latitude_rad_A  = deg2rad(T_filtered_A.latitude);
longitude_rad_A = deg2rad(T_filtered_A.longitude);
speed_mps_A     = T_filtered_A.speed;
course_rad_A    = deg2rad(T_filtered_A.course);
altitude_m_A    = T_filtered_A.altitude;
frequency_A     = T_filtered_A.frequency;
offset_A        = T_filtered_A.offset;
tone_A          = T_filtered_A.tone;
system_A        = T_filtered_A.system;
status_A        = T_filtered_A.status;
telemetry_A     = T_filtered_A.telemetry;
comment_A       = T_filtered_A.comment;

temp2_A = load(parsedCommentFileName_A);

TA_C_A    = temp2_A.TA_C;
TB_C_A    = temp2_A.TB_C;
V_bits_A  = temp2_A.V_bits;

temp_B = load(filteredLogFileName_B);
T_filtered_B = temp_B.T_filtered;

chan_B          = T_filtered_B.chan;
utime_B         = T_filtered_B.utime;
isotime_B       = T_filtered_B.isotime;
source_B        = T_filtered_B.source;
heard_B         = T_filtered_B.heard;
level_B         = T_filtered_B.level;
error_B         = T_filtered_B.error;
dti_B           = T_filtered_B.dti;
name_B          = T_filtered_B.name;
symbol_B        = T_filtered_B.symbol;
latitude_rad_B  = deg2rad(T_filtered_B.latitude);
longitude_rad_B = deg2rad(T_filtered_B.longitude);
speed_mps_B     = T_filtered_B.speed;
course_rad_B    = deg2rad(T_filtered_B.course);
altitude_m_B    = T_filtered_B.altitude;
frequency_B     = T_filtered_B.frequency;
offset_B        = T_filtered_B.offset;
tone_B          = T_filtered_B.tone;
system_B        = T_filtered_B.system;
status_B        = T_filtered_B.status;
telemetry_B     = T_filtered_B.telemetry;
comment_B       = T_filtered_B.comment;

%Load parsedCommentFileName
temp2_B = load(parsedCommentFileName_B);

TA_C_B    = temp2_B.TA_C;
TB_C_B    = temp2_B.TB_C;
V_bits_B  = temp2_B.V_bits;

%% Manipulate time stamps
figure
hold on
plot((utime_A-utime_A(1))/60/60,V_bits_A)
plot((utime_B-utime_B(1))/60/60,V_bits_B)
xlabel('\Delta T (hours)')
ylabel('V_{bits}')
grid on

return
utimePacific = datetime(utime_A,'ConvertFrom','posixtime','TimeZone',timeZone);

% %Age of last packet
% currentDate     = datetime('now','TimeZone',timeZone);
% firstPacketDate = datetime(utime_A(1),'ConvertFrom','posixtime','TimeZone',timeZone);
% lastPacketDate  = datetime(utime_A(end),'ConvertFrom','posixtime','TimeZone',timeZone);
% 
% packetAge       = currentDate - lastPacketDate;
% dataDuration    = lastPacketDate - firstPacketDate;
% 
% disp('Last packet received at')
% disp(lastPacketDate)
% 
% disp('Last packet age (HH:MM:SS)')
% disp(packetAge)
% 
% disp('Duration of data set (HH:MM:SS)')
% disp(dataDuration)
% 
% %Convert time
% utimePacific = datetime(utime_A,'ConvertFrom','posixtime','TimeZone',timeZone);

%% Plot using various geoplotting functions
figure
ax = [];
ax(end+1) = subplot(6,1,1);
plot(utimePacific,MetersPerSecToMPH(speed_mps_A))
grid on
ylabel('Speed (MPH)')

ax(end+1) = subplot(6,1,2);
plot(utimePacific,rad2deg(course_rad_A))
grid on
ylabel('Course (deg)')

ax(end+1) = subplot(6,1,3);
plot(utimePacific,MtoFt(altitude_m_A))
grid on
ylabel('Altitude (ft)')

ax(end+1) = subplot(6,1,4);
plot(utimePacific,CelciustoFarenheit(TA_C_A))
grid on
ylabel('T_A (F)')

ax(end+1) = subplot(6,1,5);
plot(utimePacific,CelciustoFarenheit(TB_C_A))
grid on
ylabel('T_B (F)')

ax(end+1) = subplot(6,1,6);
plot(utimePacific,V_bits_A)
grid on
xlabel('utime')
ylabel('V (bits)')

linkaxes(ax,'x')

figure;
switch plotType
    case 'trajectory'
        geoplot(rad2deg(latitude_rad_A(1)),rad2deg(longitude_rad_A(1)),'ro','LineWidth',2);
        hold on
        geoplot(rad2deg(latitude_rad_A),rad2deg(longitude_rad_A),'b-','LineWidth',2);
        geoplot(rad2deg(latitude_rad_A(end)),rad2deg(longitude_rad_A(end)),'rx','LineWidth',2);
        
        geobasemap('streets')
        legend('start','trajectory','end')
        
    case 'scatter'
        dotSize = 100;
        dotColor = [255 0 174]/255;
        geoscatter(rad2deg(latitude_rad_A),rad2deg(longitude_rad_A),dotSize,dotColor,'filled');
        
        geobasemap('streets')
        legend('data')
        
    otherwise
        error('Unsupported plotType')
end
title('Direwolf Data')

toc
disp('DONE!')
