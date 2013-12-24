
 function [ PV_map ] = check_pv(Result,sex,age)
 pv       = Result{sex}.Filing.Benefit.PV;
 pvfb     = Result{sex}.Filing.PV.PVFB;
 pvfc     = Result{sex}.Filing.PV.PVFC;
 pvmb     = Result{sex}.Filing.PV.PVMB;
 pvfp     = Result{sex}.Filing.PV.PVFP;
 bp_point = Result{sex}.Filing.BP.BP_point;

 PV_map = [(0:111)' bp_point(:,age) pv(:,age) pvfb(:,age) pvfc(:,age) pvmb(:,age) pvfp(:,age)];

 
 end
