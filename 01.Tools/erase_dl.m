function [ Output_M ] = erase_dl( Input_M )
%Erase_dl Summary of this function goes here
%   Detailed explanation goes here
% 去除對角線以下資料(保留對角線資料)
Output_M = fliplr(triu(fliplr(Input_M ))); 
end

