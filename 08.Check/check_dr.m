 function [ dr_map ] = check_dr(Result,m,n,sex,age)
 [R,C] = cross_par(m,n,sex);
 
 dr     = Result{R,C}.Filing.DR;
 dr_v   = Result{R,C}.Valuation.DR;
 
 Benefit_map = [bp_period(:,age+1) db(:,age+1) gp_c(:,age+1) amt(:,age+1) pv(:,age+1) pv_mid(:,age+1) coupon(:,age+1) mb(:,age+1)];
 csvwrite('check_benefit.csv',Benefit_map);
 
 end
