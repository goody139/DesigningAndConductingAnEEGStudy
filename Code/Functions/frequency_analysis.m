function [alpha_topo, theta_topo] = frequency_analysis(data)
% This function calculates the Power Spectral density for frequency 
% bands alpha and theta.

    cfg = [];
    cfg.output = 'pow';
    cfg.method = 'tfr';
    cfg.taper = 'hanning';
    cfg.toi = 'all'; % entire time range
    cfg.keeptrials = 'no'; % Average across trials

    % theta
    cfg.foi = [4 8]; % theta (4-8 Hz)
    freq_theta = ft_freqanalysis(cfg, data);

    % alpha 
    cfg.foi = [8 13]; % alpha (8-13 Hz)
    freq_alpha = ft_freqanalysis(cfg, data);
    
    % compute relative powspctrm
    total_pow = ft_freqanalysis(cfg, data); 
    relative_alpha = freq_alpha;
    relative_alpha.powspctrm = freq_alpha.powspctrm ./ total_pow.powspctrm;

    % Plot results - alpha 
    cfg.colorbar = 'yes';
    cfg.colormap = 'parula';
    alpha_topo = ft_topoplotER(cfg, freq_alpha);
    c = colorbar;
    c.Label.String = 'uV^2/Hz';
    title('Alpha Relative Power AD');

    
    % Plot results - theta
    cfg.colorbar = 'yes';
    cfg.colormap = 'parula';
    theta_topo = ft_topoplotTFR(cfg, freq_theta);
    c = colorbar;
    c.Label.String = 'uV^2/Hz';
    title('Theta Relative Power AD');

end 
