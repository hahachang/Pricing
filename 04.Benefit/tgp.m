function [TGP,GP_m] = tgp(GP_All,i,m,n,ultra_age,gp_scenario)
% TGP Summary of this function goes here
% [TGP,GP_m] = tgp(GP_All,i,m,n,ultra_age,gp_scenario)
% Detailed explanation goes here
% i interest rate 
% gp_scenario: Decide by n and sex
% Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
% Load GP Table and Create GP Matrix
	
	GP_Temp     = GP_All(:,gp_scenario);           %���GP
	GP_m_Temp   = GP_Temp' * m_parameter(m);    %GP���O��
	GP_m_Temp   = repmat(GP_m_Temp,n*m,1);      %Create GP Pattern in Pay Period    
	GP_m        = zeros(size(Time_M));          %Create GP_Matrix and it's size as same as Time_M
	GP_m        = overlap(GP_m_Temp,GP_m);      %Overlap

% Create TGP_Timeline
	TGP_Timeline = Time_m; %���W��

% Create TGP_power in pay GP period
	TGP_power_n      = TT+1;                                                               %�[1�O�]�����᪺����żƩM�����һ�
	TGP              = m * GP_m .*( (1+i).^TGP_power_n -(1+i) )/i + TGP_Timeline .* GP_m;  %����żƩM���������C�~�[�p�Q�����G+�C���O�O
    TGP(n*m:end,:)   = cumsum(TGP(n*m:end,:));                                             %��ú�O�������p��16���e���ǳ�
% Accumlate interest out of GP period!
	%{
	 => ���
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
	TGP_power_16 = (TT>=n).*(Time_M<16) ;                      %�p��ú�O������A���b16�����e�[�p�Q��������
	TGP_power_16 = cumsum( TGP_power_16 );                     %���Ʋ֥[�_�� 
	TGP          = ( TGP.*( (1+i).^TGP_power_16 ) ).*(Time_M<ultra_age);   %�[�p�Q��

end

