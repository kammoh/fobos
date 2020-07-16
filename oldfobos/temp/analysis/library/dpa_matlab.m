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

% this is the 6th version

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
app_add_var=2;% appends the encryption if value =1/ adds when value =0 
%--------------------------------------------------------------
no_of_file_sets=1; % enter number of file sets here
%--------------------------------------------------------------
sample=10; % number of samples to be observed
%--------------------------------------------------------------
trigger_val=2; % this is the trigger voltage level
%--------------------------------------------------------------
data_size = 999; % this is the number of data samples required to crack the key
%--------------------------------------------------------------
correct_key = 174; % to compare wheather we get correct key
%---------------------------------------------------------------
set_max_mean = 0; % set_max_mean = 0 when maximum should be taken from outtrace points\\ =1 when mean
%---------------------------------------------------------------
addition_length=260; % no of elements to be added at a time
%---------------Declaring length of power trace-----------------
if (app_add_var==0)
    power_cosm_data=zeros(1,(no_of_file_sets*data_size));
    template_resize=zeros(1,(data_size));
    key_template_size=zeros(1,(data_size));
    no_of_measurements= no_of_file_sets * data_size;% Indicate number of measurements or encryptions
elseif (app_add_var==1)
        power_cosm_data=zeros(1,(no_of_file_sets*data_size));
        template_resize=zeros(256,(no_of_file_sets*data_size));
        key_template_size=zeros(256,(no_of_file_sets*data_size));
        no_of_measurements=no_of_file_sets * data_size;% Indicate number of measurements or encryptions
else
    if (app_add_var==2)
        power_cosm_data=zeros(1,(data_size));
    template_resize=zeros(256,(data_size));
    end;
    
end;


%---------Recursive file read opertion--------------------------
%-file names should be %PATH\wavej_i where i=1,2,3.....
%-- and j=1 if reading the power consumption/ j=0 whne reading trigger wave

for b = 1:no_of_file_sets;   

%--------------loading key guess file---------------------------
if (app_add_var==0)
template = load('E:\\rvelegal\\sddl_luts_only\\key_guess_174.txt');
template_resize = template(:,1:data_size);
else
    if (app_add_var==2)
	strk = sprintf('//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2bkey_guess_1.txt');
    template = load(strk, 'r');
%    template_resize = template(:,1:data_size);
    end;
end;

%--------------loading data file---------------------------
strp = sprintf( '//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2bwave1_1.dat');   
strt = sprintf( '//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2bwave2_1.dat'); 


fid = fopen(strp, 'r');

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
figure;plot(imgX1,imgY1);
xlabel(' Time sec ');
ylabel(' Volts ');
%--------------------------------------------------------------
%%%%%%%%%%%%%%%% processing the trigger data %%%%%%%%%%%%%%%
fid = fopen(strt, 'r');

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
figure;plot(imgY2);
xlabel(' Time sec ');
ylabel(' Volts ');
%--------------------------------------------------------------
% search the trigger data for a high value
highVal = max(imgY2);
j = 1;
k = 1;
lb=1;
c = 1;
rise = 1;
out_trace = zeros(1,data_size);

for i = 1:length(imgY2)-1
    %i
  if((imgY2(i) >trigger_val) && k < sample && rise == 1)
       trace_data(j) = imgY1(i+240); % because in my code the data is output in next clock i.e. after the falling edge of the trigger
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
%---------concatenation or addition depending upon user---------
if (app_add_var==0)
    %power_cosm_data=power_cosm_data+out_trace1;
    %template_resize(:,1:addition_length) = template(:,1:addition_length);
        if (b==1)
        power_cosm_data(1:addition_length)=out_trace1(1:addition_length);  
        template_resize(:,1:data_size) = template(:,1:data_size);
                for m= 1:3
                power_cosm_data(((m*addition_length)+1):((m+1)*addition_length)) = power_cosm_data((((m-1)*addition_length)+1):((m)*addition_length))+out_trace1(((m*addition_length)+1):((m+1)*addition_length));
                end;
        else
                for p= (4*(b-1)):(4*(b-1)+3)
                power_cosm_data(((p*addition_length)+1):((p+1)*addition_length)) = power_cosm_data((((p-1)*addition_length)+1):((p)*addition_length))+out_trace1(((m*addition_length)+1):((m+1)*addition_length));
                end; 
        template_resize(:, 1:b*data_size) = horzcat(template_resize(:,1:(b-1)*data_size),template(:,1:data_size)) ;
    end;
elseif (app_add_var==1)
        if (b==1)
        power_cosm_data(1:data_size)=out_trace1;  
        template_resize(:,1:data_size) = template(:,1:data_size);
        else
        power_cosm_data(1:b*data_size)=horzcat(power_cosm_data(1:(b-1)*data_size),out_trace1);
        template_resize(:, 1:b*data_size) = horzcat(template_resize(:,1:(b-1)*data_size),template(:,1:data_size)) ;
        end;
else
    if(app_add_var == 2)
        power_cosm_data(1:data_size) =  power_cosm_data(1:data_size) + out_trace1;
        
    end;
end;
%--------------------------------------------------------------

end;

 power_cosm_data1(1:data_size) =  power_cosm_data(1:data_size);
template_resize(:,1:data_size) = template(:,1:data_size);
template1 = [template_resize'  out_trace1'];
r = corrcoef(template1);
f = r(257,:);
x_range = 1:1:256;
figure; plot(x_range,  r(1:256,257))
xlabel(' key guess');
ylabel(' correlation ');

%--------------Until here-------------------------------------------------

%--------------------------------------------------------------------------
%Plotting the data according to Dr.Kaps
% ver 0.1 written by raj --dated---1st oct
% scale_yaxis_lower=-0.6;
% scale_yaxis_upper=0.6;
% window_size=256; %Indicates number of measurements to be "looked" up at a time 
% k=no_of_measurements/window_size;
%-------------for addition--------------------% 
%to be written


% for appending only---------
% for j = 1:k 
% mes_re_size = j*window_size; % this is the number of measurements or encryption re-sized
% key_template_size=template_resize(:,1:mes_re_size);
% power_trace_size=power_cosm_data(1:mes_re_size);
% corr_power_key = [key_template_size'  power_trace_size'];
% ccf = corrcoef(corr_power_key);
% tab1(j,1:257) = ccf(257,:);
% key_corr_mes(j,1:256)=tab1(j,1:256);
% [ma_x(j),max_val(j)] =max(ccf(1:256,257));
% [mi_x(j),min_val(j)] =min(ccf(1:256,257));
% [vec,vect] = unique(ccf(1:256,257)', 'rows');
% max_value(j) =max(key_corr_mes(j,1:256));
% int1=sort(key_corr_mes(j,1:256));
% second_max_value(j)=int1(255);
% min_value(j) =min(key_corr_mes(j,1:256));
% second_min_value(j)=int1(2);
% correct_key_measurement(j) = (key_corr_mes(j,correct_key));
% end;
% % the following way of plotting prints all the keys into plot
% mv=max_val(j);
% mwx=max_val(j);
% mwn=min_val(j);
% % mv corresponds to key guess having max correlation after looking through
% % all measurements
% lite_grey = [0.7 0.7 0.7];
% 
% if (mv==correct_key)
%  figure;
% plot(key_corr_mes(1:k,1:mv-1),'color',lite_grey)
% hold on
% plot(key_corr_mes(1:k,mv),'r')
% hold on
% plot (key_corr_mes(1:k,mv+1:256),'color',lite_grey)
% hold off
% xlabel('Number of Measurements x 2^8');
% ylabel('Correlation ');
% axis([1 k scale_yaxis_lower scale_yaxis_upper]);
% str = sprintf( 'Key Corres. Max Curve = %d', max_val(j));
% text(6,0.6, str);
% str1 = sprintf( 'correct key = %d is in red', correct_key);
% text(6,0.5, str1);
% 
% else
% if(mv < correct_key)
% 
%         figure;
% plot(key_corr_mes(1:k,1:mv-1),'color',lite_grey)
% hold on
% plot(key_corr_mes(1:k,mv),'r')
% hold on
% plot (key_corr_mes(1:k,mv+1:correct_key-1),'color',lite_grey)
% hold on
% plot(key_corr_mes(1:k,correct_key),'g')
% hold on
% plot (key_corr_mes(1:k,correct_key+1:256),'color',lite_grey)
% hold on
% plot(key_corr_mes(1:k,correct_key),'g')
% hold off
% xlabel('Number of Measurements x 2^8');
% ylabel('Correlation ');
% axis([1 k scale_yaxis_lower scale_yaxis_upper]);
% str = sprintf( 'Key Corres. Max Curve = %d', max_val(j));
% text(6,0.6, str);
% str1 = sprintf( 'correct key = %d is in green', correct_key);
% text(6,0.5, str1);
% 
%     else
%     if(mv > correct_key)
% 
%         figure;
% plot(key_corr_mes(1:k,1:correct_key-1),'color',lite_grey)
% hold on
% plot(key_corr_mes(1:k,correct_key),'g')
% hold on
% plot (key_corr_mes(1:k,correct_key+1:mv-1),'color',lite_grey)
% hold on
% plot(key_corr_mes(1:k,mv),'r')
% hold on
% plot (key_corr_mes(1:k,mv+1:256),'color',lite_grey)
% hold on
% plot(key_corr_mes(1:k,correct_key),'g')
% hold off
% xlabel('Number of Measurements x 2^8');
% ylabel('Correlation ');
% axis([1 k scale_yaxis_lower scale_yaxis_upper]);
% str = sprintf( 'Key Corres. Max Curve = %d', max_val(j));
% text(6,0.6, str);
% str1 = sprintf( 'correct key = %d is in green', correct_key);
% text(6,0.5, str1);
% 
% 
% end;
%     end;
% end;
% % the following way of plotting prints the max, min, and the correct value
% % only
% if (mwx==correct_key)
% figure; plot(1:k,second_max_value,'b');
% hold on
% plot(1:k,min_value,'b');
% hold on
% plot(1:k,correct_key_measurement, 'r');
% hold off
% xlabel('Number of Measurements x 2^8');
% ylabel('Correlation ');
% axis([1 k -0.15 0.15]);
% str = sprintf( 'Key Corres. Max Curve = %d', mwx);
% %text(6,0.6, str);
% str1 = sprintf( 'correct key = %d is in red', correct_key);
% %text(6,0.5, str1);
% else
%     if (mwn==correct_key)
% figure; plot(1:k,max_value,'b');
% hold on
% plot(1:k,second_min_value, 'color', 'b');
% hold on
% plot(1:k,correct_key_measurement, 'r');
% hold off
% xlabel('Number of Measurements x 2^8');
% ylabel('Correlation ');
% axis([1 k -0.2 0.2]);
% str = sprintf( 'Key Corres. Max Curve = %d', mwn);
% %text(6,0.6, str);
% str1 = sprintf( 'correct key = %d is in red', correct_key);
% %text(6,0.5, str1);
% else
%     if (mwn~=correct_key && mwx~=correct_key)
% figure; plot(1:k,max_value,'b');
% hold on
% plot(1:k,min_value, 'color', 'b');
% hold on
% plot(1:k,correct_key_measurement, 'r');
% hold off
% xlabel('Number of Measurements x 2^8', 11);
% ylabel('Correlation ',11);
% axis([1 k -0.2 0.2]);
% str = sprintf( 'Key Corres. Max Curve = %d', correct_key);
% %text(6,0.6, str);
% str1 = sprintf( 'correct key = %d is in red', correct_key);
% %text(6,0.5, str1);
% end;
%     end;
% end;
%-------------------------------------------------------------------------







