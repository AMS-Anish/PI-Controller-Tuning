% Define the transfer function of the reference motor (G_ref) and controlled motor (G_controlled)
s = tf('s');
G_ref = 0.1 / (0.01*s^2 + 0.11*s + 0.1);
G_controlled = 0.1 / (0.01*s^2 + 0.11*s + 0.1);

% Input: Manually enter the values of Kp and Ki
Kp = input('Enter the value of Kp: ');
Ki = input('Enter the value of Ki: ');

% Define the control system transfer function (PI controller) with the specified gains
controller = tf([Kp, Ki], [1, 0]);

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
title('Position Control with Manually Specified Kp and Ki');
xlabel('Time (s)');
ylabel('Position (m)');
legend('Reference Position', 'Controlled Position');
