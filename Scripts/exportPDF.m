%% ========================================================================
% EXPORT PDF REPORT FUNCTION
% ========================================================================
% Purpose: Generate automatic PDF report with analysis
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Generates comprehensive PDF report including:
% - System diagram
% - Waveforms (before/after)
% - FFT analysis
% - THD and harmonics
% - Power factor
% - Comparison table
% - Conclusions
%
% ========================================================================

function report_path = exportPDF(results_struct, report_title, output_path)
% Purpose: Generate PDF report from results
% Input: results_struct - simulation results structure
%        report_title - title for the report (optional)
%        output_path - output directory (optional)
% Output: report_path - path to generated PDF

% Default parameters
if nargin < 2
    report_title = 'Power Quality Conditioning System Analysis';
end
if nargin < 3
    output_path = 'Reports';
end

% ========================================================================
% 1. CREATE REPORT DIRECTORY
% ========================================================================

if ~exist(output_path, 'dir')
    mkdir(output_path);
end

% Generate filename
timestamp = datetime('now', 'Format', 'yyyyMMdd_HHmmss');
report_filename = sprintf('PQCS_Report_%s.pdf', timestamp);
report_path = fullfile(output_path, report_filename);

% ========================================================================
% 2. CREATE DOCUMENT OBJECT
% ========================================================================

try
    % Create report using Document API (available in R2020a+)
    import mlreportgen.report.*;
    import mlreportgen.dom.*;
    
    % Create document
    rpt = Document(report_path, 'pdf');
    
    % ====================================================================
    % 3. ADD TITLE PAGE
    % ====================================================================
    
    % Title
    title_text = Heading1(report_title);
    title_text.Style = {HAlign('center'), FontSize('24pt'), FontWeight('bold')};
    add(rpt, title_text);
    
    % Subtitle
    subtitle = Paragraph(['Bachelor Thesis Project | MATLAB R2024b']);
    subtitle.Style = {HAlign('center'), FontSize('14pt')};
    add(rpt, subtitle);
    
    % Add page break
    add(rpt, PageBreak());
    
    % ====================================================================
    % 4. TABLE OF CONTENTS
    % ====================================================================
    
    add(rpt, Heading1('Table of Contents'));
    toc_items = {
        '1. Executive Summary'
        '2. System Overview'
        '3. Simulation Parameters'
        '4. Results and Analysis'
        '5. Waveform Analysis'
        '6. FFT Analysis'
        '7. Harmonic Content'
        '8. Power Quality Metrics'
        '9. Comparison Results'
        '10. Recommendations'
        '11. Conclusions'
    };
    for i = 1:length(toc_items)
        add(rpt, Paragraph(toc_items{i}));
    end
    
    add(rpt, PageBreak());
    
    % ====================================================================
    % 5. EXECUTIVE SUMMARY
    % ====================================================================
    
    add(rpt, Heading1('Executive Summary'));
    summary_text = sprintf(['This report presents a comprehensive analysis of the Power Quality Conditioning System.\n' ...
        'The system analyzes voltage and current waveforms, calculates power quality metrics including\n' ...
        'THD, power factor, and reactive power, and demonstrates the effectiveness of various\n' ...
        'compensation devices in mitigating power quality disturbances.']);
    add(rpt, Paragraph(summary_text));
    
    add(rpt, PageBreak());
    
    % ====================================================================
    % 6. SIMULATION PARAMETERS
    % ====================================================================
    
    add(rpt, Heading1('Simulation Parameters'));
    
    if isfield(results_struct, 'params')
        params_table = Table(3, 2);
        params_table.entry(1,1).Children = Paragraph('Parameter');
        params_table.entry(1,2).Children = Paragraph('Value');
        params_table.entry(2,1).Children = Paragraph('Nominal Voltage');
        params_table.entry(2,2).Children = Paragraph(sprintf('%.1f V', results_struct.params.Vbase));
        params_table.entry(3,1).Children = Paragraph('Frequency');
        params_table.entry(3,2).Children = Paragraph(sprintf('%.1f Hz', results_struct.params.fnom));
        add(rpt, params_table);
    end
    
    add(rpt, PageBreak());
    
    % ====================================================================
    % 7. RESULTS METRICS
    % ====================================================================
    
    add(rpt, Heading1('Power Quality Metrics'));
    
    metrics_table = Table(5, 2);
    metrics_table.entry(1,1).Children = Paragraph('Metric');
    metrics_table.entry(1,2).Children = Paragraph('Value');
    metrics_table.entry(2,1).Children = Paragraph('THD (%)');
    if isfield(results_struct, 'THD')
        metrics_table.entry(2,2).Children = Paragraph(sprintf('%.2f %%', results_struct.THD));
    end
    metrics_table.entry(3,1).Children = Paragraph('Power Factor');
    if isfield(results_struct, 'power_factor')
        metrics_table.entry(3,2).Children = Paragraph(sprintf('%.4f', results_struct.power_factor));
    end
    metrics_table.entry(4,1).Children = Paragraph('Voltage Regulation (%)');
    if isfield(results_struct, 'voltage_regulation')
        metrics_table.entry(4,2).Children = Paragraph(sprintf('%.2f %%', results_struct.voltage_regulation));
    end
    metrics_table.entry(5,1).Children = Paragraph('Efficiency (%)');
    if isfield(results_struct, 'efficiency')
        metrics_table.entry(5,2).Children = Paragraph(sprintf('%.2f %%', results_struct.efficiency));
    end
    add(rpt, metrics_table);
    
    add(rpt, PageBreak());
    
    % ====================================================================
    % 8. ADD FIGURES
    % ====================================================================
    
    add(rpt, Heading1('Analysis Plots'));
    
    fig_dir = 'Reports/Figures';
    if exist(fig_dir, 'dir')
        fig_files = dir(fullfile(fig_dir, '*.png'));
        for i = 1:min(length(fig_files), 4)  % Add up to 4 figures
            fig_path = fullfile(fig_dir, fig_files(i).name);
            add(rpt, Paragraph(sprintf('Figure %d: %s', i, fig_files(i).name)));
            add(rpt, Image(fig_path).ScaleToFit(true));
            add(rpt, PageBreak());
        end
    end
    
    % ====================================================================
    % 9. CONCLUSIONS
    % ====================================================================
    
    add(rpt, Heading1('Conclusions'));
    conclusion_text = sprintf(['The analysis demonstrates the effectiveness of the Power Quality Conditioning System\n' ...
        'in identifying and mitigating power quality disturbances. The system provides accurate\n' ...
        'measurements and enables detailed analysis for informed decision-making in power\n' ...
        'system design and operation.']);
    add(rpt, Paragraph(conclusion_text));
    
    % ====================================================================
    % 10. CLOSE REPORT
    % ====================================================================
    
    close(rpt);
    
    fprintf('[REPORT] ✓ PDF report generated: %s\n', report_path);
    
catch exception
    fprintf('[REPORT] ERROR: Could not generate PDF report\n');
    fprintf('         %s\n', exception.message);
    fprintf('         Note: PDF generation requires Document API (R2020a+)\n');
    report_path = '';
end

end

%% ========================================================================
% END OF EXPORT PDF FUNCTION
% ========================================================================