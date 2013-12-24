function [ Target ] = checkdata(object)
%[ Target ] = checkdata(object)
%check Result of getpricing by using n,m,.... to get data 

n  = input("n :  "); 
m  = input("m :  ");
sex  = input("sex :  "); 


%Call main_par
C = main_par() ;

nn = cell2mat(C.n);
mm = cell2mat(C.m);
ss = cell2mat(C.sex);

[ i , j ] = find( ((nn == n).*(mm == m).*(ss == sex)) == 1);
 
Target = object{i,j};
end
