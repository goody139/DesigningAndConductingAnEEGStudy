%% Analysis 
%% PSD - Power spectral density
addpath C:\Users\lisag\Downloads\fieldtrip-lite-20230716\fieldtrip-20230716;
addpath('C:\Users\lisag\Documents\MATLAB\Final_Paper\Functions');

% PSD - Power spectral density
data = EEG_040; 
fs = 512;
data_length = length(data.data);

% Compute the FFT 
fft_result = fft(data.data);

% Compute the one-sided PSD
psd = (1/(fs*data_length)) * abs(fft_result(1:data_length/2 + 1)).^2;

% Frequencies corresponding to the PSD
frequencies = (0:(data_length/2)) * fs / data_length;

% Plot the PSD
figure;
plot(frequencies, abs(10 * log10(psd))); % Convert to dB for visualization
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density (PSD) 040');

%% PSD alpha frequency band 

alpha_band = [8, 13];
% Find the indices of frequencies within the alpha band
alpha_indices = find(frequencies >= alpha_band(1) & frequencies <= alpha_band(2));
figure;
plot(frequencies(alpha_indices), abs(10*log10(psd(alpha_indices))));
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density - alpha frequency band - 040');



%% Power spectral density for delta, theta, alpha, beta, gamma

% Fieldtrip format 
data = eeglab2fieldtrip(EEG_001, 'preprocessing', 'none');

% Step 2: Define the frequency bands of interest
freq_bands = [1 4; 4 8; 8 13; 13 30; 30 60];  % Define frequency bands (e.g., delta, theta, alpha, beta, gamma)

% Compute spectral power using FieldTrip's ft_freqanalysis
cfg = [];
cfg.method = 'mtmfft';
cfg.taper = 'hanning';
cfg.output = 'pow';
cfg.foi = 1:1:60;  % Frequency range of interest (1 Hz to 60 Hz)
cfg.tapsmofrq = 2;  % Smoothing parameter (adjust as needed)
cfg.keeptrials = 'no';  % Average across trials
freq_data = ft_freqanalysis(cfg, data);

% Initialize a feature matrix to store relative power ratios
num_channels = size(freq_data.powspctrm, 2);
feature_matrix = zeros(num_channels, 5);  % 5 features for each channel
size(feature_matrix)
size(freq_data)
size(freq_bands)
size(band_power)
size(channel_power)
% Calculate the relative power ratios for each channel
for i = 1:num_channels
    channel_power = squeeze(freq_data.powspctrm(:, i, :));  % Power across all frequencies for the channel
    
    % Initialize variables to store band power and total power
    band_power = zeros(size(channel_power, 1), 5);
    total_power = zeros(size(channel_power, 1), 1);
    
    % Calculate power in each frequency band
    for j = 1:5
        % Extract frequencies within the band
        band_freq_indices = freq_data.freq >= freq_bands(j, 1) & freq_data.freq <= freq_bands(j, 2);
        % Calculate the sum of power within the band
        band_power(:, j) = mean(channel_power(:, band_freq_indices(1)), 2);
    end
    
    % Calculate total power as the sum across all frequencies
    total_power = sum(channel_power, 2);
    
    % Calculate relative power ratios
    channel_rel_power = band_power ./ total_power;
    
    % Store the relative power ratios in the feature matrix
    feature_matrix(i, :) = mean(channel_rel_power, 2);  % Use mean along the second dimension
end


% Plot scalp heatmaps for each feature
feature_labels = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
figure;
for i = 1:5
    subplot(2, 3, i);
    ft_topoplotER([], feature_matrix(:, i), 'your_montage'); % Replace 'your_montage' with your EEG montage
    title(feature_labels{i});
end
colorbar;


%% Alpha and theta power : topographic map 

data = eeglab2fieldtrip(EEG_041_ICA, 'preprocessing', 'none');
[x, y]=frequency_analysis(data);

%% Average theta and alpha power : topographic map 
data1 = eeglab2fieldtrip(EEG_001_ICA, 'preprocessing', 'none'); 
data2 = eeglab2fieldtrip(EEG_005_ICA, 'preprocessing', 'none');
data3 = eeglab2fieldtrip(EEG_020_ICA, 'preprocessing', 'none');
data4 = eeglab2fieldtrip(EEG_040_ICA, 'preprocessing', 'none');
data5 = eeglab2fieldtrip(EEG_041_ICA, 'preprocessing', 'none');
data6 = eeglab2fieldtrip(EEG_042_ICA, 'preprocessing', 'none');
data_C = {data4, data5, data6};
data_AD= {data1, data2, data3};

topoplot1 = average_frequency(data_C, [4,8], 'Average theta Power (8-13 Hz) across All Channels - C');
topoplot2 = average_frequency(data_AD, [4,8], 'Average theta Power (8-13 Hz) across All Channels - AD');

%% Average coherence 
eeg_datasets = cell(num_subjects, 1);
eeg_datasets{1} = EEG_001.data; 
eeg_datasets{2} = EEG_005.data; 
eeg_datasets{3} = EEG_020.data; 
    
eeg_datasets = cell(num_subjects, 1);
eeg_datasets{1} = EEG_040.data; 
eeg_datasets{2} = EEG_041.data; 
eeg_datasets{3} = EEG_042.data; 

channel_pairs = { {'Fp1', 'F3'}; {'Fp2', 'F4'}; {'F3', 'T3'}; {'F4', 'T4'}; {'C3', 'C4'}; {'F3', 'F4'}};
labels = EEG_001.chanlocs.labels; 
avg_coherence(eeg_datasets, channel_pairs, [4,8], labels)