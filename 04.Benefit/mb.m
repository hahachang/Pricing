function [ output_M ] = mb( mb_point,n_vector)
%%Survivor of Benefit correlated Policy Year
%   Detailed explanation goes here
temp = fliplr(eye(mb_point,mb_point));
count = length(n_vector);
temp = overlap(temp,zeros(111,111));
output_M = repmat(temp,1,count*2);




end

