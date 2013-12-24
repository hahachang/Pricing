function [ Output ] = round_ex( Input , Decimal  )
%round的改良版
%Input = Vector or Matrix
%Decimal 小數點以下幾位	
	Output = round( Input .* (10^Decimal) ) ./ (10^Decimal);
end


