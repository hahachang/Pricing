function [Revised,aa] = q115(m)
tic
%基本參數
	Insurance_Name          = '7F0';
	i                       = 2.25/100;        %預定利率
	%[age_number sex_number] = size(Q);          
	sizes                   = 111;
	bp_max                  = 90;
	n_vector                = [6 10 15 20];
	x_max                   = [74 70 65 60];
	x_min                   = [0 0 0 0];
	n                       = 20;
	%m                       = 12;
	buy_age_max             = 70;
	ultra_age               = 111;
    SA                      = 100000; 
    TSO_Percent_Filing      = 100;
    TSO_Percent_Valuation   = 100;
	Scenario                = 4;                  %目前暫時設定為1，代表第1組。
	n_count                 = length(n_vector);   %計算有幾個年期
%Create Timeline
	[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);
%Create Benefit Period Filter
	BP = benefitperiod(m, n, ultra_age, buy_age_max);

%Loading 外部資料
%=====================================================================================	
	%取出男女發生率t
		q_v         = q('m',2); %1代表Mac、2代表MS
	%讀取GP
		GP_All      = gp(2) / SA;    %讀進GP檔案，此矩陣之數值尚未因年期而有所調整。除SA的目的，是為了單位化!
%=====================================================================================	    
    
%q_Revised
    %because q maybe multiply percentage   
    
%計算CDMN
	[ C  , D  , M  , N ]   = cdmn( i, q_v  , m, n, ultra_age );
	
	
%計算Benefit
	[TGP , GP_m]       = tgp      (GP_All,i, m, n, ultra_age, Scenario);   %所繳保險費加計利息
	TGP                = BP .* TGP;
	Coupon             = BP .* coupon   ( m, n, ultra_age);            %和保單年度相關的生存金額
    AMT                = BP .* amt      ( m, n, ultra_age);            %當年度保險金額
	MB                 = BP .* (Time_M==ultra_age).*repmat(max(AMT),size(Time_M,1),1);                  %和歲數    相關的生存金額  
    GP_min_Coupon      = BP .* (cumsum(GP_m)*1.03 - cumsum(Coupon));       %所繳保費*1.03扣除已領取的Coupon 
	
%宣告PV
	PV                 = zeros    ( size(Time_M) );                  %先行宣告PV的空間，另一方面是因為回算取大的初始值   
    PV_mid             = zeros    ( size(Time_M) );                  %先行宣告PV_mid的空間，另一方面是因為回算取大的初始值   
%第一次DB
	DB                 = ( (Time_M<16).*TGP ) + ( (Time_M>=16 & Time_M<ultra_age).*max( max(GP_min_Coupon,AMT) , PV_mid ) );

%PVFB、PVFC
	PVFB   = cumsum_inv(  DB .* C          ) ./ D;
	PVFC   = cumsum_inv( (Coupon + MB) .*D ) ./ D;

%Revised 
    [ Revised ] = revised (PVFB, PVFC, i, q_v, m, n, ultra_age);
    
%PVFP

    P1P2              = bsxfun(@times,(TT==0),Revised.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised.P2/m);
    PVFP              = cumsum_inv( P1P2.* D)./ D;
    PV                = BP .* (PVFB + PVFC - PVFP);
	PV_mid(1:end-1,:) = ( PV(1:end-1,:) - Coupon(1:end-1,:) + P1P2(1:end-1,:)+ PV(2:end,:) )/2;
    NP_Temp           = zeros( 1,size(Time_M,1) );
    count_loop =0;
   while (any(abs(NP_Temp - Revised.NP) >=10^(-10))==1 ) && count_loop<=6000
		aa = (abs(NP_Temp - Revised.NP) >=10^(-10)==1); 
	   NP_Temp = Revised.NP;
       DB                 = ( (Time_M<16).*TGP ) + ( (Time_M>=16 & Time_M<ultra_age).*max( max(GP_min_Coupon,AMT) , PV_mid ) );
       %PVFB、PVFC
		PVFB   = cumsum_inv(  DB .* C          ) ./ D;
		PVFC   = cumsum_inv( (Coupon + MB) .*D ) ./ D;

       %Revised 
        [ Revised ] = revised (PVFB, PVFC, i, q_v, m, n, ultra_age);
        
       %PVFP
        P1P2              = bsxfun(@times,(TT==0),Revised.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised.P2/m);
        PVFP              = cumsum_inv( P1P2.* D)./ D;
        PV                = BP .* (PVFB + PVFC - PVFP);
        PV_mid(1:end-1,:) = ( PV(1:end-1,:) - Coupon(1:end-1,:) + P1P2(1:end-1,:)+ PV(2:end,:) )/2;
		count_loop = count_loop+1
   end
    count_loop
	toc
%   
% %Loading
    Loading = 1-( Revised.NP_m ./ GP_m(1,:) );
	NP      = Revised.NP;
end
%     
%     
% 
% ex('pvfb',PVFB)
% ex('pvfc',PVFC)
% ex('npl',NP_L)
% ex('nps',NP_S)