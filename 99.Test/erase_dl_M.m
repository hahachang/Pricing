function [ Output_M ] = erase_dl_M( Input_M )
%Erase_dl Summary of this function goes here
%   Detailed explanation goes here
% 去除對角線以下資料(保留對角線資料)
% 且依其年期數和性別延伸更大更長的矩陣
% 用途1:將tgp超長矩陣標準化
[RR,CC] = size(Input_M) %計算Size
Count  = max(RR/CC,CC/RR) %計算有幾個單位矩陣
temp = erase_dl(ones(min(RR,CC),min(RR,CC))); %創造「標準化」的單位矩陣
Output_M = Input_M.*repmat(temp,max(RR/CC,1),max(CC/RR,1)); %創造「標準化」的「超長」矩陣
end