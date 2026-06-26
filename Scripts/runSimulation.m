%% ========================================================================
% RUN SIMULATION FUNCTION
% ========================================================================
% Purpose: Execute Simulink simulation with specified parameters
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% This function sets up and runs the main Simulink model
%
% ========================================================================

function [simout, time_vector] = runSimulation(params)
% Purpose: Run the Simulink model with given parameters
% Input: params - parameter structure containing all simulation settings
% Output: simout - simulation output structure
%         time_vector - time vector from simulation

% ========================================================================
% 1. VALIDATE INPUT PARAMETERS
% ========================================================================

fprintf('[SIM] Validating simulation parameters...\n');

if ~isstruct(params)
    error('Input must be a parameter structure');
end

% ========================================================================
% 2. CONFIGURE SIMULATION SETTINGS
% ========================================================================

fprintf('[SIM] Loading Simulink model...\n');

% Model name
model_name = 'Main_PQCS_Model';

% Check if model is already open
if ~bdIsLoaded(model_name)
    try
        load_system(model_name);
        fprintf('[SIM] ✓ Model loaded successfully\n');
    catch exception
        fprintf('[SIM] ERROR: Could not load model: %s\n', exception.message);
        return;
    end
end

% ========================================================================
% 3. SET SIMULINK PARAMETERS
% ========================================================================

fprintf('[SIM] Configuring simulation parameters...\n');

try
    % Set solver parameters
    set_param(model_name, 'Solver', 'ode45');
    set_param(model_name, 'SolverType', 'Variable-step');
    set_param(model_name, 'StopTime', num2str(params.t_final));
    set_param(model_name, 'RelTol', num2str(params.relative_tol));
    set_param(model_name, 'AbsTol', num2str(params.absolute_tol));
    set_param(model_name, 'MaxStep', num2str(params.Ts_sim));
    
    % Set workspace parameters
    assignin('base', 'params', params);
    
    fprintf('[SIM] ✓ Simulation parameters configured\n');
    
catch exception
    fprintf('[SIM] ERROR setting parameters: %s\n', exception.message);
    return;
end

% ========================================================================
% 4. RUN SIMULATION
% ========================================================================

fprintf('[SIM] Running simulation...\n');
fprintf('[SIM] Simulation time: %.2f seconds\n', params.t_final);

try
    % Run simulation
    simout = sim(model_name, params);
    
    fprintf('[SIM] ✓ Simulation completed successfully\n');
    
catch exception
    fprintf('[SIM] ERROR during simulation: %s\n', exception.message);
    return;
end

% ========================================================================
% 5. EXTRACT RESULTS
% ========================================================================

fprintf('[SIM] Extracting simulation results...\n');

% Get time vector
if isfield(simout, 'tout')
    time_vector = simout.tout;
else
    time_vector = [];
end

fprintf('[SIM] ✓ Results extracted (%.0f data points)\n', length(time_vector));

% ========================================================================
% 6. DISPLAY SIMULATION SUMMARY
% ========================================================================

fprintf('\n[SIM] ====== SIMULATION SUMMARY ======\n');
fprintf('[SIM] Model: %s\n', model_name);
fprintf('[SIM] Duration: %.2f s\n', params.t_final);
fprintf('[SIM] Time Step: %.2e s\n', params.Ts_sim);
fprintf('[SIM] Data Points: %.0f\n', length(time_vector));
fprintf('[SIM] Voltage Base: %.1f V\n', params.Vbase);
fprintf('[SIM] Frequency: %.1f Hz\n', params.fnom);
fprintf('[SIM] Total Load: %.1f kW\n', params.P_total/1000);
fprintf('[SIM] ================================\n\n');

end

%% ========================================================================
% END OF RUN SIMULATION FUNCTION
% ========================================================================