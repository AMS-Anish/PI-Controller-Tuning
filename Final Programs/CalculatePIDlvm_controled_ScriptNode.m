folderPath = 'K:\Study\Master Thesis\Final Test\Probe_9_20-06-24\Probe_93_20-06-24';
startIdx = 320;
endIdx = 840;
[Kp, Ki] = CalculatePIDlvm_controled(folderPath, startIdx, endIdx);
