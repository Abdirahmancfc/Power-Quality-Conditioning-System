%% ========================================================================
% SYSTEM PARAMETERS DEFINITION
% ========================================================================
% Purpose: Define and return system parameters
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% This function returns system parameters organized by category
%
% ========================================================================

function params = systemParameters()
% Return all system parameters

% Access global parameters if available
global PQCS_params;

if isempty(PQCS_params)
    % If not initialized, run initialize
    initialize;
    params = PQCS_params;
else
    params = PQCS_params;
end

end

%% ========================================================================
% END OF FUNCTION
% ========================================================================