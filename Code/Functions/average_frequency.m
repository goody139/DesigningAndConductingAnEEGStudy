function [topoplot] = average_frequency(data, freq_band, condition)

    % Define the frequency analysis configuration
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.output = 'pow';
    cfg.taper = 'hanning';
    cfg.foi = [freq_band]; % Alpha frequency band (8-13 Hz) theta (4-8 Hz)
    cfg.keeptrials = 'no';
    
    % Initialize an empty structure to store the averaged results
    avg_freq = [];
    
    % Perform frequency analysis and calculate the average across datasets
    for i = 1:3 % Loop through your three datasets
        % Perform frequency analysis on the current dataset
        freq = ft_freqanalysis(cfg, data{i});
        
        % If it's the first dataset, initialize avg_freq
        if i == 1
            avg_freq = freq;
        else
            % Add the power values from the current dataset to the average
            avg_freq.powspctrm = avg_freq.powspctrm + freq.powspctrm;
        end
    end
    
    % Calculate the average power by dividing by the number of datasets
    avg_freq.powspctrm = avg_freq.powspctrm / 3; % Assuming three datasets
    
    % Create a topographic plot of the average spectral density power
    cfg = [];
    cfg.layout = 'standard_1020.elc'; % Replace with the appropriate layout name
    cfg.parameter = 'powspctrm';
    
    % Plot the average alpha power
    figure;
    topoplot = ft_topoplotTFR(cfg, avg_freq);
    c = colorbar;
    c.Label.String = 'uV^2/Hz';
    title(condition );
    
    
end 