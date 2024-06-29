function [Kp, Ki] = CalculatePIDlvm_controled(folderPath, startIdx, endIdx)
    % Get the list of all .lvm files in the folder
    filePattern = fullfile(folderPath, '*.lvm');
    lvmFiles = dir(filePattern);

    % Check if there is exactly one .lvm file in the folder
    if length(lvmFiles) ~= 1
        error('There should be exactly one .lvm file in the folder.');
    end

    % Get the full file name of the .lvm file
    lvmFileName = fullfile(folderPath, lvmFiles(1).name);

    % Open the file
    fileID = fopen(lvmFileName, 'r');
    % Read the file content
    fileContent = fread(fileID, '*char')';
    % Close the file after reading
    fclose(fileID);

    % Replace commas with dots
    modifiedContent = strrep(fileContent, ',', '.');

    % Read the modified content into a table
    tempFileName = [tempname, '.txt'];
    fileID = fopen(tempFileName, 'w');
    fwrite(fileID, modifiedContent, 'char');
    fclose(fileID);
    tableData = readtable(tempFileName, 'FileType', 'text', 'Delimiter', '\t');

    % Add index as the first column
    numRows = height(tableData);
    tableData.Index = (1:numRows)';

    % Move the Index column to the first position
    tableData = [tableData(:, end), tableData(:, 1:end-1)];

    % Write the modified table back to the .lvm file
    writetable(tableData, lvmFileName, 'FileType', 'text', 'Delimiter', '\t');

    % Validate startIdx and endIdx
    if startIdx < 1 || endIdx > numRows || startIdx >= endIdx
        error('Invalid start or end index.');
    end

    % Extract input-output data within the specified range
    u = tableData{startIdx:endIdx, 'Force_Applied_A'};  % Using the second column
    y = tableData{startIdx:endIdx, 'Force_Sensor_A'};  % Using the third column

    % Remove rows with NaN values
    validRows = ~isnan(u) & ~isnan(y);
    u = u(validRows);
    y = y(validRows);

    % Check if u and y are non-empty
    if isempty(u) || isempty(y)
        error('The input or output data columns are empty after removing NaN values.');
    end

    % Display data size
    disp(['Number of data points: ', num2str(length(u))]);

    % Display data variability
    disp(['Standard deviation of input data (u): ', num2str(std(u))]);
    disp(['Standard deviation of output data (y): ', num2str(std(y))]);

    % Specify the sampling time 
    Ts = 0.1;

    % Create an iddata object
    data = iddata(y, u, Ts);

    % Check if data size is sufficient
    if length(u) < 10
        error('The data set is too small for reliable estimation.');
    end

    % Estimate the transfer function using tfest
    try
        sysEst = tfest(data, 1, 0);
    catch ME
        disp('Error estimating transfer function:');
        disp(ME.message);
        return;
    end

    % Adjust the desired_tf based on the identified transfer function
    desired_tf = sysEst;

    % Set initial PID controller parameters
    Kp_initial = 1.7;
    Ki_initial = 1.8;

    % Create an initial PI controller
    controller_initial = pid(Kp_initial, Ki_initial);

    % Create a linear model from identified transfer function
    sysEst_linear = idtf(desired_tf);

    % Simulate the closed-loop system with the initial PI controller
    closedLoop_initial = feedback(sysEst_linear * controller_initial, 1);

    % Tune the PID controller
    C_pi = pidtune(sysEst_linear, 'PI');

    % Extract tuned PID parameters
    Kp = C_pi.Kp;
    Ki = C_pi.Ki;

    % Display the calculated Kp and Ki values
    disp('Calculated PID Controller Parameters:');
    disp(['Kp: ', num2str(Kp)]);
    disp(['Ki: ', num2str(Ki)]);

    % Clean up the temporary file
    delete(tempFileName);
end
