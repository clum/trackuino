%Combine multiple log files
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/29/22: Created
%03/30/22: Changed to combine log files first before filtering

clear
clc
close all

tic

%% User selections
% logFiles = {
%     '.\logs\22_03_28\2022-03-28.log'
%     '.\logs\22_03_28\2022-03-29.log'
%     };

% %HX1_01
% logFiles = {
%     '.\logs\22_04_26\2022-04-26.log'
%     '.\logs\22_04_26\2022-04-27.log'
%     };

% %HX1_02
% logFiles = {
%     '.\logs\22_04_27\2022-04-27.log'
%     '.\logs\22_04_27\2022-04-28.log'
%     };

% %HX1_03
% logFiles = {
%     '.\logs\22_04_30_HX1_03\2022-04-30.log'
%     };

% %HX1_03_edited
% logFiles = {
%     '.\logs\22_04_30_edited\2022-04-30.log'
%     };

% %HX1_04
% logFiles = {
%     '.\logs\22_04_30_HX1_04\2022-05-01.log'
%     };

% %HX1_05
% logFiles = {
%     '.\logs\22_05_06_HX1_05\2022-05-06.log'
%     };

% %HX1_06
% logFiles = {
%     '.\logs\22_05_09_HX1_06\2022-05-10.log'
%     };

% %HX1_07
% logFiles = {
%     '.\logs\22_05_25_HX1_07\2022-05-25.log'
%     };

% %Space Shrimp
% logFiles = {
%     '.\logs\22_05_28_SpaceShrimp\2022-05-28.log'
%     };

logFiles = {
    '.\logs\22_05_28_SpaceShrimp\Book5.csv'
    };


outputFileName = 'Step01a_CombineLogFilesResults.mat';

%% Concatenate files
disp('Concatenating log files')
C = {};
for k=1:length(logFiles)
    logFile = logFiles{k};
    
    %need to ignore the header line otherwise readtable has issues
    T_k = readtable(logFile,'HeaderLines',1,'ReadVariableNames',false);
    
    %Concatenate.  May need to convert to cell array first as some columns
    %might change data type between files (for example if it is all empty
    %in one file but non-empty in another file)
    C_k = table2cell(T_k);
    
    C = [C;C_k];
end

%Convert back to a table
T = cell2table(C);

%re-add the header lines
T.Properties.VariableNames = {
    'chan'
    'utime'
    'isotime'
    'source'
    'heard'
    'level'
    'error'
    'dti'
    'name'
    'symbol'
    'latitude'
    'longitude'
    'speed'
    'course'
    'altitude'
    'frequency'
    'offset'
    'tone'
    'system'
    'status'
    'telemetry'
    'comment'
    };

disp('Summary of table T')
summary(T)

%% Save data
save(outputFileName,'T')
disp(['Saved to ',outputFileName])

toc
disp('DONE!')
