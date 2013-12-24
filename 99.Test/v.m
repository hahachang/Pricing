function [ Output_M ] = v( i , sizes )
%v Summary of this function goes here
%   Detailed explanation goes here
%  ¦~¥¼§é²{
v = (1+i)^(-1);
v_power = ones(sizes,1);
v_power = cumsum(v_power);
v_power = std_v2m(v_power);
Output_M = v .^ (v_power-1);
Output_M= erase_dl(Output_M);
end

 