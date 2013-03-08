
%function [correl] = attack_explore(sample)

clc;
clear all;
close all;
%----------------Variables decleration--------------------------
app_add_var=1;% appends the encryption if value =1/ adds when value =0 
%--------------------------------------------------------------
no_of_file_sets=1; % enter number of file sets here
%--------------------------------------------------------------
sample= 10; % number of samples to be observed
%fprintf('Sample -> %d', sample);
%--------------------------------------------------------------
trigger_val=2; % this is the trigger voltage level
%--------------------------------------------------------------
data_size = 999; % this is the number of data samples required to crack the key
%--------------------------------------------------------------
correct_key = 44; % to compare wheather we get correct key
%---------------------------------------------------------------
set_max_mean = 0; % set_max_mean = 0 when maximum should be taken from outtrace points\\ =1 when mean
%---------------------------------------------------------------
addition_length=256; % no of elements to be added at a time
%---------------------------------------------------------------
displacement_length=333; % no of elements to be added at a time
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

fprintf('Hey Raj! Initiating DPA Attack Point Explore Program.....\n');
%---------Recursive file read opertion--------------------------
%-file names should be %PATH\wavej_i where i=1,2,3.....
%-- and j=1 if reading the power consumption/ j=0 whne reading trigger wave
for disp_len = 0:300;
for b = 1:no_of_file_sets;   

%--------------loading key guess file---------------------------
if (app_add_var==0)
template = load('/local/windows/shared/Dropbox/TEST_CIRCUIT/sbox_BRAM/key_guess_1.txt');
template_resize = template(:,1:data_size);
elseif (app_add_var==1)
	%strk = sprintf('//local//windows//shared//Dropbox//adder//HammingDistance//key_guess_1.txt');
    strk = sprintf('//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2bkey_guess_1.txt');
    template = load(strk, 'r');
%    template_resize = template(:,1:data_size);    
end;
%--------------loading data file---------------------------
%strp = sprintf('//local//windows//shared//Dropbox//adder//power_measurement_dpa//adderplus//wave1_%d.dat',b);   
%strt = sprintf('//local//windows//shared//Dropbox//adder//power_measurement_dpa//adderplus//wave2_%d.dat',b); 

strp = sprintf('//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2bwave1_%d.dat',b);   
strt = sprintf('//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//2bwave2_%d.dat',b); 

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
%figure;plot(imgX1,imgY1);
%xlabel(' Time sec ');
%ylabel(' Volts ');
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
%figure;plot(imgY2);
%xlabel(' Time sec ');
%ylabel(' Volts ');
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
       trace_data(j) = imgY1(i+disp_len); % because in my code the data is output in next clock i.e. after the falling edge of the trigger
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
power_cosm_data1(1:data_size) =  power_cosm_data(1:data_size)/10;
template_resize(:,1:data_size) = template(:,1:data_size);

template1 = [template_resize'  power_cosm_data'];
r = corrcoef(template1);
%f = r(257,:);
%x_range = 1:1:256;
%figure; plot(x_range,  r(1:256,257))
%xlabel(' key guess');
%ylabel(' correlation ');
[k,m] = max(r(1:256,257));
fprintf('Max_correlation for disp_len ->%d , sample -> %d is %d\n',disp_len, sample, m);
a_str = sprintf('Max_correlation for disp_len ->%d , sample -> %d is %d\n',disp_len, sample, m);
fw = fopen('//local//windows//shared//Dropbox//FOBOS//DPA_AES//power_model//correlation_aes_0_300_10_2B_2.txt', 'a+');
fprintf(fw, '%s', a_str);
fclose(fw);
end;
fprintf('Program Complete..Check the output file\n');
%correl = sprintf('Enjoy Raj\n');
