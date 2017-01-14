function [ corr_interp , validity ,value1_interp ,value2_interp , t_interp] = CorrcoefByInterpolation(time1_log, value1_log, time2_log, value2_log, time_step, min_num, min_intersection_num)
% This function is used to compute the correlation coefficent by linear interpolation method.
% Input:
% time1_log , value1_log : The first time and value that need to be interpolated.
% time2_log , value2_log : The second time and value that need to be interpolated.
% time_step : The interpolating time stepsize.
% min_num : If the length of value_log* is less than |min_num|, correlation coefficent will not be calculated.
% min_intersection_num: If the length of interpolated value_log* is less than |min_intersection_num|, correlation coefficent will not be calculated.
%
% Output :
% corr_interp : the interpolated correlation coefficent. 
% validity : a logical vale . If |validity| is equal to 1 the corr_interp is valid.
% value1_interp ,value2_interp , t_interp : the interpolated values and time.

validity = 1;
corr_interp = -2;
value1_interp = [];
value2_interp = [];
t_interp = [];
%% The num is smaller than min_num ,then return
if ( (min_num >= length( value1_log )) || (min_num >= length( value2_log )) )
    validity = -1;
    disp('One of values length is too small!');
    return ;
end
%%  The log values are all 0 ,then return
if ( 0 == sum(value1_log) ) || ( 0 == sum(value2_log) )
    validity = -2 ;
    disp('One of values is zero vector!');   
    return ;
end
%% get interpolated times.
min_t1 = min(time1_log);
max_t1 = max(time1_log);
min_t2 = min(time2_log);
max_t2 = max(time2_log);

tstart = ceil( max(min_t1,min_t2));
tend = floor( min(max_t1,max_t2) ) ;

t_interp = tstart : time_step : tend;
if ( min_intersection_num >= length(t_interp))
    validity = -3 ;
    disp(['t_interp=' num2str(length(t_interp)) '! The intersection of value1_log and the value2_log is too small to calculate!']);   
    return ;
end

%% Interpolation
value1_interp = interp1( time1_log , value1_log , t_interp );
value2_interp = interp1( time2_log ,  value2_log , t_interp );

%% Calculate the correlation coefficent.
corr_tmp = corrcoef(value1_interp,value2_interp) ;
corr_interp = corr_tmp(1,end);

end

