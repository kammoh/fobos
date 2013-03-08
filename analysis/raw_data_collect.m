function [imgY] = raw_data_collect(source, print_raw_plots)
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

%--------------------------------------------------------------
%%%%%%%%%%%%%%%% extracting raw power data %%%%%%%%%%%%%%%
fid = fopen(source, 'r');

% read the preamble
preamble = fread(fid,10,'double');

% read the raw byte
img = fread(fid,preamble(3),'uchar');

% close the file
fclose(fid);

% scale the image by the proper amount
imgX = [1:preamble(3)]';
imgX = (imgX - preamble(7)) * preamble(5) + preamble(6);
imgY = (img - preamble(10)) * preamble(8) + preamble(9);

% plot the trace for debug
if (print_raw_plots == 1)
	figure;plot(imgY);
	xlabel(' Time sec ');
	ylabel(' Volts ');
	end;
%--------------------------------------------------------------
