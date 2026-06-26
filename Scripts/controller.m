%% ========================================================================
% CONTROLLER IMPLEMENTATION
% ========================================================================
% Purpose: Implement control algorithms for active filters and DVR
% Author: Senior MATLAB/Simulink Engineer
% Version: 1.0
%
% Controllers implemented:
% - PI Controller
% - Phase-Locked Loop (PLL)
% - Reference Signal Generator
% - PWM Generator
%
% ========================================================================

%% Function 1: PI Controller
function [output, integral] = PIController(error, Kp, Ki, integral_prev, dt, output_limits)
% Purpose: Discrete-time PI controller
% Input: error - controller error
%        Kp - proportional gain
%        Ki - integral gain
%        integral_prev - previous integral sum
%        dt - time step
%        output_limits - [min max] limits for output (optional)
% Output: output - controller output
%         integral - updated integral sum

% Default limits
if nargin < 6
    output_limits = [-inf, inf];
end

% Proportional term
P_term = Kp * error;

% Integral term
integral = integral_prev + Ki * error * dt;

% Anti-windup: limit integral term
integral = max(min(integral, output_limits(2)/Ki), output_limits(1)/Ki);

% Total output
output = P_term + integral;

% Limit output
output = max(min(output, output_limits(2)), output_limits(1));

end

%% Function 2: Phase-Locked Loop (PLL)
function [theta, omega, state] = PLL(v_signal, state_prev, Kp, Ki, dt)
% Purpose: Synchronous reference frame PLL
% Input: v_signal - input voltage signal
%        state_prev - previous PLL state
%        Kp - proportional gain
%        Ki - integral gain
%        dt - time step
% Output: theta - grid phase angle
%         omega - grid angular frequency
%         state - updated state structure

% Initial state
if nargin < 2 || isempty(state_prev)
    state.theta_prev = 0;
    state.integral = 0;
    state.omega_prev = 2*pi*50;  % 50 Hz
else
    state = state_prev;
end

% Error signal (simplified: use sine of phase angle)
error = v_signal * sin(state.theta_prev);

% PI controller
[control_output, state.integral] = PIController(error, Kp, Ki, state.integral, dt);

% Update angular frequency
omega = state.omega_prev + control_output;

% Update phase
theta = state.theta_prev + omega * dt;

% Normalize angle to [0, 2*pi]
theta = mod(theta, 2*pi);

% Store for next iteration
state.theta_prev = theta;
state.omega_prev = omega;

end

%% Function 3: Reference Signal Generator
function [ref_signal] = ReferenceGenerator(THD_measured, PF_measured, V_rms, I_rms, mode)
% Purpose: Generate reference signal for active filter or DVR
% Input: THD_measured - measured THD
%        PF_measured - measured power factor
%        V_rms - RMS voltage
%        I_rms - RMS current
%        mode - 'harmonic', 'reactive', 'combined' (optional)
% Output: ref_signal - reference signal for compensation

if nargin < 5
    mode = 'harmonic';  % Default: harmonic compensation
end

% Decision logic based on power quality
switch mode
    
    case 'harmonic'
        % Compensate harmonics if THD > 5%
        if THD_measured > 5
            ref_signal = 1;  % Enable harmonic compensation
        else
            ref_signal = 0;  % Disable
        end
        
    case 'reactive'
        % Compensate reactive power if PF < 0.95
        if PF_measured < 0.95
            ref_signal = 1;  % Enable reactive power compensation
        else
            ref_signal = 0;  % Disable
        end
        
    case 'combined'
        % Combine harmonic and reactive compensation
        harmonic_need = (THD_measured > 5);
        reactive_need = (PF_measured < 0.95);
        ref_signal = harmonic_need || reactive_need;
        
    otherwise
        error('Unknown mode. Use: harmonic, reactive, combined');
end

end

%% Function 4: PWM Generator (Space Vector PWM)
function [PWM_A, PWM_B, PWM_C] = PWMGenerator(Vd, Vq, Vdc, fsw, theta)
% Purpose: Generate PWM signals using space vector modulation
% Input: Vd - d-axis voltage command (V)
%        Vq - q-axis voltage command (V)
%        Vdc - DC link voltage (V)
%        fsw - switching frequency (Hz)
%        theta - phase angle (rad)
% Output: PWM_A, PWM_B, PWM_C - PWM duty cycles for phases

% ========================================================================
% 1. INVERSE PARK TRANSFORMATION
% ========================================================================

% Transform from dq to abc
Valpha = Vd * cos(theta) - Vq * sin(theta);
Vbeta = Vd * sin(theta) + Vq * cos(theta);

% ========================================================================
% 2. SPACE VECTOR MODULATION
% ========================================================================

% Calculate magnitude and angle
Vmag = sqrt(Valpha^2 + Vbeta^2);
Vangle = atan2(Vbeta, Valpha);

% Calculate modulation index
Mi = Vmag / (Vdc/sqrt(3));

% Limit modulation index
Mi = min(Mi, 0.95);

% Calculate duty cycles using SVM
T_sector = Vangle / (pi/3);  % Sector determination
sector = floor(mod(T_sector, 6));

% SVM calculation (simplified)
switch sector
    case {0, 5}  % Sector 1
        PWM_A = 0.5 + (Mi/3) * (cos(Vangle) + sqrt(3)*sin(Vangle));
        PWM_B = 0.5 + (Mi/3) * (-cos(Vangle) + sqrt(3)*sin(Vangle));
        PWM_C = 0.5 - (Mi/3) * sqrt(3) * sin(Vangle);
    otherwise
        % Simplified uniform distribution
        PWM_A = 0.5 + 0.5 * Mi * cos(Vangle);
        PWM_B = 0.5 + 0.5 * Mi * cos(Vangle - 2*pi/3);
        PWM_C = 0.5 + 0.5 * Mi * cos(Vangle - 4*pi/3);
end

% Limit to [0, 1]
PWM_A = max(min(PWM_A, 1), 0);
PWM_B = max(min(PWM_B, 1), 0);
PWM_C = max(min(PWM_C, 1), 0);

end

%% ========================================================================
% END OF CONTROLLER IMPLEMENTATION
% ========================================================================