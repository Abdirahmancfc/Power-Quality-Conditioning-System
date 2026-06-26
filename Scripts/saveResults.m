%% ========================================================================
% SAVE RESULTS FUNCTION
% ========================================================================
% Purpose: Save simulation results to MAT file
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Saves all results in MAT format for later analysis
%
% ========================================================================

function save_filename = saveResults(results_struct, filename)
% Purpose: Save simulation results to file
% Input: results_struct - structure containing all results
%        filename - output filename (optional)
% Output: save_filename - path to saved file

% Default filename
if nargin < 2
    timestamp = datetime('now', 'Format', 'yyyyMMdd_HHmmss');
    filename = sprintf('simulation_results_%s.mat', timestamp);
end

% Create data directory if it doesn't exist
data_dir = 'Data';
if ~exist(data_dir, 'dir')
    mkdir(data_dir);
end

% Full path
save_filename = fullfile(data_dir, filename);

% ========================================================================
% 1. SAVE RESULTS
% ========================================================================

try
    save(save_filename, 'results_struct');
    fprintf('[SAVE] ✓ Results saved to: %s\n', save_filename);
catch exception
    fprintf('[SAVE] ERROR: Failed to save results\n');
    fprintf('       %s\n', exception.message);
    save_filename = '';
end

end

%% ========================================================================
% END OF SAVE RESULTS FUNCTION
% ========================================================================