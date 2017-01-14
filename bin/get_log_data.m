% dbstop if error
% clear all
function logdatastruct = get_log_data(filename)
% This function get log data to struct.
%..........Read log data in...............
% filename = 'C:\Users\admin\Desktop\data_stat20160121171623_100.log';
%  filename ='/home/duoyi/JintaoLu/work/LuLog/20160125/data(133587359.log)/stat20160114204107';
% filename = file_path;
logdatastruct = [];
disp(filename);
exist_flag = exist(filename,'file');
if exist_flag ~= 2
    return;
end
% [textLogs, rowLogs, colLogs] = readLog(filename, 9);
[textLogs, rowLogs, colLogs] = readLog(filename);
if  0 == sum(~cellfun('isempty',textLogs))
        return;
end
idxData = find(isnan(str2double(textLogs{2})) == 0);%Log for numberic data
idxText = find(isnan(str2double(textLogs{2})) == 1);%Log for nonnumberic data
%..........Read log data in...............

%................due with numberic data..............
length_numberic_data = length(idxData);
length_log_cell = length(textLogs);
data_tag_set = zeros(0);
data_raw = zeros(0);
log_start_time = datenum(textLogs{1}(1) , 'yyyy_mm_ddTHH:MM:SS:FFF');
row_time = datenum(textLogs{1}(idxData), 'yyyy_mm_ddTHH:MM:SS:FFF');% Log appear time.
row_tag = str2double(textLogs{2}(idxData));% Log tag.

for i = 1: length_numberic_data
    log_time = row_time(i);
    log_tag = row_tag(i);
    tmp_tag = log_tag;
    now_tag_index = find(data_tag_set == tmp_tag);
    %............write tag name.......    
    if(isempty(now_tag_index))
        data_tag_set(end+1) = tmp_tag;
        now_tag_index = length(data_tag_set);
        data_raw(now_tag_index).time = log_time;
        data_raw(now_tag_index).value = tmp_tag;
    else
        data_raw(now_tag_index).time(end + 1) = log_time;
        data_raw(now_tag_index).value(end + 1) = tmp_tag;
    end
    %............write tag name.......
    for k = 3:length_log_cell
        if ((length(textLogs) < k) || (length(idxData) < i) || length(textLogs{k}) < idxData(i))
            warning('Log file many be broken!');
            logdatastruct = [];
            return
        end
        tmp_value = textLogs{k}(idxData(i));
        if isequal(tmp_value, {''})
            break;
        end
        tmp_value = str2double(tmp_value);
        tmp_tag = log_tag * 10 + k - 2;%If a line more than 9 data, this will case error.
        now_tag_index = find(data_tag_set == tmp_tag);
        %............write tag data.......
        if(isempty(now_tag_index))
            data_tag_set(end+1) = tmp_tag;
            now_tag_index = length(data_tag_set);
            data_raw(now_tag_index).time = log_time;
            data_raw(now_tag_index).value = tmp_value;
        else
            data_raw(now_tag_index).time(end + 1) = log_time;
            data_raw(now_tag_index).value(end + 1) = tmp_value;
        end
        %............write tag data.......
    end
end
%................due with numberic data..............

%.................due with nonuberic data.............
%use find_text to find a signal message.
[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'device=');
device_name = '';
if found_flag
%     device_name = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'Record:device=%s%c');
    device_name =  textscan(cell2mat(textLogs{index_column}(idxText(index_row))),'Record:device=%s','delimiter','=') ;
    device_name = char ( device_name{1} );
end

%.............calculate the difference between farend and nearend called............
[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'maxFarNearDiffer=');
maxFarNearDiffer = '';
log_end_time = [];
if found_flag
    maxFarNearDiffer = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'maxFarNearDiffer=%d');
    log_end_time = datenum(textLogs{1}(idxText(index_row)), 'yyyy_mm_ddTHH:MM:SS:FFF');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'minFarNearDiffer=');
minFarNearDiffer = '';
if found_flag
    minFarNearDiffer = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'minFarNearDiffer=%d');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'm_max_far_near_differ=');
if found_flag
    maxFarNearDiffer = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'m_max_far_near_differ=%d');
    log_end_time = datenum(textLogs{1}(idxText(index_row)), 'yyyy_mm_ddTHH:MM:SS:FFF');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'm_min_far_near_differ=');
if found_flag
    minFarNearDiffer = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'m_min_far_near_differ=%d');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'max_farend_nearend_calls_difference =');
if found_flag
    maxFarNearDiffer = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'[ASP]max_farend_nearend_calls_difference =%d');
%     maxFarNearDiffer = cell2mat(textscan(cell2mat(textLogs{index_column}(idxText(index_row))),'%*s=%d'));
%     tmp_log_cell = textscan(cell2mat(textLogs{index_column}(idxText(index_row))),'%s %d','delimiter','=');
%     maxFarNearDiffer = tmp_log_cell{1,2};
    log_end_time = datenum(textLogs{1}(idxText(index_row)), 'yyyy_mm_ddTHH:MM:SS:FFF');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'min_farend_nearend_calls_difference =');
if found_flag
    minFarNearDiffer = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'min_farend_nearend_calls_difference =%d');
end
%.............calculate the difference between farend and nearend called............

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'myUid =');
myUid = '';
if found_flag
    myUid  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'myUid =%d');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'netType =');
netType = '';
if found_flag
    netType  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'AudioClient netType = %d');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'IMEI:');
IMEI = '';
if found_flag
    IMEI  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'IMEI:%s');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'MANUFACTURER:');
manufacturer = '';
if found_flag
    manufacturer =  textscan(cell2mat(textLogs{index_column}(idxText(index_row))),'MANUFACTURER:%s','delimiter',':') ;
    manufacturer = char ( manufacturer{1} );
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'MODEL:');
model = '';
if found_flag
    model =  textscan(cell2mat(textLogs{index_column}(idxText(index_row))),'MODEL:%s','delimiter',':') ;
    model = char ( model{1} );
end

[found_flag, index_column, index_row] = find_text_multi(textLogs, length_log_cell, idxText, 'VERSION:');
system_version = '';
if found_flag
   index_column_tmp = index_column(end);
    index_row_tmp = index_row(end);
    system_version =  textscan(cell2mat(textLogs{index_column_tmp}(idxText(index_row_tmp))),'VERSION:%s','delimiter',':') ;
    system_version = char ( system_version{1} );
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'CPUNAME:');
cpu_type = '';
if found_flag
    cpu_type =  textscan(cell2mat(textLogs{index_column}(idxText(index_row))),'CPUNAME:%s','delimiter',':') ;
    cpu_type = char ( cpu_type{1} );
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'MEMORY:');
memory = '';
if found_flag
    memory  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'MEMORY:%s');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'MAC:');
MAC = '';
if found_flag
    MAC  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'MAC:%s');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'IP:');
IP = '';
if found_flag
    IP  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'IP:%s');
end

[found_flag, index_column, index_row] = find_text_multi(textLogs, length_log_cell, idxText, 'Revision:Last Changed Rev:');
sdk_version = '';
signal_version = '';
if found_flag
    sdk_version = sscanf(cell2mat(textLogs{index_column(1)}(idxText(index_row(1)))),'Revision:Last Changed Rev:%s');
    if length(index_column) > 1
        signal_version = sscanf(cell2mat(textLogs{index_column(2)}(idxText(index_row(2)))),'Revision:Last Changed Rev:%s'); 
    end
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'LoggerSocket final sendto count:');
sendto_count = [];
if found_flag
    sendto_count  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'LoggerSocket final sendto count:%d');
end

[found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, 'bytes:');
sendto_bytes = [];
if found_flag
    sendto_bytes  = sscanf(cell2mat(textLogs{index_column}(idxText(index_row))),'bytes:%d');
end

log_integrity  = strcmp(textLogs{2}(end),'AudioClient disconstructor');

%use find_text to find signal repeat messages.
% [found_flag, index_column, index_row] = find_text_multi(textLogs, length_log_cell, idxText, 'AudioClient');
% for i = 1:length(index_column)
%     cell2mat(textLogs{index_column(i)}(idxText(index_row(i))));
% end
%.................due with nonuberic data.............


%.....storage data to struct......
logdatastruct.colLogs = colLogs;
logdatastruct.rowLogs = rowLogs;
logdatastruct.data = data_raw;
logdatastruct.tag = data_tag_set;
logdatastruct.log_start_time = log_start_time;
logdatastruct.log_end_time = log_end_time;
logdatastruct.file_path = filename;
logdatastruct.device_name = device_name;
logdatastruct.maxFarNearDiffer = maxFarNearDiffer;
logdatastruct.minFarNearDiffer = minFarNearDiffer;
logdatastruct.myUid = myUid;
logdatastruct.netType = netType;
logdatastruct.IMEI = IMEI;
logdatastruct.manufacturer = manufacturer;
logdatastruct.model = model;
logdatastruct.system_version = system_version;
logdatastruct.cpu_type = cpu_type;
logdatastruct.memory = memory;
logdatastruct.MAC = MAC;
logdatastruct.IP = IP;
logdatastruct.sdk_version = sdk_version; 
logdatastruct.signal_version = signal_version; 
logdatastruct.sendto_count = sendto_count;
logdatastruct.sendto_bytes = sendto_bytes;
logdatastruct.log_integrity = log_integrity;

logdatastruct.buffer_margin = logdatastruct.data(logdatastruct.tag == 2061);
logdatastruct.record_interval_warning = logdatastruct.data(logdatastruct.tag == 1001);
logdatastruct.record_interval_avg = logdatastruct.data(logdatastruct.tag == 1011);
logdatastruct.record_interval_max = logdatastruct.data(logdatastruct.tag == 1012);
logdatastruct.far_envelope_max = logdatastruct.data(logdatastruct.tag == 1021);
logdatastruct.far_envelope_avg = logdatastruct.data(logdatastruct.tag == 1022);
logdatastruct.near_envelope_max = logdatastruct.data(logdatastruct.tag == 1031);
logdatastruct.near_envelope_avg = logdatastruct.data(logdatastruct.tag == 1032);
logdatastruct.delay_change_time = logdatastruct.data(logdatastruct.tag == 1041);
logdatastruct.delay_change_value = logdatastruct.data(logdatastruct.tag == 1042);
logdatastruct.aecout_envelope_max = logdatastruct.data(logdatastruct.tag == 1051);
logdatastruct.aecout_envelope_avg = logdatastruct.data(logdatastruct.tag == 1052);
logdatastruct.process_interval_warning = logdatastruct.data(logdatastruct.tag == 1071);
logdatastruct.play_interval_warning = logdatastruct.data(logdatastruct.tag == 1101);
logdatastruct.play_interval_avg = logdatastruct.data(logdatastruct.tag == 1111);
logdatastruct.play_interval_max = logdatastruct.data(logdatastruct.tag == 1112);

logdatastruct.total_cpu_usage = logdatastruct.data(logdatastruct.tag == 1201);
logdatastruct.process_cpu_usage = logdatastruct.data(logdatastruct.tag == 1211);
logdatastruct.memory_usage = logdatastruct.data(logdatastruct.tag == 1221);
logdatastruct.token_free_memory = logdatastruct.data(logdatastruct.tag == 1222);
logdatastruct.token_total_memory = logdatastruct.data(logdatastruct.tag == 1223);
logdatastruct.process_memory_usage = logdatastruct.data(logdatastruct.tag == 1231);
logdatastruct.token_process_memory = logdatastruct.data(logdatastruct.tag == 1232);
logdatastruct.token_total_process_memory = logdatastruct.data(logdatastruct.tag == 1233);

logdatastruct.packet_length_avg = logdatastruct.data(logdatastruct.tag == 1301);
logdatastruct.net_jitter = logdatastruct.data(logdatastruct.tag == 1311);
logdatastruct.net_loss = logdatastruct.data(logdatastruct.tag == 1312);
logdatastruct.lost_sequences = logdatastruct.data(logdatastruct.tag == 1321);
logdatastruct.total_sequences = logdatastruct.data(logdatastruct.tag == 1322);
logdatastruct.receivable_sequences = logdatastruct.data(logdatastruct.tag == 1323);
logdatastruct.average_jitter = logdatastruct.data(logdatastruct.tag == 1351);
logdatastruct.average_loss = logdatastruct.data(logdatastruct.tag == 1352);
logdatastruct.otherside_rate = logdatastruct.data(logdatastruct.tag == 1353);
logdatastruct.switch_rate_out = logdatastruct.data(logdatastruct.tag == 1354);
logdatastruct.max_rtt = logdatastruct.data(logdatastruct.tag == 1361);
logdatastruct.min_rtt = logdatastruct.data(logdatastruct.tag == 1362);
logdatastruct.average_rtt = logdatastruct.data(logdatastruct.tag == 1363);

%..........................ReportLog..................................
logdatastruct.noise_energy = logdatastruct.data(logdatastruct.tag == 20021);
logdatastruct.heartbeat_time = logdatastruct.data(logdatastruct.tag == 20051);
logdatastruct.heartbeat_return = logdatastruct.data(logdatastruct.tag == 20052);
logdatastruct.network_packet = logdatastruct.data(logdatastruct.tag == 20061);
logdatastruct.jb_silent = logdatastruct.data(logdatastruct.tag == 20062);
logdatastruct.jb_voice = logdatastruct.data(logdatastruct.tag == 20063);
logdatastruct.buffer_reading_times = logdatastruct.data(logdatastruct.tag == 20064);
logdatastruct.jb_jitter = logdatastruct.data(logdatastruct.tag == 20065);
logdatastruct.sample_rate = logdatastruct.data(logdatastruct.tag == 21011);
logdatastruct.channels = logdatastruct.data(logdatastruct.tag == 21012);
logdatastruct.processing_points = logdatastruct.data(logdatastruct.tag == 21013);
logdatastruct.rtc_reset = logdatastruct.data(logdatastruct.tag == 21021);
logdatastruct.rtc_destroy = logdatastruct.data(logdatastruct.tag == 21031);
logdatastruct.noise_level = logdatastruct.data(logdatastruct.tag == 21041);
logdatastruct.farend_buffer_empty = logdatastruct.data(logdatastruct.tag == 21051);
logdatastruct.record_error = logdatastruct.data(logdatastruct.tag == 21081);
logdatastruct.volume_size = logdatastruct.data(logdatastruct.tag == 21091);
logdatastruct.jb_seq_too_low = logdatastruct.data(logdatastruct.tag == 21131);
logdatastruct.jb_seq_too_large = logdatastruct.data(logdatastruct.tag == 21141);
logdatastruct.average_delay = logdatastruct.data(logdatastruct.tag == 21151);
logdatastruct.min_delay = logdatastruct.data(logdatastruct.tag == 21152);
logdatastruct.max_delay = logdatastruct.data(logdatastruct.tag == 21153);
logdatastruct.average_burst = logdatastruct.data(logdatastruct.tag == 21154);
logdatastruct.packet_loss_num = logdatastruct.data(logdatastruct.tag == 21155);
logdatastruct.packet_lost_percent = logdatastruct.data(logdatastruct.tag == 21156);
logdatastruct.chat_time = logdatastruct.data(logdatastruct.tag == 21171);
%..........................ReportLog..................................

% [pathstr, log_creat_name, ext] = fileparts(filename);
% logdatastruct.log_creat_name = log_creat_name;
% logdatastruct.log_creat_time = log_creat_name(regexp(log_creat_name,'\d'));
[pathstr, log_name, ext] = fileparts(filename);
log_creat_name = [log_name ext];
logdatastruct.log_creat_name = log_creat_name;
logdatastruct.log_creat_time = log_creat_name(regexp(log_creat_name,'stat') + 4 :end);
%.....storage data to struct......

%......due with far and near called differ and sendto count and bytes in 1min......
far_near_differ_1min = [];
sendto_count_1min = [];
sendto_bytes_1min = [];
if(~isempty(logdatastruct.log_end_time))
    chat_time = (log_end_time - log_start_time)*24*3600;
    if (isempty(logdatastruct.chat_time))
        logdatastruct.chat_time = chat_time;
    end
    far_near_differ_1min = (maxFarNearDiffer - minFarNearDiffer) * 60 / chat_time;
    sendto_count_1min = sendto_count * 60 / chat_time;
    sendto_bytes_1min = sendto_bytes * 60 / chat_time;
end

logdatastruct.far_near_differ_1min = far_near_differ_1min;
logdatastruct.sendto_count_1min = sendto_count_1min;
logdatastruct.sendto_bytes_1min = sendto_bytes_1min;
%......due with far and near called differ and sendto count and bytes in 1min......

%......................due with the heart status..................
heartbeat_time_mean = [];
heartbeat_time_max = [];
heartbeat_time_median = [];
if(~isempty(logdatastruct.heartbeat_time))
    heartbeat_time_value = logdatastruct.heartbeat_time.value;
    heartbeat_time_mean = mean(heartbeat_time_value);
    heartbeat_time_max = max(heartbeat_time_value);
    heartbeat_time_median = median(heartbeat_time_value);
end
logdatastruct.heartbeat_time_mean = heartbeat_time_mean;
logdatastruct.heartbeat_time_max = heartbeat_time_max;
logdatastruct.heartbeat_time_median = heartbeat_time_median;
%......................due with the heart status..................

%......................due with the jitter buffer delay..................
min_delay_mean = [];
min_delay_max = [];
min_delay_median = [];
if(~isempty(logdatastruct.min_delay))
    min_delay_value = logdatastruct.min_delay.value;
    min_delay_mean = mean(min_delay_value);
    min_delay_max = max(min_delay_value);
    min_delay_median = median(min_delay_value);
end
logdatastruct.min_delay_mean = min_delay_mean;
logdatastruct.min_delay_max = min_delay_max;
logdatastruct.min_delay_median = min_delay_median;

max_delay_mean = [];
max_delay_max = [];
max_delay_median = [];
if(~isempty(logdatastruct.max_delay))
    max_delay_value = logdatastruct.max_delay.value;
    max_delay_mean = mean(max_delay_value);
    max_delay_max = max(max_delay_value);
    max_delay_median = median(max_delay_value);
end
logdatastruct.max_delay_mean = max_delay_mean;
logdatastruct.max_delay_max = max_delay_max;
logdatastruct.max_delay_median = max_delay_median;

logdatastruct.max_min_delay_mean_differ = max_delay_mean - min_delay_mean;
%......................due with the jitter buffer delay..................

%......................due with the network jitter..................
net_jitter_mean = [];
net_jitter_max = [];
net_jitter_median = [];
if(~isempty(logdatastruct.net_jitter))
    net_jitter_value = logdatastruct.net_jitter.value;
    net_jitter_mean = mean(net_jitter_value);
    net_jitter_max = max(net_jitter_value);
    net_jitter_median = median(net_jitter_value);
end
logdatastruct.net_jitter_mean = net_jitter_mean;
logdatastruct.net_jitter_max = net_jitter_max;
logdatastruct.net_jitter_median = net_jitter_median;
%......................due with the network jitter..................

%......................due with the network loss..................
net_loss_mean = [];
net_loss_max = [];
net_loss_median = [];
if(~isempty(logdatastruct.net_loss))
    net_loss_value = logdatastruct.net_loss.value;
    net_loss_mean = mean(net_loss_value);
    net_loss_max = max(net_loss_value);
    net_loss_median = median(net_loss_value);
end
logdatastruct.net_loss_mean = net_loss_mean;
logdatastruct.net_loss_max = net_loss_max;
logdatastruct.net_loss_median = net_loss_median;
%......................due with the network loss..................

%.................due with far and aceout correlation.............
time_step = 0.1;
min_number = 10;
min_interp_num = 100;
cor_far_aecout_max = [];
cor_far_aecout_avg = [];
valilty_cor_far_aecout_max = [];
valilty_cor_far_aecout_avg = [];

if (~isempty(logdatastruct.aecout_envelope_max) && ~isempty(logdatastruct.far_envelope_max))
    tmp_time1 = (logdatastruct.far_envelope_max.time - log_start_time )*24*3600;
    tmp_value1 = logdatastruct.far_envelope_max.value;
    tmp_time2 = (logdatastruct.aecout_envelope_max.time - log_start_time )*24*3600;
    tmp_value2 = logdatastruct.aecout_envelope_max.value;
    [cor_far_aecout_max, valilty_cor_far_aecout_max] = CorrcoefByInterpolation(tmp_time1, tmp_value1, tmp_time2, tmp_value2, time_step, min_number, min_interp_num);

    tmp_time1 = (logdatastruct.far_envelope_avg.time - log_start_time )*24*3600;
    tmp_value1 = logdatastruct.far_envelope_avg.value;
    tmp_time2 = (logdatastruct.aecout_envelope_avg.time - log_start_time )*24*3600;
    tmp_value2 = logdatastruct.aecout_envelope_avg.value;
    [cor_far_aecout_avg, valilty_cor_far_aecout_avg] = CorrcoefByInterpolation(tmp_time1, tmp_value1, tmp_time2, tmp_value2, time_step, min_number, min_interp_num);
end
logdatastruct.valilty_cor_far_aecout_max = valilty_cor_far_aecout_max;
logdatastruct.valilty_cor_far_aecout_avg = valilty_cor_far_aecout_avg;
logdatastruct.cor_far_aecout_max = cor_far_aecout_max;
logdatastruct.cor_far_aecout_avg = cor_far_aecout_avg;
%.................due with far and aecout correlation.............


%.................due with far and near correlation.............
time_step = 0.1;
min_number = 10;
min_interp_num = 100;
cor_far_near_max = [];
cor_far_near_avg = [];
valilty_cor_far_near_max = [];
valilty_cor_far_near_avg = [];
if (~isempty(logdatastruct.near_envelope_max) && ~isempty(logdatastruct.far_envelope_max))
    tmp_time1 = (logdatastruct.far_envelope_max.time - log_start_time )*24*3600;
    tmp_value1 = logdatastruct.far_envelope_max.value;
    tmp_time2 = (logdatastruct.near_envelope_max.time - log_start_time )*24*3600;
    tmp_value2 = logdatastruct.near_envelope_max.value;
    [cor_far_near_max, valilty_cor_far_near_max] = CorrcoefByInterpolation(tmp_time1, tmp_value1, tmp_time2, tmp_value2, time_step, min_number, min_interp_num);

    tmp_time1 = (logdatastruct.far_envelope_avg.time - log_start_time )*24*3600;
    tmp_value1 = logdatastruct.far_envelope_avg.value;
    tmp_time2 = (logdatastruct.near_envelope_avg.time - log_start_time )*24*3600;
    tmp_value2 = logdatastruct.near_envelope_avg.value;
    [cor_far_near_avg, valilty_cor_far_near_avg] = CorrcoefByInterpolation(tmp_time1, tmp_value1, tmp_time2, tmp_value2, time_step, min_number, min_interp_num);
end
logdatastruct.valilty_cor_far_near_max = valilty_cor_far_near_max;
logdatastruct.valilty_cor_far_near_avg = valilty_cor_far_near_avg;
logdatastruct.cor_far_near_max = cor_far_near_max;
logdatastruct.cor_far_near_avg = cor_far_near_avg;
%.................due with far and near correlation.............


%.................due with near and aceout correlation.............
time_step = 0.1;
min_number = 10;
min_interp_num = 100;
cor_near_aecout_max = [];
cor_near_aecout_avg = [];
valilty_cor_near_aecout_max = [];
valilty_cor_near_aecout_avg = [];

if (~isempty(logdatastruct.aecout_envelope_max) && ~isempty(logdatastruct.near_envelope_max))
    tmp_time1 = (logdatastruct.near_envelope_max.time - log_start_time )*24*3600;
    tmp_value1 = logdatastruct.near_envelope_max.value;
    tmp_time2 = (logdatastruct.aecout_envelope_max.time - log_start_time )*24*3600;
    tmp_value2 = logdatastruct.aecout_envelope_max.value;
    [cor_near_aecout_max, valilty_cor_near_aecout_max] = CorrcoefByInterpolation(tmp_time1, tmp_value1, tmp_time2, tmp_value2, time_step, min_number, min_interp_num);

    tmp_time1 = (logdatastruct.near_envelope_avg.time - log_start_time )*24*3600;
    tmp_value1 = logdatastruct.near_envelope_avg.value;
    tmp_time2 = (logdatastruct.aecout_envelope_avg.time - log_start_time )*24*3600;
    tmp_value2 = logdatastruct.aecout_envelope_avg.value;
    [cor_near_aecout_avg, valilty_cor_near_aecout_avg] = CorrcoefByInterpolation(tmp_time1, tmp_value1, tmp_time2, tmp_value2, time_step, min_number, min_interp_num);
end
logdatastruct.valilty_cor_near_aecout_max = valilty_cor_near_aecout_max;
logdatastruct.valilty_cor_near_aecout_avg = valilty_cor_near_aecout_avg;
logdatastruct.cor_near_aecout_max = cor_near_aecout_max;
logdatastruct.cor_near_aecout_avg = cor_near_aecout_avg;
%.................due with far and aecout correlation.............

%......................due with rtt..................
% max_rtt
max_rtt_mean = [];
max_rtt_max = [];
max_rtt_median = [];
if(~isempty(logdatastruct.max_rtt))
    max_rtt_value = logdatastruct.max_rtt.value;
    max_rtt_mean = mean(max_rtt_value);
    max_rtt_max = max(max_rtt_value);
    max_rtt_median = median(max_rtt_value);
end
logdatastruct.max_rtt_mean = max_rtt_mean;
logdatastruct.max_rtt_max = max_rtt_max;
logdatastruct.max_rtt_median = max_rtt_median;
% min_rtt
min_rtt_mean = [];
min_rtt_max = [];
min_rtt_median = [];
if(~isempty(logdatastruct.min_rtt))
    min_rtt_value = logdatastruct.min_rtt.value;
    min_rtt_mean = mean(min_rtt_value);
    min_rtt_max = max(min_rtt_value);
    min_rtt_median = median(min_rtt_value);
end
logdatastruct.min_rtt_mean = min_rtt_mean;
logdatastruct.min_rtt_max = min_rtt_max;
logdatastruct.min_rtt_median = min_rtt_median;
% average_rtt
average_rtt_mean = [];
average_rtt_max = [];
average_rtt_median = [];
if(~isempty(logdatastruct.average_rtt))
    average_rtt_value = logdatastruct.average_rtt.value;
    average_rtt_mean = mean(average_rtt_value);
    average_rtt_max = max(average_rtt_value);
    average_rtt_median = median(average_rtt_value);
end
logdatastruct.average_rtt_mean = average_rtt_mean;
logdatastruct.average_rtt_max = average_rtt_max;
logdatastruct.average_rtt_median = average_rtt_median;
%......................due with the heart status..................
