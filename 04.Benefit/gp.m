function [ GP ] = gp(Platform)
% GP Summary of this function goes here
%   Detailed explanation goes here
%   Object:Load GP
	if Platform ==1 
		gp_temp                 = csvread('/Users/chentaichang/Documents/MATLAB/Pricing/02.Sources/GP.csv');       %Mac
	else
		gp_temp                 = csvread('D:\Pricing\02.Sources\GP.csv');       %MS 
	end
n_count                 = size(gp_temp,2);                               %�p���ƪ�Column��
gp_temp(isnan(gp_temp)) = 0;                                             %�h��Nan
GP = gp_temp(:,2:end);                                                   %�h����O�~�ָ��

%%%%% Extend GP for all n period %%%%%
% gp_temp                 = csvread('D:\Pricing\02.Sources\GP.csv');       %MS 
% n_count                 = size(gp_temp,2);                               %�p���ƪ�Column��
% gp_temp(isnan(gp_temp)) = 0;                                             %�h��Nan
% gp_temp                 = overlap(gp_temp,zeros(111,n_count));           %�|�[�A�X�R
% gp_temp                 = reshape(gp_temp,1,prod(size(gp_temp)));        %�N��ƩԦ��@���u(1x...)
% Output                  = ones(111,1)*gp_temp;                           %�X�R���зǧ�

%%%%% Old and Slow %%%%%
% function [Output] = GP(n,gender,n_vector)
% gp_temp = xlsread('D:\temp\matlab\Pricing\GP.csv');
% gp_temp(isnan(gp_temp))=0;
% column = size(gp_temp,2)/2;
% index = find(n_vector ==n);
% gp_temp = gp_temp(:,index+(gender-1)*column);
% temp = ones(1,111);
% Output = overlap((gp_temp*temp)',zeros(111,111));


end

