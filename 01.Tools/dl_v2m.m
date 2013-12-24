function [ Output_M ] = dl_v2m( Input_V )
%將向量正規化為階梯遞減式矩陣. 
%{
Example:

a = 1 2 3 4 5
dl_v2m(a')
output = 
	1   2   3   4   5
	2   3   4   5   0
	3   4   5   0   0
	4   5   0   0   0
	5   0   0   0   0
%}

%   Detailed explanation goes here
% New Method

Sizes = size(Input_V,1);
a = [1:Sizes];
b = ones(1,Sizes);
Select_M = erase_dl(b'*a+a'*b-1);
c= fliplr(tril(ones(Sizes,Sizes)-eye(Sizes,Sizes)));
Select_M = Select_M+c;
Output_M = Input_V(Select_M);
Output_M = erase_dl(Output_M);




% % Old Method
% tic
% b = ones(Sizes,Sizes);
% b = rot90(tril(b));
% b = b - fliplr(eye(Sizes,Sizes))
% a = [1:Sizes];
% SN = zeros(Sizes,Sizes);
% for Loop_i = 1 : Sizes
%     SN(Loop_i,1:end-Loop_i+1) = a(1,Loop_i:end);
% end
% SN
% SN = Input_V(SN+b);
% Output_M = Erase_dl(SN);
% toc
