%% ========================================================================
% POWER QUALITY CONDITIONING SYSTEM - Main Entry Point
% ========================================================================
% Purpose: Entry point for the Power Quality Conditioning System
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
% Date: 2026-06-26
% MATLAB: R2024b
%
% This script initializes the system and launches the GUI application.
% All necessary parameters are configured before launching the main GUI.
%
% ========================================================================

clear all;  % Clear all variables
close all;  % Close all figures
clc;        % Clear command window

% Add all paths
addpath(genpath(pwd));

% Display welcome message
fprintf('\n');
fprintf('================================================================================\n');
fprintf('     POWER QUALITY CONDITIONING SYSTEM FOR RESIDENTIAL APPLICATIONS\n');
fprintf('     Bachelor Thesis Project - MATLAB R2024b\n');
fprintf('================================================================================\n');
fprintf('\n');

% Initialize system parameters
fprintf('[INIT] Initializing system parameters...\n');
try
    initialize;
    fprintf('[INIT] ✓ System parameters initialized successfully\n');
catch exception
    fprintf('[ERROR] Failed to initialize system parameters:\n');
    fprintf('        %s\n', exception.message);
    return;
end

fprintf('\n[STARTUP] Launching Power Quality Application...\n\n');

% Launch GUI application
try
    PowerQualityApp;
    fprintf('[STARTUP] ✓ Application launched successfully\n');
catch exception
    fprintf('[ERROR] Failed to launch application:\n');
    fprintf('        %s\n', exception.message);
end

%% ========================================================================
% END OF MAIN SCRIPT
% ========================================================================