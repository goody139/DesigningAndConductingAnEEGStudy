function avg_coherence(data, channel_pairs, freq, labels)

    % setting variables
    num_datasets = 3; 
    coherence_matrix = zeros(length(channel_pairs), num_datasets);   
    fs = 512;           
    window_length = 256;  
    overlap = 128;       
    nfft = 512;       
    freq_range = [freq]; 
    
    % loop through datasets
    for dataset = 1:num_datasets
        eeg_data = data(dataset);
        eeg_data = eeg_data{1};
        for pair_index = 1:length(channel_pairs)
            channels = channel_pairs{pair_index};
            channel1 = find(strcmp(labels, channels{1}));
            channel2 = find(strcmp(labels, channels{2}));
    
            % Compute coherence between channel1 and channel2 for the current dataset
            [coherence, f] = mscohere(eeg_data(channel1,:), eeg_data(channel2,:), window_length, overlap, nfft, fs);
    
            % Store coherence in the coherence matrix
            coherence_matrix(pair_index, dataset) = mean(coherence(freq_range(1) <= f & f <= freq_range(2)));
        end
    end
    
    % Compute average coherence across datasets
    average_coherence = mean(coherence_matrix, 2);
    
    figure;
    bar(1:length(channel_pairs), average_coherence);
    xlabel('Channel Pairs');
    ylabel('Average Coherence');
    title('Average Coherence for Channel Pairs - C');
    xticklabels(cellfun(@(x) [x{1} '-' x{2}], channel_pairs, 'UniformOutput', false));

end 