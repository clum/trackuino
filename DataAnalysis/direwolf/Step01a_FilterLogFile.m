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
logFile = '.\logs\22_03_28\2022-03-29_LastLineOK.csv'; %works

% logFile = '.\logs\22_03_28\LastLineOK.txt'; %
% logFile = '.\logs\22_03_28\LastLineProblem.txt'; %


callSgin = 'KG7QEC';
ssid = '11';

%% Load data
T = readtable(logFile);
[M,N] = size(T);

% for k=1:M
%     T(k,:)
% end

toc
disp('DONE!')
