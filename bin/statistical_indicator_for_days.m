function [statistical_indicators] = statistical_indicator_for_days(log_data, start_date_str, end_date_str)
% this function for getting the statistical indicator from the start date to the end date.
% input:
% log_data :all log data
% start_date_str, end_date_str : the start and end date which need search,and the datae format 
%                                must be 'yyyy-mm-dd',such as '2016-12-12'
% output:
% statistical_indicators: a struct type, included some statistical indicators from the start date to the end date
statistical_indicators = [];
% check the input
%..........get the date from the log date............
nlog = length(log_data);
log_creat_time = zeros(1,nlog);
for k = 1:nlog
    log_creat_time(k) = datenum(log_data(k).log_creat_time , 'yyyymmddHHMMSS');
end

% check the input date
if nargin < 2
    start_date = min(log_creat_time);
    end_date  = max(log_creat_time);
elseif nargin < 3
    date_pattern = '\d{4}-\d{2}-\d{2}';
    if isempty(regexp(start_date_str,date_pattern, 'once'))
        disp('the date format is not match.');
        return;
    end
    start_date = datenum(start_date_str, 'yyyy-mm-dd');
    end_date  = max(log_creat_time);
else
    date_pattern = '\d{4}-\d{2}-\d{2}';
    if isempty(regexp(start_date_str,date_pattern, 'once')) || isempty(regexp(end_date_str,date_pattern, 'once'))
        disp('the date format is not match.');
        return;
    end
    start_date = datenum(start_date_str, 'yyyy-mm-dd');
    end_date = datenum(end_date_str, 'yyyy-mm-dd');
end

if start_date >= end_date
   disp('start date is later than end date');
   return;
end

% the index which date need search
idx_search_date = find((log_creat_time >= start_date) & (log_creat_time <= end_date));
if isempty(idx_search_date)
    disp('the search date is not exist.');
    return;
end

rate = 0.80; % The threshold rate which the the 80/20 rule need
%............calculate the farend and nearend call for days................
statistical_indicators.far_near_differ_1min_percent80 = [];

far_near_differ_1min = [log_data(idx_search_date).far_near_differ_1min];
num_far_near_differ_1min = length(far_near_differ_1min);
if 0 ~= num_far_near_differ_1min
    % the 80/20 Rule
    num_far_near_differ_1min_percent80 = round(num_far_near_differ_1min * rate);
    [far_near_differ_1min_sorted, idx_far_near_differ_1min_sorted] = sort(far_near_differ_1min);
    far_near_differ_1min_percent80 = mean(far_near_differ_1min_sorted(idx_far_near_differ_1min_sorted(1:num_far_near_differ_1min_percent80)));
    
    statistical_indicators.far_near_differ_1min_percent80 = far_near_differ_1min_percent80;
end
%............calculate the farend and nearend call for days................

%............calculate the network loss for days................
statistical_indicators.net_loss_mean_percent80 = [];
statistical_indicators.net_loss_max_percent80 = [];
statistical_indicators.net_loss_median_percent80 = [];

net_loss_mean = [log_data(idx_search_date).net_loss_mean];
net_loss_max = [log_data(idx_search_date).net_loss_max];
net_loss_median = [log_data(idx_search_date).net_loss_median];
num_net_loss = length(net_loss_mean);
if 0 ~= num_net_loss
    % the 80/20 Rule
    % net_loss_mean
    num_net_loss_percent80 = round(num_net_loss * rate);
    [net_loss_mean_sorted, idx_net_loss_mean_sorted] = sort(net_loss_mean);
    net_loss_mean_percent80 = mean(net_loss_mean_sorted(idx_net_loss_mean_sorted(1:num_net_loss_percent80)));
    % net_loss_max
    [net_loss_max_sorted, idx_net_loss_max_sorted] = sort(net_loss_max);
    net_loss_max_percent80 = mean(net_loss_max_sorted(idx_net_loss_max_sorted(1:num_net_loss_percent80)));
    % net_loss_median
    [net_loss_median_sorted, idx_net_loss_median_sorted] = sort(net_loss_median);
    net_loss_median_percent80 = mean(net_loss_median_sorted(idx_net_loss_median_sorted(1:num_net_loss_percent80)));
    
    statistical_indicators.net_loss_mean_percent80 = net_loss_mean_percent80;
    statistical_indicators.net_loss_max_percent80 = net_loss_max_percent80;
    statistical_indicators.net_loss_median_percent80 = net_loss_median_percent80;
end
%............calculate the network loss for days................

%............calculate the network jitter for days................
statistical_indicators.net_jitter_mean_percent80 = [];
statistical_indicators.net_jitter_max_percent80 = [];
statistical_indicators.net_jitter_median_percent80 = [];

net_jitter_mean = [log_data(idx_search_date).net_jitter_mean];
net_jitter_max = [log_data(idx_search_date).net_jitter_max];
net_jitter_median = [log_data(idx_search_date).net_jitter_median];
num_net_jitter = length(net_jitter_mean);
if 0 ~= num_net_jitter
    % the 80/20 Rule
    % net_jitter_mean
    [net_jitter_mean_sorted, idx_net_jitter_mean_sorted] = sort(net_jitter_mean);
    num_net_jitter_percent80 = round(num_net_jitter * rate);
    net_jitter_mean_percent80 = mean(net_jitter_mean_sorted(idx_net_jitter_mean_sorted(1:num_net_jitter_percent80)));
    % net_jitter_max
    [net_jitter_max_sorted, idx_net_jitter_max_sorted] = sort(net_jitter_max);
    net_jitter_max_percent80 = mean(net_jitter_max_sorted(idx_net_jitter_max_sorted(1:num_net_jitter_percent80)));
    % net_jitter_median
    [net_jitter_median_sorted, idx_net_jitter_median_sorted] = sort(net_jitter_median);
    net_jitter_median_percent80 = mean(net_jitter_median_sorted(idx_net_jitter_median_sorted(1:num_net_jitter_percent80)));
    
    statistical_indicators.net_jitter_mean_percent80 = net_jitter_mean_percent80;
    statistical_indicators.net_jitter_max_percent80 = net_jitter_max_percent80;
    statistical_indicators.net_jitter_median_percent80 = net_jitter_median_percent80;
end
%............calculate the network jitter for days................

%.............calculate the heart status for days.................
statistical_indicators.heartbeat_time_mean_percent80 = [];
statistical_indicators.heartbeat_time_max_percent80 = [];
statistical_indicators.heartbeat_time_median_percent80 = [];

heartbeat_time_mean = [log_data(idx_search_date).heartbeat_time_mean];
heartbeat_time_max = [log_data(idx_search_date).heartbeat_time_max];
heartbeat_time_median = [log_data(idx_search_date).heartbeat_time_median];
num_heartbeat_time = length(heartbeat_time_mean);
if 0 ~= num_heartbeat_time
    % the 80/20 Rule
    % heartbeat_time_mean
    [heartbeat_time_mean_sorted, idx_heartbeat_time_mean_sorted] = sort(heartbeat_time_mean);
    num_heartbeat_time_percent80 = round(num_heartbeat_time * rate);
    heartbeat_time_mean_percent80 = mean(heartbeat_time_mean_sorted(idx_heartbeat_time_mean_sorted(1:num_heartbeat_time_percent80)));
    % heartbeat_time_max
    [heartbeat_time_max_sorted, idx_heartbeat_time_max_sorted] = sort(heartbeat_time_max);
    heartbeat_time_max_percent80 = mean(heartbeat_time_max_sorted(idx_heartbeat_time_max_sorted(1:num_heartbeat_time_percent80)));
    % heartbeat_time_median
    [heartbeat_time_median_sorted, idx_heartbeat_time_median_sorted] = sort(heartbeat_time_median);
    heartbeat_time_median_percent80 = mean(heartbeat_time_median_sorted(idx_heartbeat_time_median_sorted(1:num_heartbeat_time_percent80)));
    
    statistical_indicators.heartbeat_time_mean_percent80 = heartbeat_time_mean_percent80;
    statistical_indicators.heartbeat_time_max_percent80 = heartbeat_time_max_percent80;
    statistical_indicators.heartbeat_time_median_percent80 = heartbeat_time_median_percent80;
end
%.............calculate the heart status for days.................

%............calculate the jitter buffer delay for days................
statistical_indicators.min_delay_mean_percent80 = [];
statistical_indicators.max_delay_mean_percent80 = [];
statistical_indicators.max_min_delay_mean_differ_percent80 = [];

min_delay_mean = [log_data(idx_search_date).min_delay_mean];
max_delay_mean = [log_data(idx_search_date).max_delay_mean];
num_delay_mean = length(min_delay_mean);
if 0 ~= num_delay_mean
    % the 80/20 Rule
    num_delay_mean_percent80 = round(num_delay_mean * rate);
    [min_delay_mean_sorted, idx_min_delay_mean_sorted] = sort(min_delay_mean);
    min_delay_mean_percent80 = mean(min_delay_mean_sorted(idx_min_delay_mean_sorted(1:num_delay_mean_percent80)));
    [max_delay_mean_sorted, idx_max_delay_mean_sorted] = sort(max_delay_mean);
    max_delay_mean_percent80 = mean(max_delay_mean_sorted(idx_max_delay_mean_sorted(1:num_delay_mean_percent80)));
    
    statistical_indicators.min_delay_mean_percent80 = min_delay_mean_percent80;
    statistical_indicators.max_delay_mean_percent80 = max_delay_mean_percent80;
    statistical_indicators.max_min_delay_mean_differ_percent80 = max_delay_mean_percent80 - min_delay_mean_percent80;
end
%............calculate the jitter buffer delay for days................

%..............calculate far and near correlation for days.............
statistical_indicators.cor_far_near_max_percent80 = [];
statistical_indicators.cor_far_near_avg_percent80 = [];
statistical_indicators.cor_far_aecout_max_percent80 = [];
statistical_indicators.cor_far_aecout_avg_percent80 = [];
statistical_indicators.cor_near_aecout_max_percent80 = [];
statistical_indicators.cor_near_aecout_avg_percent80 = [];

cor_far_near_max = [log_data(idx_search_date).cor_far_near_max];
cor_far_near_avg = [log_data(idx_search_date).cor_far_near_avg];
cor_far_aecout_max = [log_data(idx_search_date).cor_far_aecout_max];
cor_far_aecout_avg = [log_data(idx_search_date).cor_far_aecout_avg];
cor_near_aecout_avg = [log_data(idx_search_date).cor_near_aecout_avg];
cor_near_aecout_max = [log_data(idx_search_date).cor_near_aecout_max];
num_cor_far_near = length(cor_far_near_max);
num_cor_far_aecout = length(cor_far_aecout_max);
num_cor_near_aecout = length(cor_near_aecout_avg);

% the 80/20 Rule
if 0 ~= num_cor_far_near
    % cor_far_near
    num_cor_far_near_percent80 = round(num_cor_far_near * rate);
    [cor_far_near_max_sorted, idx_cor_far_near_max_sorted] = sort(cor_far_near_max);
    cor_far_near_max_percent80 = mean(cor_far_near_max_sorted(idx_cor_far_near_max_sorted(1:num_cor_far_near_percent80)));
    [cor_far_near_avg_sorted, idx_cor_far_near_avg_sorted] = sort(cor_far_near_avg);
    cor_far_near_avg_percent80 = mean(cor_far_near_avg_sorted(idx_cor_far_near_avg_sorted(1:num_cor_far_near_percent80)));
    
    statistical_indicators.cor_far_near_max_percent80 = cor_far_near_max_percent80;
    statistical_indicators.cor_far_near_avg_percent80 = cor_far_near_avg_percent80;
end

if 0 ~= num_cor_far_aecout
    % cor_far_aecout
    num_cor_far_aecout_percent80 = round(num_cor_far_aecout * rate);
    [cor_far_aecout_max_sorted, idx_cor_far_aecout_max_sorted] = sort(cor_far_aecout_max);
    cor_far_aecout_max_percent80 = mean(cor_far_aecout_max_sorted(idx_cor_far_aecout_max_sorted(1:num_cor_far_aecout_percent80)));
    [cor_far_aecout_avg_sorted, idx_cor_far_aecout_avg_sorted] = sort(cor_far_aecout_avg);
    cor_far_aecout_avg_percent80 = mean(cor_far_aecout_avg_sorted(idx_cor_far_aecout_avg_sorted(1:num_cor_far_aecout_percent80)));
    
    statistical_indicators.cor_far_aecout_max_percent80 = cor_far_aecout_max_percent80;
    statistical_indicators.cor_far_aecout_avg_percent80 = cor_far_aecout_avg_percent80;
end

if 0 ~= num_cor_far_aecout
    % cor_near_aecout
    num_cor_near_aecout_percent80 = round(num_cor_near_aecout * rate);
    [cor_near_aecout_max_sorted, idx_cor_near_aecout_max_sorted] = sort(cor_near_aecout_max);
    cor_near_aecout_max_percent80 = mean(cor_near_aecout_max_sorted(idx_cor_near_aecout_max_sorted(1:num_cor_near_aecout_percent80)));
    [cor_near_aecout_avg_sorted, idx_cor_near_aecout_avg_sorted] = sort(cor_near_aecout_avg);
    cor_near_aecout_avg_percent80 = mean(cor_near_aecout_avg_sorted(idx_cor_near_aecout_avg_sorted(1:num_cor_near_aecout_percent80)));
    
    statistical_indicators.cor_near_aecout_max_percent80 = cor_near_aecout_max_percent80;
    statistical_indicators.cor_near_aecout_avg_percent80 = cor_near_aecout_avg_percent80;
end
%..............calculate far and near correlation for days.............
       
end
