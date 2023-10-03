%% Preprocessing data 
addpath('C:\Users\lisag\Documents\MATLAB\Final_Paper\Functions');

% 1) About the data 
% data contains 36 Alzheimer’s patients, 23 frontotemporal dementia
% patients, and 29 healthy age-matched subjects. I chose 3 of 2
% conditions : AD (Alzheimer's disease) and C (healthy control). The data
% is taken from this paper doi.org/10.3390/data8060095.

% Load data 
EEG_data = struct(); 
filepath = 'C:\Users\lisag\Documents\MATLAB\Final_Paper\';
% List containing names of files
filelist = dir(fullfile(filepath, '*.set'));
filelist = {filelist.name};
participant_id = {'001', '005', '020', '040', '041', '042'};

for i = 1:length(filelist)
    % Finishing path 
    aktuelleDatei = fullfile(filepath, filelist{i});
    % dynamic variable name to loop
    variablenName = ['EEG_' participant_id{i}];
    % load file into Matlab
    Current = pop_loadset('filename', aktuelleDatei);
    EEG_data.(variablenName) = Current; 
end

% load the data into workspace
struct2vars(EEG_data);

%% inspect data 
eegplot(EEG_001.data, 'srate', EEG_001.srate, 'eloc_file', EEG_001.chanlocs, 'events', EEG_001.event);
eegplot(EEG_005.data, 'srate', EEG_005.srate, 'eloc_file', EEG_005.chanlocs, 'events', EEG_005.event);
eegplot(EEG_020.data, 'srate', EEG_020.srate, 'eloc_file', EEG_020.chanlocs, 'events', EEG_020.event);

eegplot(EEG_040.data, 'srate', EEG_040.srate, 'eloc_file', EEG_040.chanlocs, 'events', EEG_040.event);
eegplot(EEG_041.data, 'srate', EEG_041.srate, 'eloc_file', EEG_041.chanlocs, 'events', EEG_041.event);
eegplot(EEG_042.data, 'srate', EEG_042.srate, 'eloc_file', EEG_042.chanlocs, 'events', EEG_042.event);

%% Preprocessing 

% using an implemented helper 
EEG_001 = helper(EEG_001);
EEG_005 = helper(EEG_005);
EEG_020 = helper(EEG_020);
EEG_040 = helper(EEG_040); 
EEG_041 = helper(EEG_041);
EEG_042 = helper(EEG_042);


%% Reject noisy segments 
% Since ICA is capable of handling eye movement and blinking, the focus
% lays on EMG muscle noise

% 001
eegplot(EEG_001.data, 'command', 'rej=TMPREJ', 'srate', EEG_001.srate, 'eloc_file', EEG_001.chanlocs) 
temprej = eegplot2event(rej, -1);
EEG_001 = eeg_eegrej(EEG_001, temprej(:,[3 4]));

% 005
eegplot(EEG_005.data, 'command', 'rej=TMPREJ', 'srate', EEG_005.srate, 'eloc_file', EEG_005.chanlocs) 
temprej = eegplot2event(rej, -1);
EEG_005 = eeg_eegrej(EEG_005, temprej(:,[3 4]));

%020
eegplot(EEG_020.data, 'command', 'rej=TMPREJ', 'srate', EEG_020.srate, 'eloc_file', EEG_020.chanlocs) 
temprej = eegplot2event(rej, -1);
EEG_020 = eeg_eegrej(EEG_020, temprej(:,[3 4]));

% 040
eegplot(EEG_040.data, 'command', 'rej=TMPREJ', 'srate', EEG_040.srate, 'eloc_file', EEG_040.chanlocs) 
temprej = eegplot2event(rej, -1);
EEG_040 = eeg_eegrej(EEG_040, temprej(:,[3 4]));

% 041
eegplot(EEG_041.data, 'command', 'rej=TMPREJ', 'srate', EEG_041.srate, 'eloc_file', EEG_041.chanlocs) 
temprej = eegplot2event(rej, -1);
EEG_041 = eeg_eegrej(EEG_041, temprej(:,[3 4]));

% 042
eegplot(EEG_042.data, 'command', 'rej=TMPREJ', 'srate', EEG_042.srate, 'eloc_file', EEG_042.chanlocs) 
temprej = eegplot2event(rej, -1);
EEG_042 = eeg_eegrej(EEG_042, temprej(:,[3 4]));

   

%% ICA - Independent Component analysis 
addpath('C:\Users\lisag\Downloads\eeglab_current\eeglab2023.0\plugins\ICLabel\viewprops');
    
% Perform ICA

% 001 
EEG_001 = pop_runica(EEG_001, 'icatype', 'runica');
EEG_001 = iclabel(EEG_001); 
pop_viewprops(EEG_001, 0);
components_to_reject = [2, 3, 4, 15, 16, 10]; 
EEG_001 = pop_subcomp(EEG_001, components_to_reject, 0);

% 005
EEG_005 = pop_runica(EEG_005, 'icatype', 'runica');
EEG_005 = iclabel(EEG_005); 
pop_viewprops(EEG_005, 0);
components_to_reject = [1, 2, 3, 4, 5, 6, 12, 13, 14, 18, 10]; 
EEG_005 = pop_subcomp(EEG_005, components_to_reject, 0);

% 020
EEG_020 = pop_runica(EEG_020, 'icatype', 'runica');
EEG_020 = iclabel(EEG_020); 
pop_viewprops(EEG_020, 0);
components_to_reject = [2, 3, 4, 5, 6, 8, 16, 13]; 
EEG_020 = pop_subcomp(EEG_020, components_to_reject, 0);

% 040 
EEG_040 = pop_runica(EEG_040, 'icatype', 'runica');
EEG_040 = iclabel(EEG_040); 
pop_viewprops(EEG_040, 0);
components_to_reject = [5, 6, 8, 11, 18]; 
EEG_040 = pop_subcomp(EEG_040, components_to_reject, 0);

% 041
EEG_041 = pop_runica(EEG_041, 'icatype', 'runica');
EEG_041 = iclabel(EEG_041); 
pop_viewprops(EEG_041, 0);
components_to_reject = [19,17, 10, 9, 1, 3 ]; 
EEG_041 = pop_subcomp(EEG_041, components_to_reject, 0);

% 042
EEG_042 = pop_runica(EEG_042, 'icatype', 'runica');
EEG_042 = iclabel(EEG_042); 
pop_viewprops(EEG_042, 0);
components_to_reject = [4, 10, 11, 14, 13, 2, 1, 19 ]; 
EEG_042 = pop_subcomp(EEG_042, components_to_reject, 0);