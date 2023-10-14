% Define the transfer function of the reference motor (G_ref) and controlled motor (G_controlled)
s = tf('s');
G_ref = 0.1 / (0.01*s^2 + 0.11*s + 0.1);
G_controlled = 0.1 / (0.01*s^2 + 0.11*s + 0.1);

% Define the control system transfer function (PI controller)
Kp = 1;     % Proportional gain
Ki = 0.1;   % Integral gain
controller = Kp + Ki/s;

% Closed-loop transfer function with the reference and controlled motors
G_closed_loop = feedback(G_controlled * controller, G_ref);

% Time vector
t = 0:0.01:10;

% Input: Ask for the reference motor position in mm
reference_position_mm = input('Enter the reference motor position in mm: ');

% Convert the reference position to meters
reference_position = reference_position_mm / 1000;

% Simulate the closed-loop system with a step input
simulated_output = lsim(G_closed_loop, reference_position * ones(size(t)), t);

% Plot the results
plot(t, reference_position * ones(size(t)), 'r--', t, simulated_output);
title('Position Control with PI Controller');
xlabel('Time (s)');
ylabel('Position (m)');
legend('Reference Position', 'Controlled Position');
