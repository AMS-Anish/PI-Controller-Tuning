% Define system parameters (you need to replace these with actual values)
desiredForce = 10;  % Desired force along the x-axis
Kp_initial_guess = 5;  % Initial guess for Kp
Ki_initial_guess = 1.1;  % Initial guess for Ki
samplingTime = 0.01;  % Sampling time (adjust as needed)
maxTime = 10;  % Maximum simulation time (adjust as needed)

% Define variables
time = 0:samplingTime:maxTime;  % Time vector
numSamples = length(time);
position_fixed_end = zeros(numSamples, 1);  % Position of the fixed end
position_movable_end = zeros(numSamples, 1);  % Position of the movable end
sensor_force_fixed_end = zeros(numSamples, 1);  % Sensor force at fixed end
sensor_force_movable_end = zeros(numSamples, 1);  % Sensor force at movable end
error = zeros(numSamples, 1);  % Error signal
integral = 0;  % Integral of error
velocity = 0;  % Initialize velocity

% PID controller gains (you'll adjust these)
Kp = Kp_initial_guess;
Ki = Ki_initial_guess;

% Arbitrary force value generator (0 N/mm to 5 N/mm)
sensor_force_generator = @(t) 5 * sin(0.2 * t);

% Main control loop
for i = 1:numSamples
    % Simulate sensor measurements
    sensor_force_fixed_end(i) = sensor_force_generator(time(i));
    sensor_force_movable_end(i) = sensor_force_generator(time(i));

    % Calculate the error (the deviation from the desired force)
    error(i) = desiredForce - sensor_force_movable_end(i);

    % Update the integral term
    integral = integral + error(i) * samplingTime;

    % Calculate control signal
    controlSignal = Kp * error(i) + Ki * integral;

    % Apply control signal to adjust motor positions (simplified)
    if i > 1
        position_movable_end(i) = position_movable_end(i-1) + controlSignal;
    else
        position_movable_end(i) = position_movable_end(1); % Initialize on the first iteration
    end

    % Update the fixed end position (assuming it's fixed)
    % position_fixed_end(i) = position_fixed_end(i-1);
    
    % Simulate cable bending model (simplified)
    % Replace with a realistic model for your cable
    % In this example, the position of the movable end affects the cable shape
    % Here, we assume the cable is a simple linear spring-damper system
    springConstant = 1;  % N/mm
    dampingCoefficient = 0.1;  % N/(mm/s)
    displacement = position_movable_end(i) - position_fixed_end(i);
    force = -springConstant * displacement - dampingCoefficient * velocity;
    
    % Update velocity based on the force
    velocity = force / springConstant;
end

% Plot results (you can add more plots as needed)
subplot(2,1,1);
plot(time, sensor_force_fixed_end, 'r', time, sensor_force_movable_end, 'b');
xlabel('Time (s)');
ylabel('Force (N)');
title('Force Measurements');
legend('Fixed End', 'Movable End');

subplot(2,1,2);
plot(time, position_movable_end);
xlabel('Time (s)');
ylabel('Position (mm)');
title('Movable End Position');
