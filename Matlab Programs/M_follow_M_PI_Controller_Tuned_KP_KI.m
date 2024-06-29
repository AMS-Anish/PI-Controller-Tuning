% Define the transfer function of the reference motor (G_ref) and controlled motor (G_controlled)
s = tf('s');
G_ref = 0.1 / (0.01*s^2 + 0.11*s + 0.1);
G_controlled = 0.1 / (0.01*s^2 + 0.11*s + 0.1);

% Simulate the system's step response to estimate natural frequency and damping ratio
step_info = stepinfo(G_controlled);

% Extract natural frequency and damping ratio
natural_frequency = 2 * pi / step_info.PeakTime;
damping_ratio = -log(step_info.Overshoot / 100) / sqrt(pi^2 + (log(step_info.Overshoot / 100))^2);

% Use Ziegler-Nichols' 1/2 rule to calculate gains
Kp = 1.2 / (natural_frequency * damping_ratio);
Ki = 2 * damping_ratio * natural_frequency;

% Display the tuned gains
disp(['Tuned Kp: ', num2str(Kp)]);
disp(['Tuned Ki: ', num2str(Ki)]);

% Define the control system transfer function (PI controller) with tuned gains
controller = tf([Kp, Ki], [1, 0]);

% Closed-loop transfer function with the reference and controlled motors
G_closed_loop = feedback(G_controlled * controller, G_ref);

% Simulate the closed-loop system with a step input
t = 0:0.01:10;
reference_position = 0.1 * ones(size(t));
simulated_output = lsim(G_closed_loop, reference_position, t);

% Plot the results
plot(t, reference_position, 'r--', t, simulated_output);
title('Position Control with Ziegler-Nichols Tuned PI Controller');
xlabel('Time (s)');
ylabel('Position (m)');
legend('Reference Position', 'Controlled Position');
