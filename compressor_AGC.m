function y_comp = compressor_AGC(x, threshold, ratio, fs, attack_time, release_time)
    % Compressor with attack and release times for Simulink

    % Convert attack and release times to sample counts
    attack_samples = round(attack_time * fs);
    release_samples = round(release_time * fs);

    % Initialize output
    y_comp = zeros(size(x));
    gain = 1;  % Initial gain

    % Process signal sample by sample
    for n = 1:length(x)
        % Compute current gain based on input level
        x_db = 20*log10(abs(x(n)) + eps); % Convert to dB, add eps to avoid log(0)
        if x_db > threshold
            target_gain = 10^((compressor_transfer(x_db, threshold, ratio) - x_db)/20);
            % Attack phase
            gain = gain + (target_gain - gain) / attack_samples;
        else
            % Release phase
            gain = gain - (gain - 1) / release_samples;
        end
        % Apply gain to the signal
        y_comp(n) = x(n) * gain;
    end
end