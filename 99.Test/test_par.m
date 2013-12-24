function Par = test_par()
% Test
% 輸入基本參數
Par_temp = input("i, n, m, sex, ultra_age, gp_scenario, SA \n");

Par.i            = Par_temp(1);
Par.n            = Par_temp(2);
Par.m            = Par_temp(3);
Par.sex          = Par_temp(4);
Par.ultra_age    = Par_temp(5);
Par.gp_scenario  = Par_temp(6);
Par.SA           = Par_temp(7);

end