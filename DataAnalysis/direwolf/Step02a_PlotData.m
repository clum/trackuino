%Plot results
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/29/22: Created
%03/31/22: Continued working
%04/26/22: Adding alternative plots
%04/30/22: Updates to plotting
%05/09/22: Adding battery limits
%05/21/22: Updated documentation

clear
close all

tic

%% User selections
filteredLogFileName     = 'Step01b_FilterLogFileResults.mat';
parsedCommentFileName   = 'Step01c_ParsedComments.mat';
plotType                = 'trajectory';     %'trajectory' = connecting lines, 'scatter' = scatter plots
timeZone                = 'America/Los_Angeles';

%% Load data
%Load filteredLogFileName
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

%Load parsedCommentFileName
temp2 = load(parsedCommentFileName);

TA_C    = temp2.TA_C;
TB_C    = temp2.TB_C;
V_bits  = temp2.V_bits;

%% Manipulate time stamps
%Age of last packet
currentDate     = datetime('now','TimeZone',timeZone);
firstPacketDate = datetime(utime(1),'ConvertFrom','posixtime','TimeZone',timeZone);
lastPacketDate  = datetime(utime(end),'ConvertFrom','posixtime','TimeZone',timeZone);

packetAge       = currentDate - lastPacketDate;
dataDuration    = lastPacketDate - firstPacketDate;

disp('Last packet received at')
disp(lastPacketDate)

disp('Last packet age (HH:MM:SS)')
disp(packetAge)

disp('Duration of data set (HH:MM:SS)')
disp(dataDuration)

%Convert time
utimePacific = datetime(utime,'ConvertFrom','posixtime','TimeZone',timeZone);

%% Plot using various geoplotting functions
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

figure
ax = [];
ax(end+1) = subplot(6,1,1);
plot(utimePacific,MetersPerSecToMPH(speed_mps))
grid on
ylabel('Speed (MPH)')

ax(end+1) = subplot(6,1,2);
plot(utimePacific,rad2deg(course_rad))
grid on
ylabel('Course (deg)')

ax(end+1) = subplot(6,1,3);
plot(utimePacific,MtoFt(altitude_m))
grid on
ylabel('Altitude (ft)')

ax(end+1) = subplot(6,1,4);
plot(utimePacific,CelciustoFarenheit(TA_C))
grid on
ylabel('T_A (F)')

ax(end+1) = subplot(6,1,5);
plot(utimePacific,CelciustoFarenheit(TB_C))
grid on
ylabel('T_B (F)')

ax(end+1) = subplot(6,1,6);
hold on
plot(utimePacific,V_bits)
plot(utimePacific,7500*ones(size(utimePacific)),'g--','LineWidth',2)
plot(utimePacific,6470*ones(size(utimePacific)),'r--','LineWidth',2)
grid on
xlabel('utime')
ylabel('V (bits)')

linkaxes(ax,'x')


toc
disp('DONE!')
