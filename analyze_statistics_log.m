%% anlyze all statistics data
clear all;clc;
load('D:\workspace\log_analyze\mat_data\log_mat_20170106T1735.mat')
start_date_str = '2016-12-29';
end_date_str = '2016-12-27';
[ net_loss_mean_days ] = net_loss_for_some_days( log_data, start_date_str, end_date_str)
%% ..........calculate the network loss for a period of time............
nlog = length(log_data);
log_creat_time = zeros(1,nlog);
for k = 1:nlog
    log_creat_time(k) = datenum(log_data(k).log_creat_time , 'yyyymmddHHMMSS');
end

% the date need search
year = 2016;
month = 12;
day = 27;
days_search = 7;% the days need search
end_date_str = [num2str(year) num2str(month) num2str(day)];



end_date = datenum(end_date_str, 'yyyymmdd');
start_date = end_date - days_search;

% the index which date need search
idx_search_date = find((log_creat_time > start_date) & (log_creat_time < end_date));

net_loss = [log_data(idx_search_date).net_loss_mean];
net_loss_mean_days = mean(net_loss)

%..........calculate the network loss for a period of time............


