function [ Output ] = dispstruct(Target,Index )
%For display 'Revised Data' of each Key vector
%Target is 'Structure Array'
%Index is 'XX.th' of each vector on Target
%Use Anonymous_function(A_Fun) to mapping data of each vector on Target;

A_fun  =@(x,y) structfun(@(x) x(y),x,'UniformOutput',false);
Output = A_fun(Target,Index);

end

