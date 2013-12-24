function [q_filing , q_valuation] = q( sex, platform, tso_filing, tso_valuation )
%[q_filing , q_valuation] = q( sex, platform, tso_filing, tso_valuation )
%Load Q_Table
    if platform == 1
        Q=csvread('/Users/chentaichang/Documents/MATLAB/Pricing/02.Sources/12TSO.csv'); %Mac專用 
    else
        Q=csvread('D:\Pricing\02.Sources\12TSO.csv'); %MS專用 
    end
        
%Chose Male or Female death Probability
%Filing 
    if sex == 'm'
       q_filing        = tso_filing           * Q(:,2); %Male
	   q_filing(end,:) = 1;                             %Human must die at the ultra_age 
    else
       q_filing        = tso_filing           * Q(:,3); %Female
	   q_filing(end,:) = 1;                             %Human must die at the ultra_age 
    end    
        
%Valuation
    if sex == 'm'
       q_valuation        = tso_valuation     * Q(:,2); %Male
	   q_valuation(end,:) = 1;                          %Human must die at the ultra_age 
    else
       q_valuation        = tso_valuation     * Q(:,3); %Female
	   q_valuation(end,:) = 1;                          %Human must die at the ultra_age 
    end    


        
end