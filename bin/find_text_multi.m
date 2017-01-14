function [found_flag, index_column, index_row] = find_text_multi(textLogs, length_log_cell, idxText, tag)
% function [finded_flag, index_column, index_row]= find_text_multi(textLogs, length_log_cell, idxText, tag)
% This function is used to find |tag|, in |textLogs|. |idxText| is the nonumberic text index.
% This function return all found |tag| index.
length_nonumberic_data = length(idxText);
found_flag = 0;
index_column = [];
index_row = [];
for i = 2:length_log_cell
    length_log_text = length(textLogs{i});
    for k = 1:length_nonumberic_data
        if idxText(end) > length_log_text
            break;
        end
        if ~isempty(cell2mat(strfind(textLogs{i}(idxText(k)), tag)))
            index_column(end + 1) = i;
            index_row(end + 1) = k;
            found_flag = 1;
        end
    end
end