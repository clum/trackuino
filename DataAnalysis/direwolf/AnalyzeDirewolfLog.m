%Execute entire workflow to analyze a log file from Direwolf.
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/25/22: Created
%03/27/22: Added altitude profile
%03/29/22: updated
%04/26/22: Broke into separate files

clear
clc
close all

tic

Step01a_CombineLogFiles;
Step01b_FilterLogFile;
Step01c_ParseComment;
Step02a_PlotData;

toc
disp('DONE!')
