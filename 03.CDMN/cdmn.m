function [ C,D,M,N ] = cdmn( i ,q_vec ,m , n, ultra_age )
% CDMN Summary of this function goes here
% Detailed explanation goes here
% 產出CDMN  
%Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
%Create p & q
	Temp                 = Time_M;
	Temp(Temp>ultra_age) = 0;                                      %開始去除超過q長度的數字
	q_vec                = overlap(q_vec,zeros(ultra_age+1,1));
	q                    = q_vec(Temp+1).*(Time_M<=ultra_age);     %用Time_M來對取值，特別注意加1，是因為matlab中array是從1開始而不是0
	p                    = (1-q).^((TT<n)/m+(TT>=n));              %在constant force下，算各個period下q所對應的p
	q                    = 1-p;                                    %算出各個period的q
	
%利率折現因子
	v  = (1+i).^(-Time_v);
	vh = (1+i).^(-Time_vh);
	
%D
	D      = cumprod(p).*v;                            %最後的row都是0，在維持matrix大小不變的情況下，將最後的row與其餘對調
	D      = [D(end,:);D(1:end-1,:)];                  %將對調後的matrix中的第一row都給予初始值1
	D(1,:) = 1;

%N
	index_MN = triu(ones(size(D,1),size(D,2)));        %創造特殊的矩陣，來完成MN的累加
	N        = index_MN*D;                             %運用Matrix*Matrix來計算累加。***得意之作

%C
	C_temp      = [p(end,:);p(1:end-1,:)];             %最後的row都是0，在維持matrix大小不變的情況下，將最後的row與其餘對調
	C_temp(1,:) = 1;                                   %將對調後的matrix中的第一row都給予初始值1
	C           = cumprod(C_temp).*q.*vh;              
%M
	M           = index_MN*C;                          %運用Matrix*Matrix來計算累加。***得意之作

end

