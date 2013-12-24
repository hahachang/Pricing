tic
[Filing,BP] = q118(6,1,'m',1,90,2.25/100);
toc
b=Filing.Benefit;
ex('TGP.csv',b.TGP*100000)

ex('PV_mid.csv',b.PV_mid*100000)

ex('PV.csv',b.PV*100000)

ex('DB.csv',b.DB*100000)

ex('MB.csv',b.MB*100000)
% 
% PV = Filing.PV;
% ex('PVFB.csv',(PV.PVFB+PV.PVMB)*100000)
% 
% ex('PVFC.csv',PV.PVFC*100000)
% 
% ex('PVFP.csv',PV.PVFP*100000)

