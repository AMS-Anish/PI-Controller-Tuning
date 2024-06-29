% Define system parameters
Kp = 1; % Proportional gain
Ki = 0.01; % Integral gain

% Initialize variables
Position1 = 0; % Initial position of motor 1
Position2 = 0; % Initial position of motor 2
Error1 = 0; % Initialize error for motor 1
Error2 = 0; % Initialize error for motor 2
I1 = 0; % Integral term for motor 1
I2 = 0; % Integral term for motor 2

% Simulation parameters
sim_time = 100; % Total simulation time (in seconds)
time = 0:0.1:sim_time; % Time vector with a time step of 0.1 seconds

% Initialize arrays to store data for plotting
Position1_data = zeros(1, length(time));
Position2_data = zeros(1, length(time));

% Define step inputs for Motor 1
step_times = [10, 40, 70]; % Times when the step inputs occur
step_values = [5, -3, 2]; % Magnitudes of the step inputs

% Simulation loop
for t = 1:length(time)
    % Check if there is a step input at the current time
    if ismember(t, step_times)
        % Apply the step input to Motor 1
        step_index = find(step_times == t);
        Position1 = Position1 + step_values(step_index);
    end
    
    % Calculate error
    Error1 = 0 - Position1; % Setpoint for Motor 1 is always 0
    Error2 = Position1 - Position2; % Motor 2 tracks the position of Motor 1
    
    % Calculate the proportional and integral terms
    P1 = Kp * Error1;
    P2 = Kp * Error2;
    I1 = I1 + Ki * Error1;
    I2 = I2 + Ki * Error2;
    
    % Calculate control output
    ControlOutput1 = P1 + I1;
    ControlOutput2 = P2 + I2;
    
    % Simulate Motor 2 (you should replace this with your actual motor control code)
    Position2 = Position2 + ControlOutput2;
    
    % Store position data for plotting
    Position1_data(t) = Position1;
    Position2_data(t) = Position2;
end

% Plot the results
figure;
plot(time, Position1_data, 'r', 'LineWidth', 1.5);
hold on;
plot(time, Position2_data, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Position');
legend('Motor 1', 'Motor 2');
title('Position Control with PI Controller and Step Inputs');
grid on;

% Display the final positions of the motors
disp(['Final position of Motor 1: ', num2str(Position1)]);
disp(['Final position of Motor 2: ', num2str(Position2)]);
