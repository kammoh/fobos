function [processed_power_trace] = process_raw_power_trace (file_set, sample, set_max_mean,trigger_val, power_trace, trigger_trace, addition_length, data_size)

imgY1=power_trace;
imgY2=trigger_trace;

fprintf('Processing Raw Power Trace :: File Set %d\n', file_set);

j = 1;
k = 1;
lb=1;
c = 1;
rise = 1;
out_trace = zeros(1,data_size);

for i = 1:length(imgY2)-1
    %i
  if((imgY2(i) >trigger_val) && k < sample && rise == 1)
           trace_data(j) = imgY1(i + addition_length); % because in my code the data is output in next clock i.e. after the falling edge of the trigger       
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
processed_power_trace=out_trace(1:data_size); % resized to match the number of samples with the key guess (hamming distance) file samples
fprintf('..[DONE]\n');