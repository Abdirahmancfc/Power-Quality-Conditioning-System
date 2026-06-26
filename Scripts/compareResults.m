%% ========================================================================
% RESULTS COMPARISON FUNCTION
% ========================================================================
% Purpose: Compare simulation results between different scenarios
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% This function compares multiple compensation devices side-by-side
%
% ========================================================================

function comparison_table = compareResults(results_cell)
% Purpose: Compare results from multiple compensation scenarios
% Input: results_cell - cell array of result structures
%                       Each element contains: name, THD, PF, V_reg, losses
% Output: comparison_table - formatted comparison table

% ========================================================================
% 1. INITIALIZE COMPARISON TABLE
% ========================================================================

% Number of scenarios
num_scenarios = length(results_cell);

% Initialize table
device_names = cell(num_scenarios, 1);
THD_values = zeros(num_scenarios, 1);
PF_values = zeros(num_scenarios, 1);
V_reg_values = zeros(num_scenarios, 1);
loss_values = zeros(num_scenarios, 1);

% ========================================================================
% 2. EXTRACT RESULTS
% ========================================================================

for i = 1:num_scenarios
    result = results_cell{i};
    
    device_names{i} = result.device_name;
    THD_values(i) = result.THD;
    PF_values(i) = result.power_factor;
    V_reg_values(i) = result.voltage_regulation;
    loss_values(i) = result.losses;
end

% ========================================================================
% 3. CREATE COMPARISON TABLE
% ========================================================================

comparison_table = table(device_names, THD_values, PF_values, V_reg_values, loss_values, ...
    'VariableNames', {'Device', 'THD_%', 'Power_Factor', 'Voltage_Regulation_%', 'Losses_%'});

% Format for display
comparison_table.Device = categorical(comparison_table.Device);

% ========================================================================
% 4. DISPLAY COMPARISON RESULTS
% ========================================================================

fprintf('\n');
fprintf('================================================================================\n');
fprintf('                        RESULTS COMPARISON TABLE\n');
fprintf('================================================================================\n');
disp(comparison_table);
fprintf('\n');

end

%% ========================================================================
% END OF COMPARISON FUNCTION
% ========================================================================