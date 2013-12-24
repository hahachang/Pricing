function [ AMT ] = amt( m, n, ultra_age)
%amt Summary of this function goes here
%   Detailed explanation goes here
% 創造當年度保險金額，每個商品都不一樣

%創造出年期矩陣，此目的是為了劃分出加計利息的時點
%Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
	
%Create AMT Pattern
	AMT     =  ( 0.03*(ceil((TT+1)/6)) ) .* (Time_m ==1);
	AMT     =  erase_dl(cumsum(AMT)+1);
end

