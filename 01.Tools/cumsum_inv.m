function [ Output_M ] = cumsum_inv (Input_M)
%cumsum是由爬坡相加，cumsum_inv則是下爬相加
%{
=>Example
	octave:303> a =ones(5,5)
	a =
	   1   1   1   1   1
	   1   1   1   1   1
	   1   1   1   1   1
	   1   1   1   1   1
	   1   1   1   1   1
	octave:304> b = fliplr(triu(a))
	b =
	   1   1   1   1   1
	   1   1   1   1   0
	   1   1   1   0   0
	   1   1   0   0   0
	   1   0   0   0   0
	octave:305> cumsum_inv(b)
	ans =
	   5   4   3   2   1
	   4   3   2   1   0
	   3   2   1   0   0
	   2   1   0   0   0
	   1   0   0   0   0
	octave:306> cumsum(b)
	ans =
	   1   1   1   1   1
	   2   2   2   2   1
	   3   3   3   2   1
	   4   4   3   2   1
	   5   4   3   2   1
<=ExampleEnd
%}

Index_MN = triu(ones(size(Input_M,1),size(Input_M,2))); 
Output_M = Index_MN * Input_M;                              %利用外積來做相加


end
