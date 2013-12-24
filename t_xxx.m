function [ Pricing ] = t_xxx(n,m,sex,gp_scenario,buy_age_max,buy_age_min,i,i_v,bp_max,SA,tso_filing,tso_valuation)
%For 220
%[Filing] = t_220(n,m,sex,gp_scenario,buy_age_max,buy_age_min,i,bp_max,SA,TSO_filing,TSO_valuation)
% Filing{MainPar,GNL,Benefit,Revised}
% BP          : Benefit Period
% n           : 年期
% m           : 繳別
% sex         : 性別
% gp_scenario : 那一種GP 
% buy_age_max :
% buy_age_min :
% i           :  
% i_v         : 
% bp_max      :
% SA          :  
% tso_filing  :
% tso_valuation:
discount_max = 0.03;
%Loading Source
%=====================================================================================	
	%Loading Prob of Death
		[q_filing , q_valuation] = q(sex,ismac(),tso_filing,tso_valuation);      
	%Loading GP 
		GP_All      = gp(ismac()) / SA;  
%=====================================================================================	    
%Creat Boundary by Ultra Age    
	ultra_age = length(q_filing); %ex:12TSO's length  = 111
	
%Create Timeline
	[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);

	%Create Benefit Period Filter
	[BP_period , BP_point] = bp(m, n, ultra_age, bp_max ,buy_age_max);
%q_Revised
    %because q maybe multiply percentage   
    
%Create CDMN
%	[ C  , D  , M  , N ]   = cdmn( i, q_filing  , m, n, ultra_age );
    [ C_v , D_v, M_v,N_v]  = cdmn( i_v,q_valuation,m,n,ultra_age); 
%Create PV
	PV                       = zeros    ( size(Time_M) );                 
    PV_mid                   = zeros    ( size(Time_M) );   	
	
%Create Benefit
	[TGP , GP_m]             = tgp (GP_All,i, m, n, ultra_age, gp_scenario);   
	TGP                      = BP_period .* TGP;
	Coupon                   = BP_point  .* coupon   ( m, n, ultra_age);            
    AMT                      = BP_period .* amt      ( m, n, ultra_age);        
	MB                       = (Time_M==bp_max) .* repmat(max(AMT),size(AMT,1),1);          
    GP_min_Coupon            = 0 * BP_period .* (cumsum(GP_m)*1.06 - cumsum(Coupon));                 
    NP_Temp                  = zeros( 1,size(Time_M,1) );
	
    %Create DB
	DB                       = BP_period .* (   ...
										    ( (Time_M< 16 )                          .* TGP ) + ...
	                                        ( (Time_M>=16 & TT<n)                    .* max( TGP, PV_mid) ) + ...
									        ( (Time_M>=16 & Time_M<ultra_age & TT>=n).* max( TGP, max( AMT , PV_mid ) ) ) ...
									        );
    [PV, PV_mid, Revised, PV_component, PV_mid_component] = pv(DB, Coupon, MB, i, q_filing, m, n, ultra_age,bp_max ,buy_age_max);
    
    count_loop               = 0;
   while any(abs(NP_Temp - BP_period(1,:).*Revised.NP) >=10^(-15))==1
       %%abs(NP_Temp - Revised.NP) >=10^(-15);
	   %%sum(abs(NP_Temp - Revised.NP) >=10^(-15));
	    NP_Temp              = BP_period(1,:).*Revised.NP;
	DB                       = BP_period .* (   ...
										    ( (Time_M< 16 )                          .* TGP ) + ...
	                                        ( (Time_M>=16 & TT<n)                    .* max( TGP, PV_mid) ) + ...
									        ( (Time_M>=16 & Time_M<ultra_age & TT>=n).* max( TGP, max( AMT , PV_mid ) ) ) ...
									        );
        [PV, PV_mid, Revised, PV_component, PV_mid_component] = pv(DB, Coupon, MB, i, q_filing, m, n, ultra_age,bp_max ,buy_age_max);
	    count_loop                                            = count_loop+1;
   end
	count_loop;
	
	%DR of Filing
	DR_temp     =    (TT<n) .*  max(0, PV_mid_component.P1P2/m - GP_m*(1-discount_max) ) ;
	DR          =    cumsum_inv( DR_temp .* D_v)./ D_v;

	%CV	
	F  = f(m, n, ultra_age);
	CV = F .* PV;
	
	%TV
	[TV, TV_mid, Revised_v, TV_component, TV_mid_component] = tv(DB, Coupon, MB, i_v, q_valuation, m, n, ultra_age,bp_max ,buy_age_max,GP_m,discount_max,gp_scenario);
	
	%DR of Valuation
	DR_v_temp     =    (TT<n) .*  max(0, TV_mid_component.P1P2/m - GP_m*(1-discount_max) ) ;
	DR_v          =    cumsum_inv( DR_v_temp .* D_v)./ D_v;
	
	
    %Loading
        Loading          = 1 - ( Revised.NP_m ./ GP_m(1,:) );
		CP_ratio         = CV ./ cumsum(GP_m); 
	%Final Result	
		Filing.Par        = struct('n',n,'m',m,'sex',sex,'gp_scenario',gp_scenario,'ultra_age',ultra_age,'buy_age_max',buy_age_max,'SA',SA);
		Filing.GNL        = struct('GP',m*GP_m,'NP',Revised.NP,'L',Loading,'CP',CP_ratio);
		Filing.BP         = struct('BP_period',BP_period,'BP_point',BP_point);
		Filing.Benefit    = struct('DB',DB,'PV',PV,'PV_mid',PV_mid,'AMT',AMT,'Coupon',Coupon,'TGP',TGP,'MB',MB,'GP_C',GP_min_Coupon);
		Filing.Revised    = Revised;
		Filing.PV_mid     = PV_mid_component;
		Filing.PV         = PV_component;
		Filing.CV         = struct('CV',CV,'F',F);
		Filing.DR         = struct('DR',DR,'P2',Revised.P2/m,'GP_m',GP_m);
		Valuation.DR      = struct('DR',DR_v,'P2',Revised_v.P2/m,'GP_m',GP_m);
		Valuation.Revised = Revised_v;
		Valuation.TV      = TV_component; 
		
	    Pricing           = struct('Filing',Filing,'Valuation',Valuation);
		

	
	
end
