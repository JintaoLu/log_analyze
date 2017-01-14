clear all
addpath('./bin')
dbstop if error
% logPackagePath =  './raw_data/20161219_cc'; %log文件夹路径
% logPackagePath =  './20161225_cc'; %log文件夹路径
% logPackagePath =  './raw_data/20161225_cc'; %log文件夹路径
logPackagePath =  './data'; %log文件夹路径

logPackage = dir(logPackagePath); % 文件夹路径下的log文件夹
numLogPackage = size(logPackage,1);%log文件夹数目
index_k = 1;
for k_package = 3:numLogPackage   % 遍历文件夹
    namePackage = logPackage(k_package).name; % 提取子文件夹名字
    filePath = [logPackagePath '/' namePackage]; %子文件夹路径
    files = dir(filePath); % 子文件夹下log文件
    numFile = size(files,1); % 子文件夹下log文件数目
    for k_file = 3:numFile % 遍历log文件
            filename = [filePath '/' files(k_file).name];
            % Core processing. Get useful data from log text.
            tmp_structure = get_log_data(filename);
            if isempty(tmp_structure)
                continue;
            end
            log_data(index_k) = tmp_structure;
            index_k  = index_k + 1;
    end
end
save(['./mat_data/log_mat_' datestr(now(),'yyyymmddTHHMM') '.mat'], 'log_data');
