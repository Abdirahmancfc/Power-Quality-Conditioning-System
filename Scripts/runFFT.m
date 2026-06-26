%% ========================================================================
% FFT ANALYSIS FUNCTION
% ========================================================================
% Purpose: Perform FFT analysis and generate frequency spectrum
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% This function analyzes the frequency content of a signal
%
% ========================================================================

function [freq_spectrum, frequency_axis, harmonics_table] = runFFT(signal, sampling_freq, fundamental_freq, max_harmonic)
% Purpose: Compute FFT and harmonic content
% Input: signal - input signal (voltage or current)
%        sampling_freq - sampling frequency (Hz)
%        fundamental_freq - fundamental frequency (Hz) - default 50 Hz
%        max_harmonic - maximum harmonic to display - default 51
% Output: freq_spectrum - magnitude spectrum
%         frequency_axis - frequency axis (Hz)
%         harmonics_table - harmonic magnitudes table

% Default parameters
if nargin < 2
    sampling_freq = 1e6;            % 1 MHz default
end
if nargin < 3
    fundamental_freq = 50;          % 50 Hz fundamental
end
if nargin < 4
    max_harmonic = 51;              % Up to 51st harmonic
end

% ========================================================================
% 1. COMPUTE FFT
% ========================================================================

% Get signal length
N = length(signal);

% Compute FFT
FFT_result = fft(signal);

% Compute frequency resolution
freq_resolution = sampling_freq / N;

% Create frequency axis (one-sided spectrum)
freq_max = sampling_freq / 2;
num_freq_points = N / 2;
frequency_axis = linspace(0, freq_max, num_freq_points);

% Magnitude spectrum (one-sided)
freq_spectrum = 2 * abs(FFT_result(1:num_freq_points)) / N;
freq_spectrum(1) = freq_spectrum(1) / 2;  % DC component

% ========================================================================
% 2. EXTRACT HARMONICS
% ========================================================================

% Initialize harmonics table
harmonics_table = table();

% Extract fundamental and harmonics
for n = 1:max_harmonic
    harmonic_freq = n * fundamental_freq;
    
    % Find nearest frequency bin
    [~, idx] = min(abs(frequency_axis - harmonic_freq));
    
    % Get magnitude
    if idx > 0 && idx <= length(freq_spectrum)
        magnitude = freq_spectrum(idx);
    else
        magnitude = 0;
    end
    
    % Calculate percentage of fundamental
    if n == 1
        fundamental_mag = magnitude;
        percent_fundamental = 100;
    else
        if fundamental_mag > 0
            percent_fundamental = (magnitude / fundamental_mag) * 100;
        else
            percent_fundamental = 0;
        end
    end
    
    % Add to table
    harmonics_table = [harmonics_table; table(n, harmonic_freq, magnitude, percent_fundamental, ...
        'VariableNames', {'Order', 'Frequency_Hz', 'Magnitude', 'Percent_of_Fundamental'})];
end

end

%% ========================================================================
% END OF FFT ANALYSIS FUNCTION
% ========================================================================