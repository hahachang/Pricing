function [ F ] = f (m , n, ultra_age )
%Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
switch n
	case 6
		F = 0.75 .* (TT<6) + 0.99 .* (TT>=6 & TT<10) + 1.* (TT>=10);
	case 10
		F = 0.75 + 0.25 .* ( min(n,TT)./n );
end	
	check_f = [Time_M(:,1) F(:,1)];
	
	
end
