function [power_trace_resize, key_template_resize] = trace_resize(b, data_size, power_trace, key_template, power_trace_resize, key_template_resize, app_add_var)

if (app_add_var==0)

else
    if (app_add_var==1)
        if (b==1)
        power_trace_resize(1:data_size)=power_trace;  
        key_template_resize(:,1:data_size) = key_template(:,1:data_size);
        else
        power_trace_resize(1:b*data_size)=horzcat(power_trace_resize(1:(b-1)*data_size), power_trace);
        key_template_resize(:, 1:b*data_size) = horzcat(key_template_resize(:,1:(b-1)*data_size),key_template(:,1:data_size)) ;
        end;
            end;
                end;