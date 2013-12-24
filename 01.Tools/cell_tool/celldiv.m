function [ result ] = celldiv(cell_1, cell_2)


result = cellfun(@(x,y) x./y,cell_1,cell_2,'UniformOutput',false);



endfunction
