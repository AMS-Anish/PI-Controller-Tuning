folderPath = 'K:\Study\Master Thesis\Final Test\Probe_9_20-06-24\Probe_93_20-06-24';
[Kp, Ki] = CalculatePIDlvm(folderPath);

% Return the values to LabVIEW
output_Kp = Kp;
output_Ki = Ki;