
% Load data from Excel file
data = readtable('K:\Study\Master Thesis\Final Test\Probe_3_17-06-24\Probe_Report.xlsx', 'Sheet', 'Probe_3_17-06-24');

% Extract the relevant columns
time = data.Time;
force_applied = data.Force_Applied_A;
force_measured = data.Force_Measured_A;

% Create a plot for Force Applied and Force Measured vs Time
figure;
hold on;
plot(time, force_applied, 'LineWidth', 2, 'DisplayName', 'Force Applied (A)');
plot(time, force_measured, 'LineWidth', 2, 'DisplayName', 'Force Measured (A)');
hold off;
xlabel('Time (s)');
ylabel('Force (N)');
title('Force Applied and Force Measured vs Time');
legend('show');
grid on;

% Save the force plot to TikZ
matlab2tikz('K:\Study\Master Thesis\Final Test\Probe_3_17-06-24\Initial_Tensile.tex');
