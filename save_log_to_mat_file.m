clear all
addpath('./bin')
dbstop if error
% logPackagePath =  './raw_data/20161219_cc'; %log�ļ���·��
% logPackagePath =  './20161225_cc'; %log�ļ���·��
% logPackagePath =  './raw_data/20161225_cc'; %log�ļ���·��
logPackagePath =  './data'; %log�ļ���·��

logPackage = dir(logPackagePath); % �ļ���·���µ�log�ļ���
numLogPackage = size(logPackage,1);%log�ļ�����Ŀ
index_k = 1;
for k_package = 3:numLogPackage   % �����ļ���
    namePackage = logPackage(k_package).name; % ��ȡ���ļ�������
    filePath = [logPackagePath '/' namePackage]; %���ļ���·��
    files = dir(filePath); % ���ļ�����log�ļ�
    numFile = size(files,1); % ���ļ�����log�ļ���Ŀ
    for k_file = 3:numFile % ����log�ļ�
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
