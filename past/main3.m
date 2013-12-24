tic
Parameter.i         =  [2.25, 2.25, 2.25, 2.25]/100; 
Parameter.i_v       =  [2.25, 2.25, 2.25, 2.25]/100; 
Parameter.n         =  [6, 10, 15, 20];
Parameter.m         =  [1, 2, 4, 12];
Parameter.sex       =  ['m','f'];
Parameter.buy_age_max = [70, 65, 60, 55];
Parameter.buy_age_min = [ 0,  0,  0,  0];
Parameter.bp_max      = 90;
Parameter.scenario = 1:length(Parameter.n)*length(Parameter.sex); 

C = parameter2cell(Parameter);

Result = cellfun(@(n,m,sex,scenario,buy_age_max,i) q116(n,m,sex,scenario,buy_age_max,i) , ...
                   C.n,C.m,C.sex,C.scenario,C.buy_age_max,C.i,'UniformOutput',false);
toc