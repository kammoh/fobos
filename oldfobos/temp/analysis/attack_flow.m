% Raj
% 1st Jan 2010
% Does the plotting as Dr.Kaps ordered
% DPA plotting for any kind of attack
% 1st version was written by nick ton
% 2nd version co-written by dr.hwang and rajesh
% 3rd version written by rajesh--dr.kaps way of printing
% 4th version plots only the max. min and the correct key stretch plots
% 5th version does addition and appending
% 6th version written by Shaunak it now also support multiple different key guess input files for appending method
% 7th version written by rajesh modularizing the scripts

% this is the 7th version

%function [correl] = data_collect(sample,source,trigger,hamm_file,trigger_val)
% sample - specify how many samples to extract from the source data
%
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
clc;
clear all;
close all;
%----------------Variables decleration--------------------------
app_add_var=1;% appends the encryption if value =1/ adds when value =0 
%--------------------------------------------------------------
no_of_file_sets=2; % enter number of file sets here
%--------------------------------------------------------------
%sample=50; % number of samples to be observed
%--------------------------------------------------------------
%trigger_val=1.8; % this is the trigger voltage level
%--------------------------------------------------------------
data_size = 1024; % this is the number of data samples required to crack the key
%--------------------------------------------------------------
correct_key = 174; % to compare wheather we get correct key
%---------------------------------------------------------------
set_max_mean = 0; % set_max_mean = 0 when maximum should be taken from 
                  % outtrace points\\ =1 when mean
%---------------------------------------------------------------
addition_length=0; % no of elements to be added at a time

%--------------------------------------------------------------
displacement = 0; % Val = [0/1] == [Forward/Backword] in time
%---------------------------------------------------------------
print_raw_plots = 0; % to print raw power/trigger plots 
                     % [0/1]=[DO NOT PRINT/PRINT]
%---------------Declaring length of power trace-----------------
if (app_add_var==0)
    power_cosm_data=zeros(1,(no_of_file_sets*data_size));
    template_resize=zeros(1,(data_size));
    key_template_size=zeros(1,(data_size));
    no_of_measurements= no_of_file_sets * data_size;% Indicate number of measurements or encryptions
else
    if (app_add_var==1)
        power_cosm_data=zeros(1,(no_of_file_sets*data_size));
        template_resize=zeros(256,(no_of_file_sets*data_size));
        key_template_size=zeros(256,(no_of_file_sets*data_size));
        no_of_measurements=no_of_file_sets * data_size;% Indicate number of measurements or encryptions
    end;
end;


%---------Recursive file read opertion--------------------------
%-file names should be %PATH\wavej_i where i=1,2,3.....
%-- and j=1 if reading the power consumption/ j=0 whne reading trigger wave

for b = 1:no_of_file_sets;   

%--------------loading key guess file---------------------------
if (app_add_var==0)
template = load('E:\\rvelegal\\sddl_luts_only\key_guess_174.txt');
template_resize = template(:,1:data_size);
else
    if (app_add_var==1)
	strk = sprintf('/Users/Aham/Raj/Dropbox/Matlab_scripts/source/key_guess_174_%d.txt',b);
    template = load(strk, 'r');
%    template_resize = template(:,1:data_size);
    end;
end;

%--------------loading data file---------------------------
strp = sprintf( '/Users/Aham/Raj/Dropbox/Matlab_scripts/source/wave1_%d.dat',b);   
strt = sprintf( '/Users/Aham/Raj/Dropbox/Matlab_scripts/source/wave2_%d.dat',b); 


%-------------initial set up-------------------------------
if (b == 1)
    [samples_per_cc, sample, trigger_val, addition_length] = initial_setup(strt, print_raw_plots);
end;


%--------------collecting raw power/trigger data-----------
imgY1 = raw_data_collect(strp, print_raw_plots);
imgY2 = raw_data_collect(strt, print_raw_plots);


%------------- Procesing Raw Power Trace ------------------
out_trace1= process_raw_power_trace (b, sample, set_max_mean, trigger_val, imgY1,imgY2, addition_length, data_size); 



%---------concatenation or addition depending upon user---------
[power_cosm_data, template_resize] = trace_resize(b, data_size, out_trace1, template, power_cosm_data, template_resize, app_add_var);

fprintf('Correlating Power Measured VS Power Calculated\n'); 
template1 = [template_resize'  power_cosm_data'];
r = corrcoef(template1);
[gb, key_value] = max(r(1:256,257));
fprintf('Correlation was maximum for Key Value ::%d\n', key_value);
f = r(257,:);
fprintf('Do u want to print the plots [0/1]--[no/yes]') ;
print_Plots = input('::');
if (print_Plots == 1)
x_range = 1:1:256;
figure; plot(x_range,  r(1:256,257))
xlabel(' key guess');
ylabel(' correlation ');
%--------------------------------------------------------------------------
%Plotting the data according to Dr.Kaps
% ver 0.1 written by raj --dated---1st oct
scale_yaxis_lower=-0.6;
scale_yaxis_upper=0.6;
window_size=256; %Indicates number of measurements to be "looked" up at a time 
k=no_of_measurements/window_size;
%-------------for addition--------------------% 
%to be written


% for appending only---------
for j = 1:k 
mes_re_size = j*window_size; % this is the number of measurements or encryption re-sized
key_template_size=template_resize(:,1:mes_re_size);
power_trace_size=power_cosm_data(1:mes_re_size);
corr_power_key = [key_template_size'  power_trace_size'];
ccf = corrcoef(corr_power_key);
tab1(j,1:257) = ccf(257,:);
key_corr_mes(j,1:256)=tab1(j,1:256);
[ma_x(j),max_val(j)] =max(ccf(1:256,257));
[mi_x(j),min_val(j)] =min(ccf(1:256,257));
[vec,vect] = unique(ccf(1:256,257)', 'rows');
max_value(j) =max(key_corr_mes(j,1:256));
int1=sort(key_corr_mes(j,1:256));
second_max_value(j)=int1(255);
min_value(j) =min(key_corr_mes(j,1:256));
second_min_value(j)=int1(2);
correct_key_measurement(j) = (key_corr_mes(j,correct_key));
end;
% the following way of plotting prints all the keys into plot
mv=max_val(j);
mwx=max_val(j);
mwn=min_val(j);
% mv corresponds to key guess having max correlation after looking through
% all measurements
lite_grey = [0.7 0.7 0.7];

if (mv==correct_key)
 figure;
plot(key_corr_mes(1:k,1:mv-1),'color',lite_grey)
hold on
plot(key_corr_mes(1:k,mv),'r')
hold on
plot (key_corr_mes(1:k,mv+1:256),'color',lite_grey)
hold off
xlabel('Number of Measurements x 2^8');
ylabel('Correlation ');
axis([1 k scale_yaxis_lower scale_yaxis_upper]);
str = sprintf( 'Key Corres. Max Curve = %d', max_val(j));
text(6,0.6, str);
str1 = sprintf( 'correct key = %d is in red', correct_key);
text(6,0.5, str1);

else
if(mv < correct_key)

        figure;
plot(key_corr_mes(1:k,1:mv-1),'color',lite_grey)
hold on
plot(key_corr_mes(1:k,mv),'r')
hold on
plot (key_corr_mes(1:k,mv+1:correct_key-1),'color',lite_grey)
hold on
plot(key_corr_mes(1:k,correct_key),'g')
hold on
plot (key_corr_mes(1:k,correct_key+1:256),'color',lite_grey)
hold on
plot(key_corr_mes(1:k,correct_key),'g')
hold off
xlabel('Number of Measurements x 2^8');
ylabel('Correlation ');
axis([1 k scale_yaxis_lower scale_yaxis_upper]);
str = sprintf( 'Key Corres. Max Curve = %d', max_val(j));
text(6,0.6, str);
str1 = sprintf( 'correct key = %d is in green', correct_key);
text(6,0.5, str1);

    else
    if(mv > correct_key)

        figure;
plot(key_corr_mes(1:k,1:correct_key-1),'color',lite_grey)
hold on
plot(key_corr_mes(1:k,correct_key),'g')
hold on
plot (key_corr_mes(1:k,correct_key+1:mv-1),'color',lite_grey)
hold on
plot(key_corr_mes(1:k,mv),'r')
hold on
plot (key_corr_mes(1:k,mv+1:256),'color',lite_grey)
hold on
plot(key_corr_mes(1:k,correct_key),'g')
hold off
xlabel('Number of Measurements x 2^8');
ylabel('Correlation ');
axis([1 k scale_yaxis_lower scale_yaxis_upper]);
str = sprintf( 'Key Corres. Max Curve = %d', max_val(j));
text(6,0.6, str);
str1 = sprintf( 'correct key = %d is in green', correct_key);
text(6,0.5, str1);


end;
    end;
end;
% the following way of plotting prints the max, min, and the correct value
% only
if (mwx==correct_key)
figure; plot(1:k,second_max_value,'b');
hold on
plot(1:k,min_value,'b');
hold on
plot(1:k,correct_key_measurement, 'r');
hold off
xlabel('Number of Measurements x 2^8');
ylabel('Correlation ');
axis([1 k -0.15 0.15]);
str = sprintf( 'Key Corres. Max Curve = %d', mwx);
%text(6,0.6, str);
str1 = sprintf( 'correct key = %d is in red', correct_key);
%text(6,0.5, str1);
else
    if (mwn==correct_key)
figure; plot(1:k,max_value,'b');
hold on
plot(1:k,second_min_value, 'color', 'b');
hold on
plot(1:k,correct_key_measurement, 'r');
hold off
xlabel('Number of Measurements x 2^8');
ylabel('Correlation ');
axis([1 k -0.2 0.2]);
str = sprintf( 'Key Corres. Max Curve = %d', mwn);
%text(6,0.6, str);
str1 = sprintf( 'correct key = %d is in red', correct_key);
%text(6,0.5, str1);
else
    if (mwn~=correct_key && mwx~=correct_key)
figure; plot(1:k,max_value,'b');
hold on
plot(1:k,min_value, 'color', 'b');
hold on
plot(1:k,correct_key_measurement, 'r');
hold off
xlabel('Number of Measurements x 2^8');
ylabel('Correlation ');
axis([1 k -0.2 0.2]);
str = sprintf( 'Key Corres. Max Curve = %d', correct_key);
%text(6,0.6, str);
str1 = sprintf( 'correct key = %d is in red', correct_key);
%text(6,0.5, str1);
end;
    end;
end;
end;
%-------------------------------------------------------------------------







