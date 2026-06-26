%% ========================================================================
% POWER FACTOR CALCULATION FUNCTION
% ========================================================================
% Purpose: Calculate power factor from voltage and current signals
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Power Factor = cos(φ) = P / S
% where P is real power and S is apparent power
%
% ========================================================================

function [PF, real_power, reactive_power, apparent_power, phase_angle] = calculatePF(voltage, current, sampling_freq)
% Purpose: Calculate power factor from voltage and current waveforms
% Input: voltage - voltage signal (V)
%        current - current signal (A)
%        sampling_freq - sampling frequency (Hz)
% Output: PF - power factor (0 to 1)
%         real_power - real power (W)
%         reactive_power - reactive power (var)
%         apparent_power - apparent power (VA)
%         phase_angle - phase angle between V and I (rad)

% Default sampling frequency
if nargin < 3
    sampling_freq = 1e6;  % 1 MHz
end

% ========================================================================
% 1. CALCULATE RMS VALUES
% ========================================================================

% RMS voltage
V_rms = sqrt(mean(voltage.^2));

% RMS current
I_rms = sqrt(mean(current.^2));

% ========================================================================
% 2. CALCULATE PHASE ANGLE USING CROSS-CORRELATION
% ========================================================================

% Normalize signals for correlation
v_normalized = voltage / max(abs(voltage));
i_normalized = current / max(abs(current));

% Calculate cross-correlation
[correlation, lags] = xcorr(v_normalized, i_normalized, 'coeff');

% Find maximum correlation
[~, max_idx] = max(correlation);
phase_delay = lags(max_idx);

% Convert phase delay to angle
fundamental_period = sampling_freq / 50;  % Samples per period at 50 Hz
phase_angle = (phase_delay / fundamental_period) * 2 * pi;  % In radians

% Limit phase angle to ±π
phase_angle = mod(phase_angle + pi, 2*pi) - pi;

% ========================================================================
% 3. CALCULATE POWER VALUES
% ========================================================================

% Instantaneous power
instantaneous_power = voltage .* current;

% Real power (average of instantaneous power)
real_power = mean(instantaneous_power);

% Apparent power
apparent_power = V_rms * I_rms;

% Reactive power using phase angle
if apparent_power > 0
    reactive_power = apparent_power * sin(phase_angle);
else
    reactive_power = 0;
end

% ========================================================================
% 4. CALCULATE POWER FACTOR
% ========================================================================

if apparent_power > 0
    PF = abs(real_power) / apparent_power;
else
    PF = 0;
end

% Limit PF to [0, 1]
PF = min(max(PF, 0), 1);

% Check if leading or lagging
if phase_angle < 0
    % Current leads voltage - capacitive (leading)
    PF_type = 'leading';
else
    % Current lags voltage - inductive (lagging)
    PF_type = 'lagging';
end

end

%% ========================================================================
% END OF POWER FACTOR CALCULATION FUNCTION
% ========================================================================