function [ Output_M ] = overlap( plug,socket )
%Overlap Summary of this function goes here
%   Detailed explanation goes here
% ��ӯx�}�ۭ��|
socket(1:size(plug,1),1:size(plug,2)) = plug;
Output_M =socket;


end

