%% ========================================================================
% PLOT RESULTS FUNCTION
% ========================================================================
% Purpose: Generate publication-quality plots from simulation results
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Generates multiple figures showing:
% - Voltage waveforms
% - Current waveforms
% - Power analysis
% - FFT spectrum
% - Comparison before/after
%
% ========================================================================

function plotResults(time, voltage, current, harmonic_data, PF, THD, save_path)
% Purpose: Create comprehensive result plots
% Input: time - time vector (s)
%        voltage - voltage signal (V)
%        current - current signal (A)
%        harmonic_data - harmonic content table
%        PF - power factor
%        THD - THD percentage
%        save_path - path to save figures (optional)
% Output: Multiple figure files

% Default parameters
if nargin < 7
    save_path = 'Reports/Figures/';
end

% Create directory if it doesn't exist
if ~exist(save_path, 'dir')
    mkdir(save_path);
end

% ========================================================================
% 1. VOLTAGE WAVEFORM PLOT
% ========================================================================

figure('Name', 'Voltage Waveform', 'NumberTitle', 'off');
plot(time, voltage, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]);
grid on;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Voltage (V)', 'FontSize', 12, 'FontWeight', 'bold');
title('Voltage Waveform', 'FontSize', 14, 'FontWeight', 'bold');
legend('V(t)', 'FontSize', 11);
set(gca, 'FontSize', 11);

% Add grid and formatting
set(gcf, 'Color', 'white');
set(gca, 'XGrid', 'on', 'YGrid', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.3);

% Save figure
if exist(save_path, 'dir')
    saveas(gcf, fullfile(save_path, 'voltage_waveform.png'));
end

% ========================================================================
% 2. CURRENT WAVEFORM PLOT
% ========================================================================

figure('Name', 'Current Waveform', 'NumberTitle', 'off');
plot(time, current, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]);
grid on;
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Current (A)', 'FontSize', 12, 'FontWeight', 'bold');
title('Current Waveform', 'FontSize', 14, 'FontWeight', 'bold');
legend('I(t)', 'FontSize', 11);
set(gca, 'FontSize', 11);
set(gcf, 'Color', 'white');
set(gca, 'XGrid', 'on', 'YGrid', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.3);

if exist(save_path, 'dir')
    saveas(gcf, fullfile(save_path, 'current_waveform.png'));
end

% ========================================================================
% 3. FFT SPECTRUM PLOT
% ========================================================================

figure('Name', 'FFT Spectrum', 'NumberTitle', 'off');

% Calculate FFT
N = length(voltage);
dt = time(2) - time(1);
fs = 1/dt;
freq = (0:N-1) * fs/N;

Voltage_fft = abs(fft(voltage))*2/N;
freq_plot = freq(1:N/2);
voltage_fft_plot = Voltage_fft(1:N/2);

% Plot FFT (zoomed to 0-500 Hz)
max_freq = 500;
freq_idx = find(freq_plot <= max_freq);

stem(freq_plot(freq_idx), voltage_fft_plot(freq_idx), 'filled', 'LineWidth', 2);
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Magnitude (V)', 'FontSize', 12, 'FontWeight', 'bold');
title('FFT Spectrum - Voltage', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
set(gca, 'FontSize', 11);
set(gcf, 'Color', 'white');

if exist(save_path, 'dir')
    saveas(gcf, fullfile(save_path, 'fft_spectrum.png'));
end

% ========================================================================
% 4. HARMONICS BAR CHART
% ========================================================================

figure('Name', 'Harmonics Analysis', 'NumberTitle', 'off');

if istable(harmonic_data)
    bar(harmonic_data.Order, harmonic_data.Magnitude, 'FaceColor', [0.2 0.6 1.0], 'EdgeColor', 'black', 'LineWidth', 1.5);
    xlabel('Harmonic Order', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Magnitude (V)', 'FontSize', 12, 'FontWeight', 'bold');
    title(sprintf('Harmonic Content (THD = %.2f%%)', THD), 'FontSize', 14, 'FontWeight', 'bold');
    grid on;
    set(gca, 'FontSize', 11);
    set(gcf, 'Color', 'white');
end

if exist(save_path, 'dir')
    saveas(gcf, fullfile(save_path, 'harmonics_analysis.png'));
end

% ========================================================================
% 5. POWER QUALITY INDICATORS
% ========================================================================

figure('Name', 'Power Quality Metrics', 'NumberTitle', 'off');

% Create subplots for metrics
subplot(2,2,1);
text(0.5, 0.5, sprintf('THD\n%.2f%%', THD), 'HorizontalAlignment', 'center', ...
      'VerticalAlignment', 'middle', 'FontSize', 24, 'FontWeight', 'bold');
set(gca, 'XLim', [0 1], 'YLim', [0 1], 'XTick', [], 'YTick', []);
title('Total Harmonic Distortion', 'FontSize', 12, 'FontWeight', 'bold');

subplot(2,2,2);
text(0.5, 0.5, sprintf('Power Factor\n%.4f', PF), 'HorizontalAlignment', 'center', ...
      'VerticalAlignment', 'middle', 'FontSize', 24, 'FontWeight', 'bold');
set(gca, 'XLim', [0 1], 'YLim', [0 1], 'XTick', [], 'YTick', []);
title('Power Factor', 'FontSize', 12, 'FontWeight', 'bold');

subplot(2,2,3);
V_rms = sqrt(mean(voltage.^2));
text(0.5, 0.5, sprintf('V RMS\n%.1f V', V_rms), 'HorizontalAlignment', 'center', ...
      'VerticalAlignment', 'middle', 'FontSize', 24, 'FontWeight', 'bold');
set(gca, 'XLim', [0 1], 'YLim', [0 1], 'XTick', [], 'YTick', []);
title('RMS Voltage', 'FontSize', 12, 'FontWeight', 'bold');

subplot(2,2,4);
I_rms = sqrt(mean(current.^2));
text(0.5, 0.5, sprintf('I RMS\n%.2f A', I_rms), 'HorizontalAlignment', 'center', ...
      'VerticalAlignment', 'middle', 'FontSize', 24, 'FontWeight', 'bold');
set(gca, 'XLim', [0 1], 'YLim', [0 1], 'XTick', [], 'YTick', []);
title('RMS Current', 'FontSize', 12, 'FontWeight', 'bold');

set(gcf, 'Color', 'white');

if exist(save_path, 'dir')
    saveas(gcf, fullfile(save_path, 'pq_metrics.png'));
end

% ========================================================================
% 6. DISPLAY COMPLETION MESSAGE
% ========================================================================

fprintf('[PLOT] ✓ Figures saved to: %s\n', save_path);

end

%% ========================================================================
% END OF PLOT RESULTS FUNCTION
% ========================================================================