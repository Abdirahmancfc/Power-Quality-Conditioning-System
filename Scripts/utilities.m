%% ========================================================================
% UTILITY FUNCTIONS
% ========================================================================
% Purpose: Provide utility functions for the system
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% This file contains various utility functions used throughout the system
%
% ========================================================================

%% Function 1: Convert per-unit to actual values
function actual_value = pu_to_actual(pu_value, base_value)
% Purpose: Convert per-unit value to actual value
% Input: pu_value - value in per-unit
%        base_value - base value for conversion
% Output: actual_value - converted value

actual_value = pu_value * base_value;

end

%% Function 2: Convert actual to per-unit values
function pu_value = actual_to_pu(actual_value, base_value)
% Purpose: Convert actual value to per-unit
% Input: actual_value - actual value
%        base_value - base value for conversion
% Output: pu_value - value in per-unit

pu_value = actual_value / base_value;

end

%% Function 3: Calculate 3-phase RMS voltage from peak
function V_rms = peak_to_rms_3ph(V_peak)
% Purpose: Convert 3-phase peak voltage to RMS
% Input: V_peak - peak voltage (V)
% Output: V_rms - RMS voltage (V)

V_rms = V_peak / sqrt(2);

end

%% Function 4: Calculate 3-phase RMS current from peak
function I_rms = peak_to_rms(I_peak)
% Purpose: Convert peak current to RMS
% Input: I_peak - peak current (A)
% Output: I_rms - RMS current (A)

I_rms = I_peak / sqrt(2);

end

%% Function 5: Validate input parameters
function is_valid = validateParameters(params, param_name, min_val, max_val)
% Purpose: Validate parameter value
% Input: params - parameter structure
%        param_name - name of parameter
%        min_val - minimum allowed value
%        max_val - maximum allowed value
% Output: is_valid - validation result (true/false)

if ~isfield(params, param_name)
    is_valid = false;
    return;
end

value = params.(param_name);

if isnumeric(value) && value >= min_val && value <= max_val
    is_valid = true;
else
    is_valid = false;
end

end

%% Function 6: Clip signal to min/max values
function clipped = clipSignal(signal, min_val, max_val)
% Purpose: Clip signal to specified range
% Input: signal - input signal
%        min_val - minimum value
%        max_val - maximum value
% Output: clipped - clipped signal

clipped = max(min(signal, max_val), min_val);

end

%% Function 7: Low-pass filter signal
function filtered = lowPassFilter(signal, cutoff_freq, sampling_freq)
% Purpose: Apply simple 1st order low-pass filter
% Input: signal - input signal
%        cutoff_freq - cutoff frequency (Hz)
%        sampling_freq - sampling frequency (Hz)
% Output: filtered - filtered signal

% Design filter
[b, a] = butter(1, cutoff_freq/(sampling_freq/2));

% Apply filter
filtered = filter(b, a, signal);

end

%% Function 8: Generate sinusoidal signal
function signal = generateSineWave(amplitude, frequency, phase, time_array)
% Purpose: Generate sinusoidal signal
% Input: amplitude - signal amplitude
%        frequency - frequency (Hz)
%        phase - phase shift (rad)
%        time_array - time vector
% Output: signal - sinusoidal signal

angular_freq = 2 * pi * frequency;
signal = amplitude * sin(angular_freq * time_array + phase);

end

%% Function 9: Calculate RMS value
function rms_value = calculateRMS(signal)
% Purpose: Calculate RMS value of signal
% Input: signal - input signal
% Output: rms_value - RMS value

rms_value = sqrt(mean(signal.^2));

end

%% Function 10: Calculate peak value
function peak_value = calculatePeak(signal)
% Purpose: Calculate peak value of signal
% Input: signal - input signal
% Output: peak_value - peak value

peak_value = max(abs(signal));

end

%% Function 11: Calculate crest factor
function cf = calculateCrestFactor(signal)
% Purpose: Calculate crest factor (Peak / RMS)
% Input: signal - input signal
% Output: cf - crest factor

peak = calculatePeak(signal);
rms = calculateRMS(signal);

if rms == 0
    cf = 0;
else
    cf = peak / rms;
end

end

%% Function 12: Generate three-phase sinusoidal signals
function [va, vb, vc] = generate3PhaseSignal(amplitude, frequency, phase, time_array)
% Purpose: Generate balanced three-phase signals
% Input: amplitude - signal amplitude
%        frequency - frequency (Hz)
%        phase - phase shift for phase A (rad)
%        time_array - time vector
% Output: va, vb, vc - three-phase signals (120° apart)

angular_freq = 2 * pi * frequency;

% Phase A
va = amplitude * sin(angular_freq * time_array + phase);

% Phase B (120° lagging)
phase_B = phase - 2*pi/3;
vb = amplitude * sin(angular_freq * time_array + phase_B);

% Phase C (240° lagging)
phase_C = phase - 4*pi/3;
vc = amplitude * sin(angular_freq * time_array + phase_C);

end

%% Function 13: abc to dq transformation
function [vd, vq] = abc_to_dq(va, vb, vc, theta)
% Purpose: Transform three-phase (abc) to direct-quadrature (dq)
% Input: va, vb, vc - three-phase signals
%        theta - rotating angle (rad)
% Output: vd, vq - direct and quadrature components

% Transformation matrix
K = (2/3);

vd = K * (va * cos(theta) + vb * cos(theta - 2*pi/3) + vc * cos(theta - 4*pi/3));
vq = K * (-va * sin(theta) - vb * sin(theta - 2*pi/3) - vc * sin(theta - 4*pi/3));

end

%% Function 14: dq to abc transformation
function [va, vb, vc] = dq_to_abc(vd, vq, theta)
% Purpose: Transform direct-quadrature (dq) to three-phase (abc)
% Input: vd, vq - direct and quadrature components
%        theta - rotating angle (rad)
% Output: va, vb, vc - three-phase signals

va = vd * cos(theta) - vq * sin(theta);
vb = vd * cos(theta - 2*pi/3) - vq * sin(theta - 2*pi/3);
vc = vd * cos(theta - 4*pi/3) - vq * sin(theta - 4*pi/3);

end

%% Function 15: PI controller
function u = PIController(error, Kp, Ki, integral_sum, dt)
% Purpose: PI controller calculation
% Input: error - current error
%        Kp - proportional gain
%        Ki - integral gain
%        integral_sum - accumulated integral
%        dt - time step
% Output: u - controller output

% Proportional term
P_term = Kp * error;

% Integral term (updated)
integral_sum = integral_sum + Ki * error * dt;

% Output
u = P_term + integral_sum;

end

%% ========================================================================
% END OF UTILITY FUNCTIONS
% ========================================================================