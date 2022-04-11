%Filter log file for a specific call sign
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/29/22: Created
%03/30/22: Broken into two steps

clear
clc
close all

tic

%% User selections
combinedLogFileName = 'Step01a_CombineLogFilesResults.mat';
outputFileName      = 'Step01b_FilterLogFileResults.mat';

filterResults       = false;
callSign            = 'KG7QEC';
SSID                = '11';

%% Load data
temp = load(combinedLogFileName);
T = temp.T;

T_filtered = table();
[M,N] = size(T);
if(filterResults)
    source = T.source;
    callSignSSID = [callSign,'-',SSID];
    for k=1:M
        if(strcmp(source(k),callSignSSID))
            %keep
            T_filtered(end+1,:) = T(k,:);
        end
    end
    
else
    %Do not filter, just keep entire table
    disp('Not filtering signals, output table is same as input table')
    T_filtered = T;
    
end

[Mf,Nf] = size(T_filtered);

assert(N==Nf);
disp(['Filtered out ',num2str((1-Mf/M)*100),'% of signals'])

%% Save results
save(outputFileName,'T_filtered')
disp(['Saved to ',outputFileName])

toc
disp('DONE!')
