function [value, trigger_val] = find_no_of_samples(source,print_raw_plots)
% sample - specify how many samples to extract from the source data
% Reads wave dat files. The preamble is made up of 10 doubles that provide
% information to the raw image. The preamble contains all of the current WAVEFORM
% settings returned in the form <preamble block><NL> where the
% <preamble block> is:
% 1. FORMAT : int16 - 0 = BYTE, 1 = WORD, 2 = ASCII.
% 2. TYPE : int16 - 0 = NORMAL, 1 = PEAK DETECT, 2 = AVERAGE.
% 3. POINTS : int32 - number of data points transferred.
% 4. COUNT : int32 - 1 and is always 1.
% 5. XINCREMENT : float64 - time difference between data points.
% 6. XORIGIN : float64 - always the first data point in memory.
% 7. XREFERENCE : int32 - specifies the data point associated
% 8. with the x-origin.
% 9. YINCREMENT : float32 - voltage difference between data points.
% 10. YORIGIN : float32 - value of the voltage at center screen.
% 11. YREFERENCE : int32 - data point where y-origin occurs.

% open the wave file and get a handle
%clc;
%clear all;
close all;
%fprintf('trigger_value = %d/n', trigger_val); % this is the trigger voltage level

imgY2= raw_data_collect(source, print_raw_plots);
high_val = max(imgY2);
fprintf('Highest Trigger Value = %d\n', high_val);
fprintf('Please Enter the trigger value in range [0 to %d]', high_val);
trigger_val = input('=');
% Procedure to calculate number of samples collected between 
%two traces
i=1;
j=1;
rise=1;
count=0;
for i = 1:length(imgY2)
        %fprintf('enter while loop\n');
		if(imgY2(i) > trigger_val && rise == 1)
			count=count+1;
        %fprintf('counting samples= %d\n', count);
        else
            if(imgY2(i) < 0 && count ~= 0)
            rise = 0;
            end;
        end;
end;
value = count;
