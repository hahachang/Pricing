function [ Fixed_P1 ] = fixed_p1 (Platform)


	if Platform ==1 
		p1_temp                 = csvread('/Users/chentaichang/Documents/MATLAB/Pricing/02.Sources/fixed_p1.csv'); 
	else
		p1_temp                 = csvread('D:\Pricing\02.Sources\fixed_p1.csv');       %MS 
	end
n_count                 = size(p1_temp,2);                               %計算資料的Column數
p1_temp(isnan(p1_temp)) = 0;                                             %去除Nan
Fixed_P1 = p1_temp(:,2:end);											 %去除投保年齡

end
