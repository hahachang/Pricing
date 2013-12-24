function [ py, py_c, yp, yp_c ] = timeline_profit (m,ultra_age,buy_age_max)
%Creat timeline for Profit
%[ py, py_c, yp, yp_c ] = timeline_profit (m,ultra_age,buy_age_max)
%py   : policy year
%py_c : counts in the policy year
%yp   : period in the year
%yp_c : counts in the period of the year


%py
temp = 1:ultra_age;
temp_a = repmat(temp,12,1);
temp_b = reshape(temp_a , prod(size(temp_a)), 1);
py     = repmat(temp_b , 1 , buy_age_max);

%py_c
a = 1:12;
py_c   = repmat(a',ultra_age, buy_age_max);

%yp
yp     = floor( (py_c-1) / (12/m) ) + 1;
%yp_c
yp_c   = mod( py_c-1, (12/m) ) + 1 ;


end