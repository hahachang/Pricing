function  [PV, PV_mid, Revised, PV_component, PV_mid_component] = pv(DB, Coupon, MB, i, q_filing, m, n, ultra_age,bp_max ,buy_age_max)
%Create Timeline
	[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);
	[ C  , D  , M  , N ]   = cdmn( i, q_filing  , m, n, ultra_age );
	[BP_period , BP_point] = bp(m, n, ultra_age, bp_max ,buy_age_max);
	%Create PV
	PV                       = zeros    ( size(Time_M) );                 
    PV_mid                   = zeros    ( size(Time_M) );   
%Create PVFB PVFC PVMB
	PVFB   = cumsum_inv(  DB      .* C ) ./ D; 
	PVFC   = cumsum_inv(  Coupon  .* D ) ./ D;
	PVMB   = cumsum_inv(  MB      .* D ) ./ D;

%Revised 
    [ Revised ] = revised (PVFB, PVFC, PVMB, i, q_filing, m, n, ultra_age,bp_max);
    
%PVFP
	ratio_pre                       = max(Time_m*2-1 , (Time_m.*(TT>=n))*m ); 
	ratio_pos                       = erase_dl(2*m - ratio_pre);
	P1P2                            = bsxfun(@times,(TT==0),Revised.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised.P2/m);
    PVFP                            = cumsum_inv( P1P2.* D)./ D;
    PV                              = BP_point .* (PVFB + PVFC + PVMB - PVFP);     %Because MB at the ultra_age is "No Cost" of discounting.
	%Combine PV and MB to Complete PV
	PV(isnan(PV))=0;
	PV = PV + MB .* ( bp_max == ultra_age) ;
	[PV_y, PV_y_m,PV_pre,PV_pos]    = get_year_factor(PV, m, n, ultra_age);
	[Coupon_y, Coupon_y_m]          = get_year_factor(Coupon, m, n, ultra_age);
	PV_mid(1:end-1,:)               = ( ( PV_pre(1:end-1,:)-Coupon_y_m(1:end-1,:) ).*ratio_pos(1:end-1,:) + PV_pos(1:end-1,:).*ratio_pre(1:end-1,:) + P1P2(1:end-1,:)*m )/(2*m);
	PV_mid                          = BP_period .* PV_mid;
    PV_component                    = struct('PV',PV,'PVFB',PVFB,'PVFC',PVFC,'PVMB',PVMB,'PVFP',PVFP);
	PV_mid_component                = struct('PV_y_m',PV_y_m,'Coupon_y_m',Coupon_y_m,'P1P2',P1P2,'R_pre',ratio_pre,'R_pos',ratio_pos);
end