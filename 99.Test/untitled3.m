% %# cellarray
% C = {
%     'abc' [1]  [131]
%     'def' []   []
%     'gh'  [13] [999]
% };

%# write line-by-line
fid = fopen('file.csv','wt');
for i=1:size(com,1)
    fprintf(fid, '%s \n', com{i,:},[1,inf]);
end
fclose(fid);