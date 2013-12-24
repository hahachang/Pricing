function [Coupon] = coupon (m,n,ultra_age)
%Survivor of Benefit correlated Policy Year
%Create Time_Coupon
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
	Time_Coupon                          = Time_m;

%Create Coupon Pattern
	Coupon_A                             = (TT< n) .*  0;                                %in pay period
	Coupon_B                             = (TT>=n) .* (TT<=ultra_age)*0;                 %out of pay period    
	Coupon                               = erase_dl(Coupon_A + Coupon_B);                %Standardize  
    
end
