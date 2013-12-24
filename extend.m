function [ Output ] = extend (m,n,BP)

temp_a = 1:n*12;   %Create basic series
temp_b = floor( (temp_a-1)/(12/m) )+1;  %Create 

temp_c = n*m+1:m*n+BP-n
temp_d = repmat(temp_c,12,1);
temp_e = reshape(temp_d,prod(size(temp_d)),1);
Output = [temp_b' ; temp_e];
end
