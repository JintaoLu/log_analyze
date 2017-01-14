function [percent_pass, percent_fail] = pass_percent_for_days(log_data, pass_threshold, fail_threshold, start_date_str, end_date_str)
% this function for getting the pass and fail percent from the start date to the end date.
% input:
% log_data :all log data
% start_date_str, end_date_str : the start and end date which need search,
%                                and the datae format must be 'yyyy-mm-dd'
% upper_threshold: the upper threshold
% lower_threshold: the lower threshold
% output:
% percent_pass_lower_threshold: the percent lower the lower_threshold among net loss from the start date to the end date
% percent_fail_upper_threshold: the percent upper the upper_threshold among net loss from the start date to the end date
percent_pass = [];
percent_fail = [];

% check the input
if nargin < 2
   fail_threshold = 0.8;
   pass_threshold  = 0.2;
elseif nargin < 3 
   pass_threshold  = 0.2;
end

if (pass_threshold > 1) ||  (fail_threshold < 0)
    disp('threshold is not in [0,1]');
    return;
end

if pass_threshold < fail_threshold
    disp('upper_threshold is smaller than lower_threshold');
    return;
end

%..........get the date from the log date............
nlog = length(log_data);
log_creat_time = zeros(1,nlog);
for k = 1:nlog
    log_creat_time(k) = datenum(log_data(k).log_creat_time , 'yyyymmddHHMMSS');
end

% check the input date
if nargin < 4
    start_date = min(log_creat_time);
    end_date  = max(log_creat_time);
elseif nargin < 5
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
idx_search_date = find((log_creat_time > start_date) & (log_creat_time < end_date));

if isempty(idx_search_date)
    disp('the search date is not exist.');
    return;
end

%......calculate the network loss pass and fail percent for days.........
net_loss = [log_data(idx_search_date).net_loss_mean];
num_net_loss = length(net_loss);
% the 80/20 Rule
% fail_threshold = 0.8;
% pass_threshold = 0.2;
percent_pass = sum(net_loss <= fail_threshold)/num_net_loss;
percent_fail = sum(net_loss >= pass_threshold)/num_net_loss;
%......calculate the network loss pass and fail percent for days.........

end




