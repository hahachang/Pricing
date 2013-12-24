function [ R,C ] = cross_par (m,n,sex)
%cross and check out the location of main_par
%R = Row
%C = Column
Par = main_par;
cross_get = (cell2mat(Par.m)==m) .* (cell2mat(Par.n)==n) .* (cell2mat(Par.sex) ==sex);
[R C]     = find(cross_get ==1);  

endfunction
