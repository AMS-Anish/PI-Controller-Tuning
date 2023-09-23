% Define the simplified plant transfer function Gp(s) with negligible mass and damping
% Replace these arbitrary values with actual values from your system
initial_stiffness = 100;  % Initial stiffness based on sensor reading (N/m)

% Define the transfer function coefficients for the simplified plant
num = [1];  % Arbitrary numerator coefficients
den = [initial_stiffness];  % Stiffness initially based on sensor (N/m)

Gp = tf(num, den);

% Define the servo motor transfer function Gs(s)
% Replace these arbitrary values with actual values from your system
motor_gain = 2;      % Gain of the motor control system
motor_time_constant = 0.1;  % Time constant of the motor (s)

num = [motor_gain];
den = [motor_time_constant, 1];
Gs = tf(num, den);

% Define the PI controller transfer function Gc(s)
% Replace these arbitrary values with actual gains
Kp = 1.5;   % Proportional gain
Ki = 0.5;   % Integral gain

num = [Kp, Ki];
den = [1, 0];  % Integral action
Gc = tf(num, den);

% Define desired performance criteria
% Example: settling time (Ts), overshoot (OS), rise time (Tr)
desired_overshoot = 0.1;  % Adjust as needed
desired_settling_time = 2.0;  % Adjust as needed

% Define a range of Kp and Ki values to search
Kp_range = linspace(0, 10, 50);  % Adjust the range as needed
Ki_range = linspace(0, 2, 50);   % Adjust the range as needed

% Initialize variables to store the best Kp and Ki values
best_Kp = 0;
best_Ki = 0;
best_performance = inf;  % Initialize with a large value

% Loop through the parameter space
for Kp = Kp_range
    for Ki = Ki_range
        % Create a transfer function for the PI controller
        Gc = tf([Kp, Ki], [1, 0]);
        
        % Create the closed-loop system by connecting the plant and controller
        closed_loop = feedback(Gp * Gs * Gc, 1);

        % Simulate the closed-loop system's step response
        [time, response] = step(closed_loop);

        % Calculate the performance metrics (overshoot, settling time, etc.)
        overshoot_value = max(response) - 1;  % Assuming a unit step input
        settling_time_value = max(time(response >= 0.95)) - min(time);
        
        % Calculate an overall performance score based on your criteria
        performance_score = abs(overshoot_value - desired_overshoot) + ...
                            abs(settling_time_value - desired_settling_time);

        % Check if the current Kp and Ki values result in better performance
        if performance_score < best_performance
            best_performance = performance_score;
            best_Kp = Kp;
            best_Ki = Ki;
        end
    end
end

% Display the best Kp and Ki values
disp(['Best Kp: ', num2str(best_Kp)]);
disp(['Best Ki: ', num2str(best_Ki)]);

% Plot the force sensor reading vs. servo movement
% Assuming you have data for sensor readings and servo movements
% Replace the following with your actual data
sensor_readings = [100, 120, 150, 180, 200];  % Replace with actual readings
servo_movement = [0, 10, 20, 30, 40];  % Replace with actual movements

figure;
plot(servo_movement, sensor_readings, 'b.-', 'LineWidth', 1.5);
xlabel('Servo Movement');
ylabel('Force Sensor Reading');
title('Force vs. Servo Movement');
grid on;
