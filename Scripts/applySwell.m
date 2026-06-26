%% ========================================================================
% VOLTAGE SWELL APPLICATION FUNCTION
% ========================================================================
% Purpose: Apply voltage swell disturbance to signals
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Voltage swell: Temporary increase in RMS voltage (110%-180%)
% Duration: 0.5 cycles to 1 minute
% IEEE Std 1159: 1.1 to 1.8 pu, 0.5 cycles to 1 minute
%
% ========================================================================

function [voltage_swell, time_swell] = applySwell(voltage, time, swell_magnitude, swell_start, swell_duration, fundamental_freq)
% Purpose: Apply voltage swell to voltage signal
% Input: voltage - original voltage signal
%        time - time vector
%        swell_magnitude - swell magnitude (0 to 0.8, typical 0.1 to 0.8)
%        swell_start - swell start time (s)
%        swell_duration - swell duration (s)
%        fundamental_freq - fundamental frequency (Hz) - default 50 Hz
% Output: voltage_swell - voltage signal with swell applied
%         time_swell - time vector with swell

% Default parameters
if nargin < 6
    fundamental_freq = 50;  % 50 Hz
end

% ========================================================================
% 1. VALIDATE INPUTS
% ========================================================================

% Ensure swell_magnitude is reasonable
if swell_magnitude < 0 || swell_magnitude > 1
    error('Swell magnitude must be between 0 and 1');
end

% ========================================================================
% 2. CREATE SWELL PROFILE
% ========================================================================

% Find indices for swell window
swell_idx_start = find(time >= swell_start, 1);
swell_idx_end = find(time >= (swell_start + swell_duration), 1);

if isempty(swell_idx_start)
    swell_idx_start = 1;
end
if isempty(swell_idx_end)
    swell_idx_end = length(time);
end

% Create swell signal (smooth transition)
num_cycles_transition = 0.5;  % 0.5 cycles for transition
transition_samples = round(num_cycles_transition * length(time) / (fundamental_freq * (time(end) - time(1))));

% Create gain profile
gain = ones(1, length(time));

% Apply swell with smooth transitions
for i = swell_idx_start:swell_idx_end
    % Calculate position in swell window
    pos_in_swell = i - swell_idx_start;
    
    if pos_in_swell < transition_samples
        % Smooth transition in
        gain_transition = 1 + (swell_magnitude / transition_samples) * pos_in_swell;
        gain(i) = gain_transition;
    elseif pos_in_swell >= (swell_idx_end - swell_idx_start - transition_samples)
        % Smooth transition out
        pos_in_recovery = pos_in_swell - (swell_idx_end - swell_idx_start - transition_samples);
        gain_transition = 1 + swell_magnitude - (swell_magnitude / transition_samples) * pos_in_recovery;
        gain(i) = gain_transition;
    else
        % Steady-state swell
        gain(i) = 1 + swell_magnitude;
    end
end

% Apply gain to voltage
voltage_swell = voltage .* gain;
time_swell = time;

% ========================================================================
% 3. DISPLAY SWELL INFORMATION
% ========================================================================

fprintf('[SWELL] Voltage swell applied:\n');
fprintf('        - Magnitude: %.1f%%\n', swell_magnitude * 100);
fprintf('        - Start: %.3f s\n', swell_start);
fprintf('        - Duration: %.3f s\n', swell_duration);
fprintf('        - Peak Voltage: %.1f%%\n', (1 + swell_magnitude) * 100);

end

%% ========================================================================
% END OF VOLTAGE SWELL FUNCTION
% ========================================================================