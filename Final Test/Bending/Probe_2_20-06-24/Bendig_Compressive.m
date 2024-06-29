% Load data from Excel file
data = readtable('K:\Study\Master Thesis\Final Test\Bending\Probe_2_20-06-24\Probe_2_Compressive.xlsx');

% Extract the relevant columns
time = data.Time;
bending_angle = data.Bending;  % Assuming the second column is Bending
force_variation = data.Force;  % Assuming the third column is Force variation

% Find the time indices where the bending angle reaches and drops from 40 degrees
index_rise_40 = find(bending_angle >= 40, 1, 'first');
index_fall_40 = find(bending_angle >= 40, 1, 'last');

time_rise_40 = time(index_rise_40);
time_fall_40 = time(index_fall_40);

% Create a plot with two y-axes
figure;
yyaxis left
plot(time, bending_angle, 'LineWidth', 2, 'DisplayName', 'Bending Angle');
ylabel('Bending Angle (°)');
ylim([-5 60]);
hold on;
% Add vertical line when bending reaches 40 degrees
xline(time_rise_40, '--r', 'LineWidth', 1.5);
% Add vertical line when bending starts dropping from 40 degrees
xline(time_fall_40, '--g', 'LineWidth', 1.5);
hold off;

yyaxis right
plot(time, -force_variation, 'LineWidth', 2, 'DisplayName', 'Force Variation');
ylabel('Force (N)');
ylim([-2 20]);

xlabel('Time (s)');
title('Bending Angle and Force Variation vs Time');
legend('show');
grid on;

% Save the force plot to TikZ
matlab2tikz('K:\Study\Master Thesis\Final Test\Bending\Probe_2_20-06-24\Bending_Compressive.tex');
