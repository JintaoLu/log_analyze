This project is used to get CC logs and analyze it.
0. You should installed MATLAB and Cygwin Terminal in Windows, or MATLAB in Linux.
1. Make sure those directories are all existent, if not, make them:
./bin        Include functions.
./raw_data   Store raw data pulls from FTP.
./mat_data   Store MATLAB using structure for logs.
2.Main scripts description:
get_CC_ftp_data.sh         Pull data from FTP
save_log_to_mat_file.m     Read data from raw_data, and save logs as MATLAB structures in ./mat_data
analyze_all_log.m          Analyze the mat data in ./mat_data.
analyze_single_log.m       Analyze a raw log when giving a file path.
3.Json summary is save in:
./json_summary


