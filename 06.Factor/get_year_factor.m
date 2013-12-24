function [ Factor_y,Factor_y_m,Factor_pre,Factor_pos] = get_year_factor(Input, m, n, ultra_age)
%Get 'Year' factor

%Create Timeline
    [Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
%Create Filter to get year index
    Filter                               = ((Time_m ==1) .* (TT<n)) + (TT>=n);
    Factor_y_temp                        = lookup2table(Filter,Input);
    Factor_y_temp(isnan(Factor_y_temp))  = 0; %decorate datas
	Factor_y                             = Factor_y_temp(:,1:ultra_age+1); %Squarized Matrix
	if (nargout > 1) && (nargout <= 2)
		Factor_y_m                       = Factor_y_temp(TT(:,1)+1,:);
	
	elseif nargout > 2
	
    	Factor_y_m                       = Factor_y_temp(TT(:,1)+1,:);
		Factor_pre = zeros(size(TT));
		Factor_pos = zeros(size(TT));
		TT_pre = TT(1:end-1,:)+1;
		TT_pos = TT(1:end-1,:)+2;
		Factor_pre(1:end-1,:) = Factor_y_temp(TT_pre(:,1),:);
		Factor_pos(1:end-1,:) = Factor_y_temp(TT_pos(:,1),:);
	end

end