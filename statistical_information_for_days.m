function [ statistical_info ] = statistical_information_for_days( data_to_statistics, rate )
% this function is to calculate the data's statistical_information: count, mean, max, min and var
% input:
% data_to_statistics: the data need statistics
% rate: the rate theshold which the 80/20 rule need set
% output:
% statistical_info: a struct, included the data count, and the mean, max, min, var of the data percent rate

% check the input date
if nargin < 2
    rate = 0.8;
end
statistical_info = [];    
num_data_to_statistics = length(data_to_statistics);
statistical_info.data_count = num_data_to_statistics;
statistical_info.data_mean = [];
statistical_info.data_max = [];
statistical_info.data_min = [];
statistical_info.data_var = [];

if 0 ~= num_data_to_statistics
    % the 80/20 Rule
    num_data_rate = round(num_data_to_statistics * rate);
    [data_to_statistics_sorted, idx_data_to_statistics_sorted] = sort(data_to_statistics);
    data_rate = data_to_statistics_sorted(idx_data_to_statistics_sorted(1:num_data_rate));
    data_rate_mean = mean(data_rate);
    data_rate_max = max(data_rate);
    data_rate_min = min(data_rate);
    data_rate_var = var(data_rate);
    
    statistical_info.data_mean = data_rate_mean;
    statistical_info.data_max = data_rate_max;
    statistical_info.data_min = data_rate_min;
    statistical_info.data_var = data_rate_var;
end

end

