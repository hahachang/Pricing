function [ Output_M ] = std_v2m( Input_V )
%STD_V2M Summary of this function goes here
%{
%########Example########
octave:31> a =1:5
a =
   1   2   3   4   5
octave:32> std_v2m(a')
ans =
   1   1   1   1   1
   2   2   2   2   0
   3   3   3   0   0
   4   4   0   0   0
   5   0   0   0   0
%########Example########
%}
temp_M = Input_V*ones(1,size(Input_V,1));
Output_M = erase_dl(temp_M);

% 舊的，沒有差很多，只是可以更簡潔而已
% tic
% V_Size =  size(Input_V)
% Output_M=repmat(Input_V,1,V_Size)
% Output_M = triu(Output_M)
% Output_M = Output_M(1:1:end,end:-1:1)
% toc


end

