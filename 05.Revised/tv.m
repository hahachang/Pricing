function  [TV, TV_mid, Revised_v, TV_component, TV_mid_component] = tv(DB, Coupon, MB, i_v, q_valuation, m, n, ultra_age,bp_max ,buy_age_max,GP_m,discount_max,gp_scenario)
%Create Timeline
	[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);
	[ C_v  , D_v  , M_v  , N_v ]   = cdmn( i_v, q_valuation, m, n, ultra_age );
	[BP_period , BP_point] = bp(m, n, ultra_age, bp_max ,buy_age_max);
	%Create TV
	TV                       = zeros    ( size(Time_M) );                 
    TV_mid                   = zeros    ( size(Time_M) );   
%Create TVFB TVFC TVMB
	TVFB   = cumsum_inv(  DB      .* C_v ) ./ D_v; 
	TVFC   = cumsum_inv(  Coupon  .* D_v ) ./ D_v;
	TVMB   = cumsum_inv(  MB      .* D_v ) ./ D_v;

%Revised_v 
    [ Revised_v ] = revised(TVFB, TVFC, TVMB, i_v, q_valuation, m, n, ultra_age,bp_max,GP_m,discount_max,gp_scenario);
    
%TVFP
	ratio_pre                       = max(Time_m*2-1 , (Time_m.*(TT>=n))*m ); 
	ratio_pos                       = erase_dl(2*m - ratio_pre);
	P1P2                            = bsxfun(@times,(TT==0),Revised_v.P1/m) + bsxfun(@times,(TT>0 & TT<n),Revised_v.P2/m);
    TVFP                            = cumsum_inv( P1P2.* D_v)./ D_v;
    TV                              = BP_point .* (TVFB + TVFC + TVMB - TVFP);     %Because MB at the ultra_age is "No Cost" of discounting.
	%Combine PV and MB to Complete PV
	TV(isnan(TV))=0;
	TV = TV + MB .* ( bp_max == ultra_age) ;
	
	
	[TV_y, TV_y_m,TV_pre,TV_pos]    = get_year_factor(TV, m, n, ultra_age);
	[Coupon_y, Coupon_y_m]          = get_year_factor(Coupon, m, n, ultra_age);
	TV_mid(1:end-1,:)               = ( ( TV_pre(1:end-1,:)-Coupon_y_m(1:end-1,:) ).*ratio_pos(1:end-1,:) + TV_pos(1:end-1,:).*ratio_pre(1:end-1,:) + P1P2(1:end-1,:)*m )/(2*m);
	TV_mid                          = BP_period .* TV_mid;
    TV_component                    = struct('TV',TV,'TVFB',TVFB,'TVFC',TVFC,'TVMB',TVMB,'TVFP',TVFP);
	TV_mid_component                = struct('TV_y_m',TV_y_m,'Coupon_y_m',Coupon_y_m,'P1P2',P1P2,'R_pre',ratio_pre,'R_pos',ratio_pos);
end
