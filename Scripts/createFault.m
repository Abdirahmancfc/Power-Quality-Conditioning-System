%% ========================================================================
% FAULT CREATION FUNCTION
% ========================================================================
% Purpose: Generate different types of electrical faults
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Fault types:
% - SLG: Single Line to Ground
% - LL: Line to Line
% - DLG: Double Line to Ground
% - 3PH: Three Phase Balanced
%
% ========================================================================

function [faulty_voltage, fault_signal] = createFault(voltage, time, fault_type, fault_start, fault_duration, fault_resistance, Zg)
% Purpose: Create different types of faults
% Input: voltage - original 3-phase voltage (Va, Vb, Vc) - matrix [3 x N]
%        time - time vector
%        fault_type - 'SLG' (Single Line Ground), 'LL', 'DLG', '3PH'
%        fault_start - fault start time (s)
%        fault_duration - fault duration (s)
%        fault_resistance - fault resistance (Ohm)
%        Zg - ground impedance (Ohm) - default 0.1
% Output: faulty_voltage - voltage with fault applied
%         fault_signal - binary fault indicator signal

% Default parameters
if nargin < 7
    Zg = 0.1;  % Ground impedance
end

% ========================================================================
% 1. IDENTIFY FAULT WINDOW
% ========================================================================

% Find indices for fault window
fault_idx_start = find(time >= fault_start, 1);
fault_idx_end = find(time >= (fault_start + fault_duration), 1);

if isempty(fault_idx_start)
    fault_idx_start = 1;
end
if isempty(fault_idx_end)
    fault_idx_end = length(time);
end

% ========================================================================
% 2. CREATE FAULT SIGNAL
% ========================================================================

faulty_voltage = voltage;
fault_signal = zeros(1, length(time));
fault_signal(fault_idx_start:fault_idx_end) = 1;  % Fault active

% ========================================================================
% 3. APPLY DIFFERENT FAULT TYPES
% ========================================================================

switch upper(fault_type)
    
    case 'SLG'  % Single Line to Ground Fault on Phase A
        % Phase A is grounded
        % Voltage across fault: Va + Zg*Ia = 0
        % Simplified: Set phase A to ground (0V)
        faulty_voltage(1, fault_idx_start:fault_idx_end) = ...
            fault_resistance / (fault_resistance + Zg) * voltage(1, fault_idx_start:fault_idx_end);
        
        fprintf('[FAULT] Single Line-to-Ground (SLG) fault applied on Phase A\n');
        
    case 'LL'   % Line-to-Line Fault (Phase B-C)
        % Phase B and C are short-circuited
        % Vb = Vc at fault point
        fault_impedance = fault_resistance + Zg;
        
        % Current through fault
        for i = fault_idx_start:fault_idx_end
            V_diff = voltage(2, i) - voltage(3, i);
            fault_current = V_diff / fault_impedance;
            
            faulty_voltage(2, i) = voltage(2, i) - fault_current * fault_resistance;
            faulty_voltage(3, i) = voltage(3, i) + fault_current * fault_resistance;
        end
        
        fprintf('[FAULT] Line-to-Line (LL) fault applied between Phase B-C\n');
        
    case 'DLG'  % Double Line to Ground Fault (Phase B, C to ground)
        % Phases B and C are grounded
        faulty_voltage(2, fault_idx_start:fault_idx_end) = ...
            fault_resistance / (fault_resistance + Zg) * voltage(2, fault_idx_start:fault_idx_end);
        faulty_voltage(3, fault_idx_start:fault_idx_end) = ...
            fault_resistance / (fault_resistance + Zg) * voltage(3, fault_idx_start:fault_idx_end);
        
        fprintf('[FAULT] Double Line-to-Ground (DLG) fault applied on Phase B-C\n');
        
    case '3PH'  % Three Phase Fault (Balanced)
        % All phases short to ground
        faulty_voltage(1, fault_idx_start:fault_idx_end) = ...
            fault_resistance / (fault_resistance + Zg) * voltage(1, fault_idx_start:fault_idx_end);
        faulty_voltage(2, fault_idx_start:fault_idx_end) = ...
            fault_resistance / (fault_resistance + Zg) * voltage(2, fault_idx_start:fault_idx_end);
        faulty_voltage(3, fault_idx_start:fault_idx_end) = ...
            fault_resistance / (fault_resistance + Zg) * voltage(3, fault_idx_start:fault_idx_end);
        
        fprintf('[FAULT] Three-Phase (3PH) fault applied\n');
        
    otherwise
        error('Unknown fault type. Use: SLG, LL, DLG, 3PH');
end

% ========================================================================
% 4. DISPLAY FAULT INFORMATION
% ========================================================================

fprintf('        - Start Time: %.3f s\n', fault_start);
fprintf('        - Duration: %.3f s\n', fault_duration);
fprintf('        - Fault Resistance: %.3f Ohm\n', fault_resistance);
fprintf('        - Ground Impedance: %.3f Ohm\n', Zg);

end

%% ========================================================================
% END OF FAULT CREATION FUNCTION
% ========================================================================