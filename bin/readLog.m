function [ textLogs,rowLogs, colLogs] = readLog( filename , Ncolumns, NMAX  )
% filename : �ļ���
% Ncolumns : ��ȡ������Ĭ��ֵΪ15������ʵ������С��15,���ȡ����colLogs��ʵ������
% NMAX����ȡ�ļ�ʱ���������Ĭ��Ϊ20
% textLogs����ȡ���Log��Ϣ
% rowLogs��textLogs������
% colLogs��textLogs������
if nargin < 2
    Ncolumns = 15;
    NMAX  = Ncolumns;
elseif nargin < 3 
    NMAX  = 20;
end

if Ncolumns > NMAX
    NMAX = Ncolumns;
end

fileID = fopen(filename,'r');
if  -1 == fileID
    disp('Log file is not existent!')
    return;
end
% �Զ��ŷָ�����ȡNMAX�е��ַ���������Ԫ������textLog��
textLog = textscan(fileID,repmat('%s',[1,NMAX]),'Delimiter',',');
fclose(fileID);
rowLogs = size(textLog{1},1);

%.......... preprocessing the log data ...........
date_pattern = '\d{4}_\d{2}_\d{2}T\d{2}:\d{2}:\d{2}:\d{3}';
idx_match = regexp(textLog{1},date_pattern);
% find the index of the wrong date format
idx_non_date = find(cellfun('isempty',idx_match) == 1);
if ~isempty(idx_non_date)
    if 1 == idx_non_date(1)
        % this log has no correct log information
        disp('this log is empty.');
        return;
    end
    % set the rowLogs to (idx_non_date(1) - 1)
    rowLogs = idx_non_date(1) - 1;
end

% find the index wheer record time begin decrease
log_record_time =  datenum(textLog{1}(1:rowLogs) , 'yyyy_mm_ddTHH:MM:SS:FFF');
if ~issorted(log_record_time)
    idx_decrease = find((log_record_time - [0; log_record_time(1:end-1)]) < 0);
    rowLogs = idx_decrease(1) - 1;
end

for k = 1:Ncolumns
    % �����K��Ϊ�գ�����Ϊ�ļ�ʵ��ֻ��K-1��
    if( isempty( char(textLog{k}) ) )
        Ncolumns = k - 1;
        break;
    end
    textLogs{k} = textLog{k}(1:rowLogs);
end

% rowLogs = size(textLog{1},1);
colLogs = Ncolumns;
% textLogs= textLog(1,1:Ncolumns);
clear textLog
end

