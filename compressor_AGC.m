function y = compressor_AGC(u, threshold_dB, ratio, fs, attack_time, release_time)
    % Compressor with Attack and Release
    % u: input signal
    % y: compressed output signal

    % Convert threshold to linear scale
    threshold = 10^(threshold_dB / 20);

    % Initialize persistent variables
    persistent level;
    if isempty(level)
        level = 0;
    end

    % Compute the envelope of the input signal
    abs_u = abs(u);
    if abs_u > level
        % Attack phase
        level = (1 - exp(-1 / (fs * attack_time))) * abs_u + exp(-1 / (fs * attack_time)) * level;
    else
        % Release phase
        level = (1 - exp(-1 / (fs * release_time))) * abs_u + exp(-1 / (fs * release_time)) * level;
    end

    % Apply compression
    if level > threshold
        gain = threshold + (level - threshold) / ratio;
    else
        gain = level;
    end

    % Apply the computed gain to the input signal
    y = (gain / level) * u;
end