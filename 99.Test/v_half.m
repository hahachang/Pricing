function [ v_half ] = v_half( i , sizes )
%v_Half Summary of this function goes here
%   Detailed explanation goes here
% ¦~¤¤§é²{
v = (1+i)^(-1);
a = ones(sizes,1);
v_power = cumsum(a);
v_power = std_v2m(v_power);
v_half = v .^ (v_power-1/2);
v_half = erase_dl(v_half);
end