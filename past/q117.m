function [Filing,BP] = q117(n,m,sex,scenario,buy_age_max,i)
	TSO_Percent_Filing      = 100;
    TSO_Percent_Valuation   = 100;
    SA                      = 100000;
	Terminal_Age            = 90;
%Loading
%=====================================================================================	
	%Loading Prob of Death
		q_v         = q(sex,1);      %1 means 'Mac';2 means 'MS'
	%Loading GP 
		GP_All      = gp(1) / SA;    %1 means 'Mac';2 means 'MS'
%=====================================================================================	    
%Creat Boundary by Ultra Age    
	ultra_age = length(q_v);
	
%Create Timeline
	[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);

	%Create Benefit Period Filter
	BP = benefitperiod(m, n, ultra_age, Terminal_Age ,buy_age_max);
%q_Revised
    %because q maybe multiply percentage   
    
%Create CDMN
	[ C  , D  , M  , N ]   = cdmn( i, q_v  , m, n, ultra_age );
	
	
%Create Benefit
	[TGP , GP_m]       = tgp(GP_All,i, m, n, ultra_age, scenario);   
	TGP                = BP .* TGP;
	Coupon             = 0  .* coupon   ( m, n, ultra_age);            
    AMT                = BP .* amt      ( m, n, ultra_age);        
	MB                 = (Time_M==90) .* repmat(max(AMT),size(AMT,1),1);          
%Create PV
	PV                 = zeros    ( size(Time_M) );                 
    PV_mid             = zeros    ( size(Time_M) );                  

	%Create DB
	DB                 = BP .* (   ( (Time_M<16 | TT<n ).*max( TGP, PV_mid ) ) + ( (Time_M>=16 & Time_M<ultra_age & TT>=n).* max( TGP, max( AMT , PV_mid ) ) )   );

%Create PVFB PVFC PVMB
	PVFB   = cumsum_inv(  DB      .* C ) ./ D; 
	PVFC   = cumsum_inv(  Coupon  .* D ) ./ D;
	PVMB   = cumsum_inv(  MB      .* D ) ./ D;

%Revised 
    [ Revised ] = revised (PVFB, PVFC, PVMB, i, q_v, m, n, ultra_age);
    
%PVFP
	ratio_pre                       = max(Time_m*2-1 , (Time_m.*(TT>=n))*m ); 
	ratio_pos                       = erase_dl(2*m - ratio_pre);
	P1P2                            = bsxfun(@times,(TT==0),Revised.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised.P2/m);
    PVFP                            = cumsum_inv( P1P2.* D)./ D;
    PV                              = BP .* (PVFB + PVFC + PVMB - PVFP);     %Because MB at the ultra_age is "No Cost" of discounting.
	[PV_y, PV_y_m,PV_pre,PV_pos]    = get_year_factor(PV, m, n, ultra_age);
	[Coupon_y, Coupon_y_m]          = get_year_factor(Coupon, m, n, ultra_age);
	PV_mid(1:end-1,:)               = ( ( PV_pre(1:end-1,:)-Coupon_y_m(1:end-1,:) ).*ratio_pos(1:end-1,:) + PV_pos(1:end-1,:).*ratio_pre(1:end-1,:) + P1P2(1:end-1,:)*m )/(2*m);
	PV_mid                          = BP .* PV_mid;
	
	%PV_mid(1:end-1,:) = ( PV(1:end-1,:) - Coupon(1:end-1,:) + P1P2(1:end-1,:)+ PV(2:end,:) )/2;
    NP_Temp                         = zeros( 1,size(Time_M,1) );
    count_loop                      = 0;
   while any(abs(NP_Temp - BP(1,:).*Revised.NP) >=10^(-15))==1
       %%abs(NP_Temp - Revised.NP) >=10^(-15);
	   %%sum(abs(NP_Temp - Revised.NP) >=10^(-15));
	    NP_Temp = BP(1,:).*Revised.NP;
		DB                 = BP .* (   ( (Time_M<16 | TT<n ).*max( TGP, PV_mid ) ) + ( (Time_M>=16 & Time_M<ultra_age & TT>=n).* max( TGP, max( AMT , PV_mid ) ) )   );

		%Create PVFB PVFC PVMB
			PVFB   = cumsum_inv(  DB      .* C ) ./ D; 
			PVFC   = cumsum_inv(  Coupon  .* D ) ./ D;
			PVMB   = cumsum_inv(  MB      .* D ) ./ D;

		%Revised 
			[ Revised ] = revised (PVFB, PVFC, PVMB, i, q_v, m, n, ultra_age);
			
		%PVFP
			ratio_pre                       = max(Time_m*2-1 , (Time_m.*(TT>=n))*m ); 
			ratio_pos                       = erase_dl(2*m - ratio_pre);
			P1P2                            = bsxfun(@times,(TT==0),Revised.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised.P2/m);
			PVFP                            = cumsum_inv( P1P2.* D)./ D;
			PV                              = BP .* (PVFB + PVFC + PVMB - PVFP);     %Because MB at the ultra_age is "No Cost" of discounting.
			[PV_y, PV_y_m,PV_pre,PV_pos]    = get_year_factor(PV, m, n, ultra_age);
			[Coupon_y, Coupon_y_m]          = get_year_factor(Coupon, m, n, ultra_age);
			PV_mid(1:end-1,:)               = ( ( PV_pre(1:end-1,:)-Coupon_y_m(1:end-1,:) ).*ratio_pos(1:end-1,:) + PV_pos(1:end-1,:).*ratio_pre(1:end-1,:) + P1P2(1:end-1,:)*m )/(2*m);
			PV_mid                          = BP .* PV_mid;
				count_loop = count_loop+1;
   end
	count_loop;
	
% %Loading
    Loading    = 1-( Revised.NP_m ./ GP_m(1,:) );

	%Final Result	
		Filing.MainPar   = struct('n',n,'m',m,'sex',sex,'scenario',scenario);
		Filing.GNL       = struct('G',m*GP_m,'N',Revised.NP,'L',Loading);
		Filing.Benefit   = struct('DB',DB,'PV',PV,'PV_mid',PV_mid,'AMT',AMT,'Coupon',Coupon,'TGP',TGP,'MB',MB);
		Filing.Revised   = Revised;
		Filing.Test      = struct('PV_y_m',PV_y_m,'Coupon_y_m',Coupon_y_m,'P1P2',P1P2,'R_pre',ratio_pre,'R_pos',ratio_pos);
		Filing.PV        = struct('PVFB',PVFB,'PVFC',PVFC,'PVMB',PVMB,'PVFP',PVFP);
	%Filing.LoopCount = count_loop;


	
	
end
