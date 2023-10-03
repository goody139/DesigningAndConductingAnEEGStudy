%% Helper function for preprocessing

function [preprocessed_data] = helper(data)

    % Resampling
    sr = 512;
    data = pop_resample(data, sr);
    
    % Filtering
    data = pop_eegfiltnew(data, 0.5, []); % high-pass filter 
    data = pop_eegfiltnew(data, [], 45); % low-pass filter
    
    preprocessed_data = pop_rmbase(data);

    % No noisy or empty channels detected so no removal 
    
end