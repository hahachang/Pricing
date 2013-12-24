 
 function [ Benefit_map ] = check_benefit(Result,m,n,sex,age)
 [R,C] = cross_par(m,n,sex);
 
 pv     = Result{R,C}.Filing.Benefit.PV;
 pv_mid = Result{R,C}.Filing.Benefit.PV_mid;
 coupon = Result{R,C}.Filing.Benefit.Coupon;
 mb     = Result{R,C}.Filing.Benefit.MB;
 amt    = Result{R,C}.Filing.Benefit.AMT;
 db     = Result{R,C}.Filing.Benefit.DB;
 gp_c   = Result{R,C}.Filing.Benefit.GP_C;
 bp_period  = Result{R,C}.Filing.BP.BP_period;
 Benefit_map = [bp_period(:,age+1) db(:,age+1) gp_c(:,age+1) amt(:,age+1) pv(:,age+1) pv_mid(:,age+1) coupon(:,age+1) mb(:,age+1)];
 csvwrite('check_benefit.csv',Benefit_map);
 
 end