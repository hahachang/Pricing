function [ Output_M ] = erase_dl_M( Input_M )
%Erase_dl Summary of this function goes here
%   Detailed explanation goes here
% �h���﨤�u�H�U���(�O�d�﨤�u���)
% �B�̨�~���ƩM�ʧO������j������x�}
% �γ~1:�Ntgp�W���x�}�зǤ�
[RR,CC] = size(Input_M) %�p��Size
Count  = max(RR/CC,CC/RR) %�p�⦳�X�ӳ��x�}
temp = erase_dl(ones(min(RR,CC),min(RR,CC))); %�гy�u�зǤơv�����x�}
Output_M = Input_M.*repmat(temp,max(RR/CC,1),max(CC/RR,1)); %�гy�u�зǤơv���u�W���v�x�}
end