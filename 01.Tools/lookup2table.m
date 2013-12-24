function [ Output ] = lookup2table( Match_Mat , Target_Mat )
%Combine 'Match Row' to form a Table
%Example: Get 'Year' factors to form a Table   
%Measure 'Output Size' from Match_Mat
    Output_R             = sum(Match_Mat(:,1));
    Output_C             = sum(Match_Mat(1,:));
%Create Index of Target_Mat 
    Target_Index         = cumsum(ones(size(Target_Mat,1),1));
%Get 'Index_Matched' from 'Match_Mat' and 'Target_Index'    
    Index_Matched        = Target_Index(logical(Match_Mat(:,1)));
%Get 'Result' from 'Index_Matched'    
    Output = Target_Mat(Index_Matched,:);