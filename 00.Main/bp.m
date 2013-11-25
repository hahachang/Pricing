function [ BP_period, BP_point ] = bp(m, n, ultra_age, Terminal_Age,buy_age_max);
%[ BP_period , BP_point ] = bp(m, n, ultra_age, Terminal_Age,buy_age_max);
%  BP_period is for "Period Benefit"
%  BP_point  is for "Point Benefit"
%Create Benefit Period matrix(filter)
% m : times of paying premium in one year
% n : times of paying premium
% ultra_age : the max age of q
% Terminal_Age : the terminal age of insurance
% buy_age_max :  the max buy age of insurance  

	%Create Timeline
		[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);

    %Two Filter:(1)age<=ultra_age (2)buy_age<=buy age max
	                
		BP_period                                 = (Time_M< ultra_age) .* (Time_M< Terminal_Age) .*  (xx<=buy_age_max);
		BP_point                                  = (Time_M<=ultra_age) .* (Time_M<=Terminal_Age) .*  (xx<=buy_age_max);   
end
