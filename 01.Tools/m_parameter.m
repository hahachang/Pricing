function [ Parameter ] = m_parameter (m)
	
	switch m
		case 1
			Parameter =1;
		case 2
			Parameter =0.52;
		case 4
			Parameter =0.262;
		case 12
			Parameter =0.088;
	end
end


function [ Output ] = round_ex( Input , Decimal  )
%round的改良版
%Input = Vector or Matrix
%Decimal 小數點以下幾位	
	Output = round( Intput .* (10^Decimal) ) / (10^Decimal);
end