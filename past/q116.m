function [Filing] = q116(n,m,sex,scenario,buy_age_max,i)
    TSO_Percent_Filing      = 100;
    TSO_Percent_Valuation   = 100;
    SA                      = 100000;
%Loading å¤??è³??
%=====================================================================================	
	%Loading Prob of Death
		q_v         = q(sex,2);      %1 means 'Mac';2 means 'MS'
	%Loading GP 
		GP_All      = gp(2) / SA;    %1 means 'Mac';2 means 'MS'
%=====================================================================================	    
%Creat Boundary by Ultra Age    
	ultra_age = length(q_v);
	
%Create Timeline
	[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);

	%Create Benefit Period Filter
	BP = benefitperiod(m, n, ultra_age, buy_age_max);
    
%q_Revised
    %because q maybe multiply percentage   
    
%Create CDMN
	[ C  , D  , M  , N ]   = cdmn( i, q_v  , m, n, ultra_age );
	
	
%Create Benefit
	[TGP , GP_m]       = tgp      (GP_All,i, m, n, ultra_age, scenario);   
	TGP                = BP .* TGP;
	Coupon             = BP .* coupon   ( m, n, ultra_age);            
    AMT                = BP .* amt      ( m, n, ultra_age);        
	MB                 = BP .* (Time_M==ultra_age).*repmat(max(AMT),size(Time_M,1),1);                 
    GP_min_Coupon      = BP .* (cumsum(GP_m)*1.03 - cumsum(Coupon));       
	
%Create PV
	PV                 = zeros    ( size(Time_M) );                 
    PV_mid             = zeros    ( size(Time_M) );                  

	%Create DB
	DB                 = ( (Time_M<16).*TGP ) + ( (Time_M>=16 & Time_M<ultra_age).*max( max(GP_min_Coupon,AMT) , PV_mid ) );

%Create PVFB PVFC
	PVFB   = cumsum_inv(  DB .* C          ) ./ D;
	PVFC   = cumsum_inv( (Coupon + MB) .*D ) ./ D;

%Revised 
    [ Revised ] = revised (PVFB, PVFC, i, q_v, m, n, ultra_age);
    
%PVFP

    P1P2              = bsxfun(@times,(TT==0),Revised.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised.P2/m);
    PVFP              = cumsum_inv( P1P2.* D)./ D;
    PV                = BP .* ( (PVFB + PVFC - PVFP) + (Time_M==ultra_age).* MB );     %Because MB at the ultra_age is "No Cost" of discounting.
	PV_mid(1:end-1,:) = ( PV(1:end-1,:) - Coupon(1:end-1,:) + P1P2(1:end-1,:)+ PV(2:end,:) )/2;
    NP_Temp           = zeros( 1,size(Time_M,1) );
    count_loop =0;
   while any(abs(NP_Temp - Revised.NP) >=10^(-16))==1
       
	   NP_Temp = Revised.NP;
       DB                 = ( (Time_M<16).*TGP ) + ( (Time_M>=16 & Time_M<ultra_age).*max( max(GP_min_Coupon,AMT) , PV_mid ) );
       %Create PVFB PVFC
		PVFB   = cumsum_inv(  DB .* C          ) ./ D;
		PVFC   = cumsum_inv( (Coupon + MB) .*D ) ./ D;

       %Revised 
        [ Revised ] = revised (PVFB, PVFC, i, q_v, m, n, ultra_age);
        
       %PVFP
        P1P2              = bsxfun(@times,(TT==0),Revised.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised.P2/m);
        PVFP              = cumsum_inv( P1P2.* D)./ D;
        PV                = BP .* (PVFB + PVFC - PVFP);
        PV_mid(1:end-1,:) = ( PV(1:end-1,:) - Coupon(1:end-1,:) + P1P2(1:end-1,:)+ PV(2:end,:) )/2;
		count_loop = count_loop+1;
   end
    %%count_loop;
	
%Loading
    Loading    = 1-( Revised.NP_m ./ GP_m(1,:) );

	%Final Result	
    Filing.MainPar   = struct('n',n,'m',m,'sex',sex,'scenario',scenario);
	Filing.GNL       = struct('G',m*GP_m,'N',Revised.NP,'L',Loading);
    Filing.Benefit   = struct('DB',DB,'PV',PV,'AMT',AMT,'Coupon',Coupon,'TGP',TGP);
	Filing.Revised   = Revised;
	%Filing.LoopCount = count_loop;

end