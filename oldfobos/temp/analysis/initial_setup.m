function [samples_cc, sample_window_size, trigger_val, displacement_length] = initial_setup(source,print_raw_plots)
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


fprintf('Running Initial Setup\n');
[samples_cc, trigger_val] =  find_no_of_samples(source, print_raw_plots);
fprintf ('Number of Samples for one clock cycle= %d\n', samples_cc);
fprintf('Enter the Sample Window Size in range [0 to %d]', samples_cc);
sample_window_size = input(' = ');
fprintf('Enter the Number of Clock Cycles by which the Sample window Should be displaced');
cc_dsp = input(' = ');
fprintf('Enter the number of samples (if) by which the sample window Should be displaced');
sc_dsp = input(' = ');
displacement_length = (cc_dsp * samples_cc) + sc_dsp ;