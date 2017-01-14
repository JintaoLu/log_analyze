clear;
close all;
dbstop if error


addpath('./bin');
% log_data = get_log_data('E:\log_analyze\20160818_cc\data(328203056.log)\stat20160817192710');
% log_data = get_log_data('D:\workspace\log_analyze\20161225\stat20160129124551');
% log_data = get_log_data('D:\workspace\log_analyze\20161225_cc\data(1006611182.log)\stat20161030173948');
log_data = get_log_data('D:\workspace\log_analyze\20161225_cc\data(2143287792.log)\stat20161218205130');
% log_data = get_log_data('D:\workspace\log_analyze\20161225_cc\data(1298009029.log)\stat20160627165919');
% log_data = get_log_data('.\test\stat20160627165919');
time_unit = 24*3600;
myhandle = figure;
if isempty(log_data.log_start_time)
    disp('Log start time is empty!');
    return;
end
if ~isempty(log_data.far_envelope_avg)
    hold on;
    plot((log_data.far_envelope_avg.time-log_data.log_start_time)*time_unit,log_data.far_envelope_avg.value);
end

if ~isempty(log_data.far_envelope_max)
    hold on;
    plot((log_data.far_envelope_max.time-log_data.log_start_time)*time_unit,log_data.far_envelope_max.value);
end
a = {'abc'};
a = {a, {'abcd'}};


if ~isempty(log_data.near_envelope_avg)
    hold on;
    plot((log_data.near_envelope_avg.time-log_data.log_start_time)*time_unit,log_data.near_envelope_avg.value);
end

if ~isempty(log_data.near_envelope_max)
    hold on;
    plot((log_data.near_envelope_max.time-log_data.log_start_time)*time_unit,log_data.near_envelope_max.value);
end

if ~isempty(log_data.aecout_envelope_avg)
    hold on;
    plot((log_data.aecout_envelope_avg.time-log_data.log_start_time)*time_unit,log_data.aecout_envelope_avg.value);
end

if ~isempty(log_data.aecout_envelope_max)
    hold on;
    plot((log_data.aecout_envelope_max.time-log_data.log_start_time)*time_unit,log_data.aecout_envelope_max.value);
end

if ~isempty(log_data.buffer_margin)
    hold on;
    plot((log_data.buffer_margin.time-log_data.log_start_time)*time_unit,log_data.buffer_margin.value);
end

legend('far envelope avg'...
    , 'far envelope max'...
    , 'near envelope avg'...
    , 'near envelope max'...
    , 'aecout envelope avg'...
    , 'aecout envelope max'...
    , 'far buffer empty');
title(log_data.device_name);
textx = xlim; 
texty = ylim;
textstr = [...
    'myUid = ',num2str(log_data.myUid),10 ...
    ,'maxFarNearDiffer = ',num2str(log_data.maxFarNearDiffer),10 ...
    ,'minFarNearDiffer = ',num2str(log_data.minFarNearDiffer),10 ...
    ]; 
text(textx(1), texty(end)*0.5, textstr);

%..........calculate the network loss............
% net_loss_value = log_data.net_loss.value;
% net_loss_mean = mean(net_loss_value);
% net_loss_max = max(net_loss_value);
% net_loss_median = median(net_loss_value);
%..........calculate the network loss............

