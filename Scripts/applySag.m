%% ========================================================================
% VOLTAGE SAG APPLICATION FUNCTION
% ========================================================================
% Purpose: Apply voltage sag disturbance to signals
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Voltage sag: Temporary reduction in RMS voltage (10%-90%)
% Duration: 0.5 cycles to 1 minute
% IEEE Std 1159: 0.1 to 0.9 pu, 0.5 cycles to 1 minute
%
% ========================================================================

function [voltage_sag, time_sag] = applySag(voltage, time, sag_depth, sag_start, sag_duration, fundamental_freq)
% Purpose: Apply voltage sag to voltage signal
% Input: voltage - original voltage signal
%        time - time vector
%        sag_depth - sag depth (0 to 1, where 1 = complete loss)
%        sag_start - sag start time (s)
%        sag_duration - sag duration (s)
%        fundamental_freq - fundamental frequency (Hz) - default 50 Hz
% Output: voltage_sag - voltage signal with sag applied
%         time_sag - time vector with sag

% Default parameters
if nargin < 6
    fundamental_freq = 50;  % 50 Hz
end

% ========================================================================
% 1. VALIDATE INPUTS
% ========================================================================

% Ensure sag_depth is between 0 and 1
if sag_depth < 0 || sag_depth > 1
    error('Sag depth must be between 0 and 1');
end

% ========================================================================
% 2. CREATE SAG PROFILE
% ========================================================================

% Find indices for sag window
sag_idx_start = find(time >= sag_start, 1);
sag_idx_end = find(time >= (sag_start + sag_duration), 1);

if isempty(sag_idx_start)
    sag_idx_start = 1;
end
if isempty(sag_idx_end)
    sag_idx_end = length(time);
end

% Create sag signal (smooth transition)
num_cycles_transition = 0.5;  % 0.5 cycles for transition
transition_samples = round(num_cycles_transition * length(time) / (fundamental_freq * (time(end) - time(1))));

% Create gain profile
gain = ones(1, length(time));

% Apply sag with smooth transitions
for i = sag_idx_start:sag_idx_end
    % Calculate position in sag window
    pos_in_sag = i - sag_idx_start;
    
    if pos_in_sag < transition_samples
        % Smooth transition in
        gain_transition = 1 - (sag_depth / transition_samples) * pos_in_sag;
        gain(i) = gain_transition;
    elseif pos_in_sag >= (sag_idx_end - sag_idx_start - transition_samples)
        % Smooth transition out
        pos_in_recovery = pos_in_sag - (sag_idx_end - sag_idx_start - transition_samples);
        gain_transition = (sag_depth / transition_samples) * pos_in_recovery + (1 - sag_depth);
        gain(i) = gain_transition;
    else
        % Steady-state sag
        gain(i) = 1 - sag_depth;
    end
end

% Apply gain to voltage
voltage_sag = voltage .* gain;
time_sag = time;

% ========================================================================
% 3. DISPLAY SAG INFORMATION
% ========================================================================

fprintf('[SAG] Voltage sag applied:\n');
fprintf('      - Depth: %.1f%%\n', sag_depth * 100);
fprintf('      - Start: %.3f s\n', sag_start);
fprintf('      - Duration: %.3f s\n', sag_duration);
fprintf('      - Residual Voltage: %.1f%%\n', (1 - sag_depth) * 100);

end

%% ========================================================================
% END OF VOLTAGE SAG FUNCTION
% ========================================================================