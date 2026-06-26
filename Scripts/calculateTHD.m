%% ========================================================================
% THD CALCULATION FUNCTION
% ========================================================================
% Purpose: Calculate Total Harmonic Distortion (THD)
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% THD = sqrt(sum(Vn^2 for n=2 to N)) / V1 * 100%
% where Vn are harmonic magnitudes and V1 is fundamental component
%
% ========================================================================

function [THD, harmonics, fundamental] = calculateTHD(signal, sampling_freq, max_harmonic)
% Purpose: Calculate THD from signal
% Input: signal - input signal (voltage or current)
%        sampling_freq - sampling frequency (Hz)
%        max_harmonic - maximum harmonic order to include
% Output: THD - THD percentage
%         harmonics - harmonic magnitudes (array)
%         fundamental - fundamental frequency magnitude

% Default parameters
if nargin < 2
    sampling_freq = 1e6;            % 1 MHz default sampling
end
if nargin < 3
    max_harmonic = 51;              % 51st harmonic maximum
end

% ========================================================================
% 1. PERFORM FFT ANALYSIS
% ========================================================================

% Get signal length
N = length(signal);

% Compute FFT
FFT_result = fft(signal);

% Compute frequency resolution
freq_resolution = sampling_freq / N;

% Frequency array
freq = (0:N-1) * freq_resolution;

% Magnitude spectrum (normalized)
spectrum = abs(FFT_result) / (N/2);
spectrum(1) = spectrum(1) / 2;  % DC component correction

% ========================================================================
% 2. EXTRACT FUNDAMENTAL AND HARMONICS
% ========================================================================

% Fundamental frequency (50 Hz assumed)
fundamental_freq = 50;

% Find fundamental component
[~, idx_fundamental] = min(abs(freq - fundamental_freq));
fundamental = spectrum(idx_fundamental);

% Extract harmonics
harmonics = zeros(1, max_harmonic);

for n = 1:max_harmonic
    harmonic_freq = n * fundamental_freq;
    [~, idx_harmonic] = min(abs(freq - harmonic_freq));
    harmonics(n) = spectrum(idx_harmonic);
end

% ========================================================================
% 3. CALCULATE THD
% ========================================================================

% Sum of harmonics (exclude fundamental at index 1)
if fundamental > 0
    harmonic_sum = sqrt(sum(harmonics(2:end).^2));
    THD = (harmonic_sum / fundamental) * 100;  % THD in percentage
else
    THD = 0;  % Avoid division by zero
end

% Limit THD to reasonable value
if THD > 200
    THD = 200;  % Cap at 200%
end

end

%% ========================================================================
% END OF THD CALCULATION FUNCTION
% ========================================================================