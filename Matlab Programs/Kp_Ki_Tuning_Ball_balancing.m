% Define system parameters
J = 0.1;   % Increase the moment of inertia
b = 0.1;   % Increase the damping coefficient
m = .1;   % Keep the ball mass the same
L = 1.0;   % Keep the distance from pivot to ball's center the same
g = 9.81;  % Gravity

% Transfer function parameters
num = -m * g * L;
den = [J, b, 0.1];

% Create the transfer function
sys = tf(num, den);

% Define desired specifications
settling_time = 1.0;  % Settling time (adjust as needed)
overshoot = 10;        % Percent overshoot (adjust as needed)
desired_specs = stepinfo(sys, 'SettlingTimeThreshold', 0.02);

% Calculate PI controller gains
Kp = (1.2 * desired_specs.Overshoot) / (m * g * L);
Ki = (1.2 / settling_time) * (m * g * L);

% Check if Kp and Ki are real and finite
if isfinite(Kp) && isreal(Kp) && isfinite(Ki) && isreal(Ki)
    % Create the PI controller
    controller = pid(Kp, Ki);

    % Define the closed-loop system
    closed_loop_sys = feedback(controller * sys, 1);

    % Simulate and plot the step response
t = 0:0.01:15;  % Extend the simulation duration
step(closed_loop_sys, t);
grid on;
title('Step Response with Tuned PI Controller');

% Display the controller gains
disp(['Tuned Kp: ', num2str(Kp)]);
disp(['Tuned Ki: ', num2str(Ki)]);
else
    disp('Error: Invalid controller gains (Kp and/or Ki). Please adjust the system parameters or specifications.');
end
