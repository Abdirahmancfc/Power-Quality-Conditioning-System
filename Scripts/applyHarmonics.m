%% ========================================================================
% HARMONICS APPLICATION FUNCTION
% ========================================================================
% Purpose: Inject harmonic distortion into voltage or current signals
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% This function adds harmonic components to a fundamental signal
% According to IEEE 519 standard harmonic limits
%
% ========================================================================

function [signal_with_harmonics, time_harmonics] = applyHarmonics(signal, time, harmonic_orders, harmonic_magnitudes, fundamental_freq)
% Purpose: Inject harmonics into signal
% Input: signal - original signal (fundamental)
%        time - time vector
%        harmonic_orders - vector of harmonic orders (e.g., [5, 7, 11])
%        harmonic_magnitudes - magnitudes of harmonics (pu of fundamental)
%        fundamental_freq - fundamental frequency (Hz) - default 50 Hz
% Output: signal_with_harmonics - signal with harmonics injected
%         time_harmonics - time vector

% Default parameters
if nargin < 5
    fundamental_freq = 50;  % 50 Hz
end

% ========================================================================
% 1. CALCULATE FUNDAMENTAL AMPLITUDE
% ========================================================================

% Calculate RMS of fundamental
fundamental_rms = sqrt(mean(signal.^2));
fundamental_amplitude = fundamental_rms * sqrt(2);  % Peak amplitude

% ========================================================================
% 2. GENERATE HARMONIC COMPONENTS
% ========================================================================

% Initialize signal with harmonics
signal_with_harmonics = signal;

% Angular frequency of fundamental
w0 = 2 * pi * fundamental_freq;

% Add each harmonic
for i = 1:length(harmonic_orders)
    n = harmonic_orders(i);  % Harmonic order
    magnitude = harmonic_magnitudes(i);  % Magnitude in pu
    
    % Harmonic frequency
    wn = n * w0;
    
    % Phase shift for harmonics (random or specific)
    phase_shift = 0;  % Can be randomized if needed
    
    % Generate harmonic component
    harmonic_component = (magnitude * fundamental_amplitude) * sin(wn * time + phase_shift);
    
    % Add to signal
    signal_with_harmonics = signal_with_harmonics + harmonic_component;
end

time_harmonics = time;

% ========================================================================
% 3. DISPLAY HARMONIC INFORMATION
% ========================================================================

fprintf('[HARMONICS] Harmonic distortion injected:\n');
fprintf('            - Fundamental Frequency: %g Hz\n', fundamental_freq);
fprintf('            - Number of Harmonics: %d\n', length(harmonic_orders));
fprintf('            - Harmonic Orders: ');
for i = 1:length(harmonic_orders)
    fprintf('%d (%.1f%%) ', harmonic_orders(i), harmonic_magnitudes(i)*100);
end
fprintf('\n');

% Calculate THD introduced
harmonic_sum = sqrt(sum(harmonic_magnitudes.^2));
THD_introduced = (harmonic_sum / 1.0) * 100;  % As percentage
fprintf('            - THD Introduced: %.2f%%\n', THD_introduced);

end

%% ========================================================================
% END OF HARMONICS APPLICATION FUNCTION
% ========================================================================