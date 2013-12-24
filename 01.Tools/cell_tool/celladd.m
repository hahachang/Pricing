function [ result ] = celladd (cell_1, cell_2)
%IF two cell's every structure are the same , we can use this method to "+"

result = cellfun(@(x,y) x+y,cell_1,cell_2,'UniformOutput',false);



endfunction
