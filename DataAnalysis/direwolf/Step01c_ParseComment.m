%Parse the comment column of the data
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/26/22: Created

clear
close all

tic

%% User selections
inputFileName   = 'Step01b_FilterLogFileResults.mat';
outputFileName  = 'Step01c_ParsedComments.mat';

%% Load data
temp = load(inputFileName);
T_filtered = temp.T_filtered;

comment = T_filtered.comment;

for k=1:length(comment)
    comment_k = comment{k};
    
    words = SplitOnDesiredChar(comment_k,'=');
    str_TA  = words{2};
    str_TB  = words{3};
    str_V   = words{4};
    
    idx = find(str_TA=='/');
    if(~isempty(idx))
        TA_C(k,1) = str2num(str_TA(1:idx(1)-1));
    else
        %fill with empty value
        TA_C(k,1) = NaN;
    end
    
    idx = find(str_TB=='/');
    if(~isempty(idx))
        TB_C(k,1) = str2num(str_TB(1:idx(1)-1));
    else
        %fill with empty value
        TB_C(k,1) = NaN;
    end
    
    idx = find(str_V==' ');
    if(~isempty(idx))
        V_bits(k,1) = str2num(str_V(1:idx(1)-1));
    else
        %fill with empty value
        V_bits(k,1) = NaN;
    end
end

%% Save results
save(outputFileName,'TA_C','TB_C','V_bits')
disp(['Saved to ',outputFileName])

toc
disp('DONE!')
