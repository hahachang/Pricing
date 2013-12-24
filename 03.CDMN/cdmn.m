function [ C,D,M,N ] = cdmn( i ,q_vec ,m , n, ultra_age )
% CDMN Summary of this function goes here
% Detailed explanation goes here
% ���XCDMN  
%Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m,n,ultra_age);
%Create p & q
	Temp                 = Time_M;
	Temp(Temp>ultra_age) = 0;                                      %�}�l�h���W�Lq���ת��Ʀr
	q_vec                = overlap(q_vec,zeros(ultra_age+1,1));
	q                    = q_vec(Temp+1).*(Time_M<=ultra_age);     %��Time_M�ӹ���ȡA�S�O�`�N�[1�A�O�]��matlab��array�O�q1�}�l�Ӥ��O0
	p                    = (1-q).^((TT<n)/m+(TT>=n));              %�bconstant force�U�A��U��period�Uq�ҹ�����p
	q                    = 1-p;                                    %��X�U��period��q
	
%�Q�v��{�]�l
	v  = (1+i).^(-Time_v);
	vh = (1+i).^(-Time_vh);
	
%D
	D      = cumprod(p).*v;                            %�̫᪺row���O0�A�b����matrix�j�p���ܪ����p�U�A�N�̫᪺row�P��l���
	D      = [D(end,:);D(1:end-1,:)];                  %�N��ի᪺matrix�����Ĥ@row��������l��1
	D(1,:) = 1;

%N
	index_MN = triu(ones(size(D,1),size(D,2)));        %�гy�S���x�}�A�ӧ���MN���֥[
	N        = index_MN*D;                             %�B��Matrix*Matrix�ӭp��֥[�C***�o�N���@

%C
	C_temp      = [p(end,:);p(1:end-1,:)];             %�̫᪺row���O0�A�b����matrix�j�p���ܪ����p�U�A�N�̫᪺row�P��l���
	C_temp(1,:) = 1;                                   %�N��ի᪺matrix�����Ĥ@row��������l��1
	C           = cumprod(C_temp).*q.*vh;              
%M
	M           = index_MN*C;                          %�B��Matrix*Matrix�ӭp��֥[�C***�o�N���@

end

