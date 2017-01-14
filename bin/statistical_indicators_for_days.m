function [statistical_indicators] = statistical_indicators_for_days(log_data, start_date_str, end_date_str)
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

statistical_indicators.num_statistical_logs = length(idx_search_date);
rate = 0.80; % The threshold rate which the the 80/20 rule need

%............calculate the farend and nearend call for days................
far_near_differ_1min = [log_data(idx_search_date).far_near_differ_1min];
statistical_indicators.far_near_differ_1min = statistical_information_for_days(far_near_differ_1min, rate);
%............calculate the farend and nearend call for days................

%............calculate the network loss for days................
net_loss_mean = [log_data(idx_search_date).net_loss_mean];
net_loss_max = [log_data(idx_search_date).net_loss_max];
net_loss_median = [log_data(idx_search_date).net_loss_median];
statistical_indicators.net_loss_mean = statistical_information_for_days(net_loss_mean, rate);
statistical_indicators.net_loss_max = statistical_information_for_days(net_loss_max, rate);
statistical_indicators.net_loss_median = statistical_information_for_days(net_loss_median, rate);
%............calculate the network loss for days................

%............calculate the network jitter for days................
net_jitter_mean = [log_data(idx_search_date).net_jitter_mean];
net_jitter_max = [log_data(idx_search_date).net_jitter_max];
net_jitter_median = [log_data(idx_search_date).net_jitter_median];
statistical_indicators.net_jitter_mean = statistical_information_for_days(net_jitter_mean, rate);
statistical_indicators.net_jitter_max = statistical_information_for_days(net_jitter_max, rate);
statistical_indicators.net_jitter_median = statistical_information_for_days(net_jitter_median, rate);
%............calculate the network jitter for days................

%.............calculate the heart status for days.................
heartbeat_time_mean = [log_data(idx_search_date).heartbeat_time_mean];
heartbeat_time_max = [log_data(idx_search_date).heartbeat_time_max];
heartbeat_time_median = [log_data(idx_search_date).heartbeat_time_median];
statistical_indicators.heartbeat_time_mean = statistical_information_for_days(heartbeat_time_mean, rate);
statistical_indicators.heartbeat_time_max = statistical_information_for_days(heartbeat_time_max, rate);
statistical_indicators.heartbeat_time_median = statistical_information_for_days(heartbeat_time_median, rate);
%.............calculate the heart status for days.................

%............calculate the jitter buffer delay for days................
% min delay
min_delay_mean = [log_data(idx_search_date).min_delay_mean];
min_delay_max = [log_data(idx_search_date).min_delay_max];
min_delay_median = [log_data(idx_search_date).min_delay_median];
statistical_indicators.min_delay_mean = statistical_information_for_days(min_delay_mean, rate);
statistical_indicators.min_delay_max = statistical_information_for_days(min_delay_max, rate);
statistical_indicators.min_delay_median = statistical_information_for_days(min_delay_median, rate);
% max delay
max_delay_mean = [log_data(idx_search_date).max_delay_mean];
max_delay_max = [log_data(idx_search_date).max_delay_max];
max_delay_median = [log_data(idx_search_date).max_delay_median];
statistical_indicators.max_delay_mean = statistical_information_for_days(max_delay_mean, rate);
statistical_indicators.max_delay_max = statistical_information_for_days(max_delay_max, rate);
statistical_indicators.max_delay_median = statistical_information_for_days(max_delay_median, rate);
% the differ between max_delay and min_delay
max_min_delay_mean_differ = [log_data(idx_search_date).max_min_delay_mean_differ];
statistical_indicators.max_min_delay_mean_differ = statistical_information_for_days(max_min_delay_mean_differ, rate);
%............calculate the jitter buffer delay for days................

%..............calculate far and near correlation for days.............
cor_far_near_max = [log_data(idx_search_date).cor_far_near_max];
cor_far_near_avg = [log_data(idx_search_date).cor_far_near_avg];
cor_far_aecout_max = [log_data(idx_search_date).cor_far_aecout_max];
cor_far_aecout_avg = [log_data(idx_search_date).cor_far_aecout_avg];
cor_near_aecout_max = [log_data(idx_search_date).cor_near_aecout_max];
cor_near_aecout_avg = [log_data(idx_search_date).cor_near_aecout_avg];
statistical_indicators.cor_far_near_max = statistical_information_for_days(cor_far_near_max, rate);
statistical_indicators.cor_far_near_avg = statistical_information_for_days(cor_far_near_avg, rate);
statistical_indicators.cor_far_aecout_max = statistical_information_for_days(cor_far_aecout_max, rate);
statistical_indicators.cor_far_aecout_avg = statistical_information_for_days(cor_far_aecout_avg, rate);
statistical_indicators.cor_near_aecout_max = statistical_information_for_days(cor_near_aecout_max, rate);
statistical_indicators.cor_near_aecout_avg = statistical_information_for_days(cor_near_aecout_avg, rate);
%..............calculate far and near correlation for days.............

%......calculate LoggerSocket sendto count and bytes pre minute for days.......
sendto_count_1min = [log_data(idx_search_date).sendto_count_1min];
sendto_bytes_1min = [log_data(idx_search_date).sendto_bytes_1min];
statistical_indicators.sendto_count_1min = statistical_information_for_days(sendto_count_1min, rate);
statistical_indicators.sendto_bytes_1min = statistical_information_for_days(sendto_bytes_1min, rate);
%......calculate LoggerSocket sendto count and bytes pre minute for days.......

%............calculate the rtt for days................
% max rtt
max_rtt_mean = [log_data(idx_search_date).max_rtt];
max_rtt_max = [log_data(idx_search_date).max_rtt_max];
max_rtt_median = [log_data(idx_search_date).max_rtt_median];
statistical_indicators.max_rtt_mean = statistical_information_for_days(max_rtt_mean, rate);
statistical_indicators.max_rtt_max = statistical_information_for_days(max_rtt_max, rate);
statistical_indicators.max_rtt_median = statistical_information_for_days(max_rtt_median, rate);
% min rtt
min_rtt_mean = [log_data(idx_search_date).min_rtt_mean];
min_rtt_max = [log_data(idx_search_date).min_rtt_max];
min_rtt_median = [log_data(idx_search_date).min_rtt_median];
statistical_indicators.min_rtt_mean = statistical_information_for_days(min_rtt_mean, rate);
statistical_indicators.min_rtt_max = statistical_information_for_days(min_rtt_max, rate);
statistical_indicators.min_rtt_median = statistical_information_for_days(min_rtt_median, rate);

% average rtt
average_rtt_mean = [log_data(idx_search_date).average_rtt_mean];
average_rtt_max = [log_data(idx_search_date).average_rtt_max];
average_rtt_median = [log_data(idx_search_date).average_rtt_median];
statistical_indicators.average_rtt_mean = statistical_information_for_days(average_rtt_mean, rate);
statistical_indicators.average_rtt_max = statistical_information_for_days(average_rtt_max, rate);
statistical_indicators.average_rtt_median = statistical_information_for_days(average_rtt_median, rate);
%............calculate the rtt for days................
end

