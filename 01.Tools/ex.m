function [ Status ] = ex(Name,M)
%
csvwrite([Name ".csv"],M(:,1:111));
Status  = "OK";

end