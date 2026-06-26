%% ========================================================================
% SYSTEM INITIALIZATION SCRIPT
% ========================================================================
% Purpose: Initialize all system parameters and configurations
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% This script sets up:
% - Grid and voltage parameters
% - Load parameters
% - Controller parameters
% - Filter parameters
% - Compensation device ratings
% - Measurement configuration
% - Simulation settings
%
% ========================================================================

fprintf('\n[INITIALIZE] Loading system configuration...\n');

% ========================================================================
% 1. GRID AND SOURCE PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting grid parameters...\n');

% Nominal voltage
params.Vnom_phase = 230;           % Nominal phase voltage (V)
params.Vnom_line = 400;            % Nominal line voltage (V)
params.Vbase = 230;                % Base voltage for per-unit (V)
params.Vbase_3ph = 400;            % Base voltage 3-phase (V)

% Nominal frequency
params.fnom = 50;                  % Nominal frequency (Hz)
params.fbase = 50;                 % Base frequency (Hz)
params.wbase = 2*pi*params.fbase;  % Base angular frequency (rad/s)

% Source impedance
params.Zs = 0.5;                   % Source impedance (Ohm)
params.Rs = 0.1;                   % Source resistance (Ohm)
params.Ls = 1e-3;                  % Source inductance (H)

% ========================================================================
% 2. TRANSFORMER PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting transformer parameters...\n');

params.Snom_transformer = 50e3;    % Transformer rated power (VA)
params.V1nom = 400;                % Transformer primary voltage (V)
params.V2nom = 230;                % Transformer secondary voltage (V)
params.Rcc = 0.02;                 % Short circuit resistance (pu)
params.Xcc = 0.04;                 % Short circuit reactance (pu)
params.Rcore = 10000;              % Core resistance (Ohm)
params.Lm = 0.1;                   % Magnetizing inductance (H)
params.Turns_ratio = params.V1nom/params.V2nom;  % Turns ratio

% ========================================================================
% 3. LOAD PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting load parameters...\n');

% Load composition
params.P_resistive = 5e3;          % Resistive load (W)
params.P_RL = 3e3;                 % RL load (W)
params.P_motor = 2e3;              % Motor load (W)
params.P_rectifier = 4e3;          % Rectifier load (W)
params.P_LED = 1e3;                % LED driver load (W)
params.P_capacitor = 1e3;          % Capacitive load (var)

% Total load
params.P_total = params.P_resistive + params.P_RL + params.P_motor + ...
                 params.P_rectifier + params.P_LED;  % Total active power (W)
params.Q_total = params.P_capacitor;                 % Total reactive power (var)

% Individual load parameters
params.R_resistive = params.Vbase^2 / params.P_resistive;  % Resistance (Ohm)
params.R_RL = 10;                  % RL load resistance (Ohm)
params.L_RL = 0.05;                % RL load inductance (H)
params.Motor_efficiency = 0.85;    % Motor efficiency
params.Motor_pf = 0.8;             % Motor power factor
params.Rectifier_pf = 0.6;         % Rectifier power factor

% Load variation
params.Load_min = 0.3;             % Minimum load (pu)
params.Load_max = 1.0;             % Maximum load (pu)
params.Load_step = 0.1;            % Load step change (pu)

% ========================================================================
% 4. FAULT PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting fault parameters...\n');

% Voltage sag
params.sag_depth = 0.3;            % Sag depth (pu) - 0 to 1
params.sag_duration = 0.1;         % Sag duration (s)
params.sag_start_time = 1.0;       % Sag start time (s)

% Voltage swell
params.swell_magnitude = 0.2;      % Swell magnitude (pu)
params.swell_duration = 0.1;       % Swell duration (s)
params.swell_start_time = 1.0;     % Swell start time (s)

% Harmonics
params.harmonic_orders = [5, 7, 11, 13];  % Harmonic orders to include
params.harmonic_magnitude = [0.1, 0.08, 0.05, 0.03];  % Harmonic magnitudes (pu)

% Interruption
params.interruption_duration = 0.05;    % Interruption duration (s)
params.interruption_start = 1.0;        % Interruption start time (s)

% Frequency variation
params.freq_deviation = 2;          % Frequency deviation (Hz)
params.freq_ramp_time = 0.5;        % Frequency ramp time (s)

% Flicker
params.flicker_depth = 0.05;        % Flicker depth (pu)
params.flicker_frequency = 5;       % Flicker frequency (Hz)

% Transients
params.transient_magnitude = 0.5;   % Transient magnitude (pu)
params.transient_duration = 0.001;  % Transient duration (s)
params.transient_time = 1.0;        % Transient occurrence time (s)

% Faults
params.fault_type = 'none';         % Fault type: 'SLG', 'LL', 'DLG', '3PH', 'none'
params.fault_resistance = 0.1;      % Fault resistance (Ohm)
params.fault_duration = 0.1;        % Fault duration (s)
params.fault_start_time = 1.0;      % Fault start time (s)

% ========================================================================
% 5. PASSIVE FILTER PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting passive filter parameters...\n');

% Single-tuned filter
params.Cf_single = 100e-6;          % Filter capacitance (F)
params.Lf_single = 0.01;            % Filter inductance (H)
params.Rf_single = 0.5;             % Filter resistance (Ohm)
params.f_tuned = 250;               % Tuned frequency (Hz) - 5th harmonic

% High-pass filter
params.Cf_highpass = 50e-6;         % Capacitance (F)
params.Lf_highpass = 0.02;          % Inductance (H)
params.f_highpass = 350;            % High-pass frequency (Hz)

% Hybrid filter
params.Cf_hybrid = 75e-6;           % Hybrid filter capacitance (F)
params.Lf_hybrid = 0.015;           % Hybrid filter inductance (H)
params.Rf_hybrid = 0.3;             % Hybrid filter resistance (Ohm)

% ========================================================================
% 6. ACTIVE FILTER PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting active filter parameters...\n');

% Shunt active filter
params.Snom_APF_shunt = 10e3;       % Rated power (VA)
params.Vdc_APF_shunt = 800;         % DC link voltage (V)
params.Cdc_APF = 5000e-6;           % DC link capacitance (F)
params.L_APF_shunt = 5e-3;          % Output inductance (H)
params.R_APF_shunt = 0.1;           % Output resistance (Ohm)
params.fsw_APF = 10e3;              % Switching frequency (Hz)
params.bandwidth_APF = 500;         % Bandwidth (Hz)

% Series active filter
params.Snom_APF_series = 5e3;       % Rated power (VA)
params.Vdc_APF_series = 400;        % DC link voltage (V)
params.fsw_APF_series = 5e3;        % Switching frequency (Hz)

% ========================================================================
% 7. DYNAMIC VOLTAGE RESTORER (DVR) PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting DVR parameters...\n');

params.Snom_DVR = 15e3;             % Rated power (VA)
params.Vdc_DVR = 800;               % DC link voltage (V)
params.Cdc_DVR = 5000e-6;           % DC link capacitance (F)
params.L_DVR = 10e-3;               % Series inductance (H)
params.R_DVR = 0.2;                 % Series resistance (Ohm)
params.fsw_DVR = 5e3;               % Switching frequency (Hz)
params.response_time_DVR = 0.5e-3;  % Response time (s)
params.max_voltage_injection = 0.5; % Max injection (pu)

% ========================================================================
% 8. STATCOM PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting STATCOM parameters...\n');

params.Snom_STATCOM = 20e3;         % Rated power (VA)
params.Vdc_STATCOM = 1000;          % DC link voltage (V)
params.Cdc_STATCOM = 8000e-6;       % DC link capacitance (F)
params.L_STATCOM = 5e-3;            % Reactor inductance (H)
params.R_STATCOM = 0.15;            % Reactor resistance (Ohm)
params.fsw_STATCOM = 3e3;           % Switching frequency (Hz)
params.Q_max_STATCOM = 20e3;        % Maximum reactive power (var)
params.Q_min_STATCOM = -20e3;       % Minimum reactive power (var)

% ========================================================================
% 9. STATIC VAR COMPENSATOR (SVC) PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting SVC parameters...\n');

params.Qc_SVC = 15e3;               % Fixed capacitor (var)
params.QL_SVC = 20e3;               % Thyristor controlled reactor (var)
params.response_time_SVC = 10e-3;   % Response time (s)

% ========================================================================
% 10. UPQC PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting UPQC parameters...\n');

params.Snom_UPQC = 25e3;            % Rated power (VA)
params.Vdc_UPQC = 1000;             % DC link voltage (V)
params.Cdc_UPQC = 10000e-6;         % DC link capacitance (F)
params.L_series = 10e-3;            % Series inductance (H)
params.L_shunt = 5e-3;              % Shunt inductance (H)
params.fsw_UPQC = 5e3;              % Switching frequency (Hz)

% ========================================================================
% 11. CONTROLLER PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting controller parameters...\n');

% PI Controller
params.Kp_PI = 10;                  % Proportional gain
params.Ki_PI = 50;                  % Integral gain
params.Kd_PI = 0;                   % Derivative gain
params.tau_PI = 0.01;               % Time constant (s)

% PLL (Phase-Locked Loop)
params.Kp_PLL = 100;                % PLL proportional gain
params.Ki_PLL = 5000;               % PLL integral gain
params.PLL_BW = 100;                % PLL bandwidth (Hz)
params.PLL_damping = 0.707;         % PLL damping factor

% PWM (Pulse Width Modulation)
params.fsw_PWM = 10e3;              % PWM switching frequency (Hz)
params.Tsw_PWM = 1/params.fsw_PWM;  % PWM period (s)
params.dead_time = 1e-6;            % Dead time (s)

% Hysteresis current controller
params.hysteresis_band = 0.5;       % Hysteresis band (A)

% Voltage/Current reference generator
params.ref_gen_settling_time = 0.01; % Reference settling time (s)

% ========================================================================
% 12. MEASUREMENT PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting measurement parameters...\n');

params.Ts_measurement = 1e-6;       % Measurement sample time (s)
params.Ts_display = 1e-4;           % Display sample time (s)
params.filter_lpf_cutoff = 10e3;    % LPF cutoff frequency (Hz)
params.FFT_resolution = 1;          % FFT resolution (Hz)
params.FFT_max_harmonic = 51;       % Maximum harmonic to measure

% Thresholds
params.THD_limit = 5;               % THD limit (%) - IEEE-519
params.PF_target = 0.95;            % Target power factor
params.voltage_tolerance = 0.1;     % Voltage tolerance (pu) ±10%

% ========================================================================
% 13. SIMULATION PARAMETERS
% ========================================================================
fprintf('[PARAM] Setting simulation parameters...\n');

params.Ts_sim = 1e-5;               % Simulation time step (s)
params.t_final = 3;                 % Simulation final time (s)
params.t_transient = 0.5;           % Transient settling time (s)

% Solver settings
params.solver = 'ode45';            % ODE solver: 'ode45', 'ode23', etc.
params.relative_tol = 1e-3;         % Relative tolerance
params.absolute_tol = 1e-6;         % Absolute tolerance

% ========================================================================
% 14. DEFAULT SETTINGS
% ========================================================================
fprintf('[PARAM] Setting default application settings...\n');

% Selected devices
params.device_enabled = 'none';     % Selected compensation device
params.fault_enabled = false;       % Fault injection
params.disturbance_type = 'none';   % Disturbance type

% Simulation state
params.sim_running = false;         % Simulation running flag
params.sim_paused = false;          % Simulation paused flag
params.results_available = false;   % Results available flag

% ========================================================================
% 15. STORE PARAMETERS IN GLOBAL VARIABLE
% ========================================================================
fprintf('[PARAM] Saving parameters to global variable...\n');

% Save to global variable for access throughout application
global PQCS_params;
PQCS_params = params;

% Display initialization summary
fprintf('[INIT] ✓ System parameters initialized:\n');
fprintf('       - Nominal Voltage: %g V\n', params.Vnom_phase);
fprintf('       - Nominal Frequency: %g Hz\n', params.fnom);
fprintf('       - Total Load: %g W\n', params.P_total);
fprintf('       - Transformer Rating: %g kVA\n', params.Snom_transformer/1e3);
fprintf('\n');

%% ========================================================================
% END OF INITIALIZATION SCRIPT
% ========================================================================