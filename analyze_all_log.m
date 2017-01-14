clear all;
dbstop if error
addpath('./bin')

% Change the load path to analyze another mat.
% load .\mat_data\log_mat_20161219T1455.mat
mat_file_path = '.\mat_data\log_mat_20170112T1530.mat';
load(mat_file_path)
[mat_pathstr, mat_name, mat_ext] = fileparts(mat_file_path);

% Calculate the statistical indicators
log_statistical_indicators = statistical_indicators_for_days(log_data)

% Calculate correlation and sort.
len = length(log_data);
cor_far_near_avg = -2*ones(len, 1);
cor_far_near_max = -2*ones(len, 1);

data_json = [];

for i = 1:len
    if (1 == log_data(i).valilty_cor_far_near_max)
        cor_far_near_avg(i) = log_data(i).cor_far_near_avg;
        cor_far_near_max(i) = log_data(i).cor_far_near_max;
    end
    differ = log_data(i).maxFarNearDiffer - log_data(i).minFarNearDiffer;
    if 100 < differ
        tmp = log_data(i);
        fprintf('Thread exception: %s, %d, %d\n',...
            log_data(i).file_path,...
            log_data(i).maxFarNearDiffer,...
            log_data(i).minFarNearDiffer);
        disp(log_data(i).device_name);
    end
    [pathstr, name, ext] = fileparts(log_data(i).file_path);
%     if isequal(name, 'stat20160829140341')
%         tmp = 0;
%     end
end

hist_avg = sort(cor_far_near_avg);

% json_file_name = '.\json_summary\log_mat_20170106T1735.json';
json_file_name = ['.\json_summary\' mat_name '.json'];
fid = fopen(json_file_name,'a');
fprintf(fid,'[');
fclose(fid);
for i = 1:len
    if (1 == log_data(i).valilty_cor_far_near_max)
        data_json.myUid = num2str(log_data(i).myUid);
        data_json.device_name = log_data(i).device_name;
        length_create_time = length(log_data(i).log_creat_time);
        if length_create_time > 14
            data_json.log_create_time = log_data(i).log_creat_time(1:14);
        else
            data_json.log_create_time = log_data(i).log_creat_time;
        end

        data_json.maxFarNearDiffer = log_data(i).maxFarNearDiffer;
        data_json.minFarNearDiffer = log_data(i).minFarNearDiffer;
        data_json.valilty_cor_far_near_max = log_data(i).valilty_cor_far_near_max;
        data_json.valilty_cor_far_near_avg = log_data(i).valilty_cor_far_near_avg;
        data_json.valilty_cor_far_aecout_max = log_data(i).valilty_cor_far_aecout_max;
        data_json.valilty_cor_far_aecout_avg = log_data(i).valilty_cor_far_aecout_avg;
        data_json.valilty_cor_near_aecout_max = log_data(i).valilty_cor_near_aecout_max;
        data_json.valilty_cor_near_aecout_avg = log_data(i).valilty_cor_near_aecout_avg;
        data_json.cor_far_near_max = log_data(i).cor_far_near_max;
        data_json.cor_far_near_avg = log_data(i).cor_far_near_avg;
        data_json.cor_far_aecout_max = log_data(i).cor_far_aecout_max;
        data_json.cor_far_aecout_avg = log_data(i).cor_far_aecout_avg;
        data_json.cor_near_aecout_avg = log_data(i).cor_near_aecout_avg;
        data_json.cor_near_aecout_max = log_data(i).cor_near_aecout_max;

        saveJSONfile(data_json, json_file_name);   
        
        fid = fopen(json_file_name,'a');
        %         st = fseek(fid, -2, 'eof');
        if i ~= len
            fprintf(fid,',');
        end
        fprintf(fid,'\n');
        fclose(fid);
    end
end

fid = fopen(json_file_name,'a');
fprintf(fid,']');
fclose(fid);



