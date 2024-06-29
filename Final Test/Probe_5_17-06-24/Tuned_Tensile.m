
% Correct sheet name after verification
correct_sheet_name = 'Reduced_Smoothed_and_Aligned_Fo';  % Replace 'SheetName' with the actual sheet name

% Load data from Excel file
data = readtable('K:\Study\Master Thesis\Final Test\Probe_5_17-06-24\Probe_Report_5.xlsx', 'Sheet', correct_sheet_name);

% Extract the relevant columns
time = data.Time;
force_applied = data.Force_Applied_A;
force_measured = data.Force_Measured_A_Filterd;

% Create a plot for Force Applied and Force Measured vs Time
figure;
hold on;
plot(time, force_applied, 'LineWidth', 2, 'DisplayName', 'Force Applied (N)');
plot(time, force_measured, 'LineWidth', 2, 'DisplayName', 'Force Measured (N)');
hold off;
xlabel('Time (s)');
ylabel('Force (N)');
title('Force Applied and Force Measured vs Time');
legend('show');
grid on;

% Save the force plot to TikZ
matlab2tikz('K:\Study\Master Thesis\Final Test\Probe_5_17-06-24\Tuned_Tensile.tex');
