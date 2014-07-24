%--------------------------------------------------------------
clc;
clear all;
close all;
%----------------Variables decleration--------------------------

no_of_file_sets = 5;
set_max_mean = 0;
sample = 30;
trigger_val=2.5; 
data_size = 1000;
power_cosm_data = zeros(1,data_size);

raw_power_trace = zeros(1,2000000);




for b = 1:no_of_file_sets;   
    
    
%--------------loading data file---------------------------
strp = sprintf('/local/windows/shared/Dropbox/TEST_CIRCUIT/sbox_BRAM/wave1_%d.dat',b);   
strt = sprintf('/local/windows/shared/Dropbox/TEST_CIRCUIT/sbox_BRAM/wave2_%d.dat',b); 
%%%%%%%%%%%%%%%% processing the power data %%%%%%%%%%%%%%%
fid = fopen(strp, 'r');
fprintf('Reading Power Wave\n');
% read the preamble
preamble = fread(fid,10,'double');
% read the raw byte
img = fread(fid,preamble(3),'uchar');
% close the file
fclose(fid);

% scale the image by the proper amount
imgX1 = [1:preamble(3)]';
imgX1 = (imgX1 - preamble(7)) * preamble(5) + preamble(6);
imgY1 = (img - preamble(10)) * preamble(8) + preamble(9);

%--------------------------------------------------------------
% plot the trace for debug. To plot uncomment the following options
%figure;plot(imgX1,imgY1);
%xlabel(' Time sec ');
%ylabel(' Volts ');
%--------------------------------------------------------------
%%%%%%%%%%%%%%%% processing the trigger data %%%%%%%%%%%%%%%
fid = fopen(strt, 'r');
fprintf('Reading Trigger Wave\n');
% read the preamble
preamble = fread(fid,10,'double');

% read the raw byte
img = fread(fid,preamble(3),'uchar');

% close the file
fclose(fid);

% scale the image by the proper amount
imgX2 = [1:preamble(3)]';
imgX2 = (imgX2 - preamble(7)) * preamble(5) + preamble(6);
imgY2 = (img - preamble(10)) * preamble(8) + preamble(9);

%--------------------------------------------------------------
% plot the trace for debug. To plot the trace uncomment the following
% options
%figure;plot(imgY2);
%xlabel(' Time sec ');
%ylabel(' Volts ');
%--------------------------------------------------------------
% search the trigger data for a high value

raw_power_trace = raw_power_trace + imgY1';


highVal = max(imgY2);
j = 1;
k = 1;
lb=1;
c = 1;
rise = 1;
out_trace = zeros(1,data_size);
fprintf('Calculating Out trace\n');
for i = 1:length(imgY2)-1
    %i
  if((imgY2(i) >trigger_val) && k < sample && rise == 1)
       trace_data(j) = imgY1(i+5); % 
       j= j+1;
       k=k+1;
       
       if (k == sample)
         rise = 0;
       end;
    elseif (imgY2(i) < 0 && k ~= 1)
       k = 1;
    else
       if (rise == 0)
           if set_max_mean == 0
          out_trace(c)= (max(trace_data(lb:j-1)));
           else
         out_trace(c)= (mean(abs(trace_data(lb:j-1))));
           end;
         c = c +1;
         lb=j;
         rise = 1;
       end;
  end;     
end;
out_trace1=out_trace(1:data_size); % resized to match the number of samples with the key guess (hamming distance) file samples
power_cosm_data(1:data_size) = power_cosm_data(1:data_size) + out_trace1(1:data_size);
%fprintf(fwr,'% 0.8f\n', out_trace1); 
end;

power_cosm_data = power_cosm_data / no_of_file_sets;
raw_power_trace = raw_power_trace / no_of_file_sets;
noise_data = out_trace1 - power_cosm_data;
raw_noise_data = imgY1' - raw_power_trace;
snr = out_trace1./noise_data;
snr_raw_power_trace = imgY1' ./raw_power_trace;
figure;plot(out_trace1);
xlabel('Time');
ylabel('Out_trace in Volts');
figure;plot(snr);
xlabel('Time');
ylabel('snr');
figure;plot(snr_raw_power_trace);
xlabel('SNR raw power trace');
ylabel('time');