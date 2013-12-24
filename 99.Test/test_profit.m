n = 6;
m = 4;
ultra_age = 111;
[Filing] = t_7i0(n,m,'m',1,75,2.25/100);





[ PV,PV_pre,PV_pos,GP_inforce,TGP_inforce,amt,PV_mid,P1P2,py,py_c,yp,yp_c,q,DB] = profit(Filing);

csvwrite('amt.csv',[py,100000*amt]);
csvwrite('PV_mid.csv',[py,100000*PV_mid]);
csvwrite('PV_pre.csv',[py,100000*PV_pre]);
csvwrite('PV_pos.csv',[py,100000*PV_pos]);
csvwrite('P1P2.csv',[py,100000*P1P2]);

select = 3;

PV_total=[py(:,select),PV_mid(:,select),PV_pre(:,select),PV_pos(:,select),P1P2(:,select)];
csvwrite('PV_Total.csv',[150000*PV_total]);

csvwrite('q.csv',[py,q]);

csvwrite('inforce.csv',[py(:,1),Inforce]);
csvwrite('DB.csv',[py(:,1),100000*DB]);