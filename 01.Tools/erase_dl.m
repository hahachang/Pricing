function [ Output_M ] = erase_dl( Input_M )
%Erase_dl Summary of this function goes here
%   Detailed explanation goes here
% �h���﨤�u�H�U���(�O�d�﨤�u���)
Output_M = fliplr(triu(fliplr(Input_M ))); 
end

