 function [ PV_mid_map ] = check_pv_mid(Result,sex,age)
 pv         = Result{sex}.Filing.Benefit.PV;
 pv_y_m     = Result{sex}.Filing.PV_mid.PV_y_m;
 coupon_y_m = Result{sex}.Filing.PV_mid.Coupon_y_m;
 p1p2       = Result{sex}.Filing.PV_mid.P1P2;
 r_pre      = Result{sex}.Filing.PV_mid.R_pre;
 r_pos      = Result{sex}.Filing.PV_mid.R_pos;
 bp_period  = Result{sex}.Filing.BP.BP_period;
 PV_mid_map = [(0:111)' bp_period(:,age) pv(:,age) pv_y_m(:,age) coupon_y_m(:,age) p1p2(:,age) r_pre(:,age) r_pos(:,age)];

 
 end
