function [ AMT ] = amt( m, n, ultra_age)
%amt Summary of this function goes here
%   Detailed explanation goes here
% �гy��~�׫O�I���B�A�C�Ӱӫ~�����@��

%�гy�X�~���x�}�A���ت��O���F�����X�[�p�Q�������I
%Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
	
%Create AMT Pattern
	AMT     =  ( 0.03*(ceil((TT+1)/6)) ) .* (Time_m ==1);
	AMT     =  erase_dl(cumsum(AMT)+1);
end

