function [found_flag, index_column, index_row] = find_text(textLogs, length_log_cell, idxText, tag)
% function [finded_flag, index_column, index_row]= find_text(textLogs, length_log_cell, idxText, tag)
% This function is used to find |tag|, in |textLogs|. |idxText| is the nonumberic text index.
% 
length_nonumberic_data = length(idxText);
found_flag = 0;
for index_column = 2:length_log_cell
%     idxText2 = find(isnan(str2double(textLogs{index_column})) == 1);%Log for nonnumberic data
%     length_nonumberic_data = length(idxText2);
    length_log_text = length(textLogs{index_column});
    for index_row = 1:length_nonumberic_data
        if idxText(end) > length_log_text
            break;
        end
        if ~isempty(cell2mat(strfind(textLogs{index_column}(idxText(index_row)), tag)))
            found_flag = 1;
            break;
        end
    end
    if 1 == found_flag
        break;
    end
end