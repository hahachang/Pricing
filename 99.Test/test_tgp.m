%Call Par
Par = test_par()
%input transform
i           = Par.i; 
m           = Par.m;
n           = Par.n;  
ultra_age   = Par.ultra_age;
gp_scenario = Par.gp_scenario; 
SA          = Par.SA;

%Loading GP 
	GP_All      = gp(2) / SA;    %1 means 'Mac';2 means 'MS'
	
[TGP,GP_m] = tgp(GP_All,i,m,n,ultra_age,gp_scenario)
% TGP Summary of this function goes here
% [TGP,GP_m] = tgp(GP_All,i,m,n,ultra_age,gp_scenario)
% Detailed explanation goes here
% i interest rate 
% gp_scenario: Decide by n and sex
% Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
% Load GP Table and Create GP Matrix
	
	GP_Temp     = GP_All(:,gp_scenario);           %選取GP
	GP_m_Temp   = GP_Temp' * m_parameter(m);    %GP期別化
	GP_m_Temp   = repmat(GP_m_Temp,n*m,1);      %Create GP Pattern in Pay Period    
	GP_m        = zeros(size(Time_M));          %Create GP_Matrix and it's size as same as Time_M
	GP_m        = overlap(GP_m_Temp,GP_m);      %Overlap

% Create TGP_Timeline
	TGP_Timeline = Time_m; %正規化

% Create TGP_power in pay GP period
	TGP_power_n      = TT+1;                                                               %加1是因為接後的等比級數和公式所需
	TGP              = m * GP_m .*( (1+i).^TGP_power_n -(1+i) )/i + TGP_Timeline .* GP_m;  %等比級數和公式模擬每年加計利息結果+每期保費
    TGP(n*m:end,:)   = cumsum(TGP(n*m:end,:));                                             %為繳費期滿但小於16歲前做準備
% Accumlate interest out of GP period!
	%{
	 => 實例
	   octave:96> [a b c d]=timeline(4,2,20);
	   octave:97> (c>=2).*(a<16)
	   ans =
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
	%}
	TGP_power_16 = (TT>=n).*(Time_M<16) ;                      %計數繳費期滿後，但在16歲之前加計利息的次數
	TGP_power_16 = cumsum( TGP_power_16 );                     %次數累加起來 
	TGP          = ( TGP.*( (1+i).^TGP_power_16 ) ).*(Time_M<ultra_age);   %加計利息



