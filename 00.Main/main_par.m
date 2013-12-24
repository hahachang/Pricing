function C = main_par() 
Parameter.i                       = [2.25,2.25]/100; 
Parameter.i_v                     = [2.25,2.25]/100; 
Parameter.n                       = [6,10];
Parameter.m                       = [1,2,4,12];
Parameter.sex                     = ['m','f'];
Parameter.buy_age_max             = [75,70];
Parameter.buy_age_min             = [0,0];
Parameter.bp_max                  = 90;
Parameter.gp_scenario             = 1:length(Parameter.n)*length(Parameter.sex); 
Parameter.tso_filing              = 100/100;
Parameter.tso_valuation           = 100/100;
Parameter.SA	                  = 100000;

C  = parameter2cell(Parameter); %將參數轉為矩陣的型式，讓cellfun做迴圈使用。
C_element_size{1}  = structfun( @(x) size(x),C,'UniformOutput',false); %Check_size is correct or not!!??
end