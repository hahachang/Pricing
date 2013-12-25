function [ PV,PV_pre,PV_pos,GP_inforce,TGP_inforce,amt,PV_mid,P1P2,py,py_c,yp,yp_c,q,DB] = profit(Filing)
	SA_profit = 1;
	ii = 2.25/100;
	childmax = 16;
	Terminal_age            = 90;
	keyage      = { [0 10 20 30 40 50 60 70 75] , [0 10 20 30 40 50 60 70] };
	m           = Filing.Par.m;
	n           = Filing.Par.n;
	ultra_age   = Filing.Par.ultra_age;
	buy_age_max = Filing.Par.buy_age_max;
	sex         = Filing.Par.sex;

	GP                          = Filing.GNL.G(1,1:ultra_age);                           %yearize GP  (1 X M)
	[PV,PV_m,PV_m_pre,PV_m_pos] = get_year_factor( Filing.Benefit.PV , m, n, ultra_age ); %get year factor  (M X M)      
	PV_pre                      = get_year_factor( PV_m_pre , m, n, ultra_age );
	PV_pos                      = get_year_factor( PV_m_pos , m, n, ultra_age );
	Coupon                      = get_year_factor( Filing.Benefit.Coupon , m, n, ultra_age );
	P1                          = Filing.Revised.P1(1,1:ultra_age+1);                                %(1 X M)
	P2                          = Filing.Revised.P2(1,1:ultra_age+1);                                %(1 X M)
	P1P2                        = overlap( [P1 ; repmat(P2,n-1,1)] , zeros(ultra_age+1,ultra_age+1) ); %Create P1P2 Matrix

    [TV,TV_m,TV_m_pre,TV_m_pos] = get_year_factor( Filing.Benefit.TV , m, n, ultra_age ); %get year factor  (M X M)      
	TV_pre                      = get_year_factor( TV_m_pre , m, n, ultra_age );
	TV_pos                      = get_year_factor( TV_m_pos , m, n, ultra_age );
	
	P1_V                        = Valuation.Revised.P1(1,1:ultra_age+1);                                %(1 X M)
	P2_V                        = Valuation.Revised.P2(1,1:ultra_age+1);                                %(1 X M)
	P1P2_V                      = overlap( [P1_V ; repmat(P2_V,n-1,1)] , zeros(ultra_age+1,ultra_age+1) ); %Create P1P2 Matrix
	
	
%keyAge_filter
	keyage_select = keyage{1};
	GP            = GP    (:,keyage_select+1);
	PV            = PV    (:,keyage_select+1);
	PV_pre        = PV_pre(:,keyage_select+1);
	PV_pos        = PV_pos(:,keyage_select+1);
	P1P2          = P1P2  (:,keyage_select+1);
	Coupon        = Coupon(:,keyage_select+1);

	TV            = TV    (:,keyage_select+1);
	TV_pre        = TV_pre(:,keyage_select+1);
	TV_pos        = TV_pos(:,keyage_select+1);
	P1P2_V          = P1P2_V(:,keyage_select+1);
	
	
%Create Timeline for profit
	[ py, py_c, yp, yp_c ] = timeline_profit (m,ultra_age,length(keyage_select));
	age                    = py .+ keyage_select;

%BP_profit
	BP_profit   = (age<=Terminal_age);

%GP
	GP_12  = (py<=n) .* (yp_c==1) .* GP/m .* SA_profit;
	GP_12  = BP_profit .* GP_12;

%TGP
	TGP_12 = (py<=n) .* ( GP .* ( (1+ii).^(py)-(1+ii))/ii  +  yp.*GP/m)                                      + ...
			 (py> n) .* ( GP .* ( (1+ii).^(n)      -1)/ii) .* ((1+ii).^ min(childmax-keyage_select-n,py-n));

	TGP_12 = BP_profit .* TGP_12;
%AMT
	temp_amt = cumsum( (py_c==1) .* (py>n) .* ( (floor( (py-n-1)/5 )+1)*0.03) ); 
	amt      = (py<=n) .* (SA_profit) + (py>n).* (1+temp_amt) * (SA_profit);
	amt      = BP_profit .* amt;

%PV
	PV     = BP_profit .* m2m(PV,py);
	PV_pre = BP_profit .* m2m(PV_pre,py);
	PV_pos = BP_profit .* m2m(PV_pos,py);
	P1P2   = BP_profit .* m2m(P1P2,py);
	Coupon = BP_profit .* m2m(Coupon,py);
	
	% y_extend_m = py + (ultra_age+1) * (0:(length(keyage_select)-1)); %size(PV) = [112,9],so ultra_age must plus 1 to form series matrix. 
	% PV     = BP_profit .* PV    (y_extend_m);
	% PV_pre = BP_profit .* PV_pre(y_extend_m);
	% PV_pos = BP_profit .* PV_pos(y_extend_m);
	% P1P2   = BP_profit .* P1P2  (y_extend_m);
	% Coupon = BP_profit .* Coupon(y_extend_m);

	%percentage_24
	j_24  = py_c*2-1;
	j_24c = 24 - j_24;

	UP_24  = yp_c;
	UP_24c = 24/m - 1 - 2*(UP_24-1);

	%PV interpolation
	PV_mid = ( ((PV_pre - Coupon) .* j_24c) + (PV_pos .* j_24 ) )/24 + (P1P2 .* UP_24c /24) ;
	
%DB
	DB = (age<=max(childmax,keyage_select+n)) .*         max(TGP_12,PV_mid) +  ...
		 (age> max(childmax,keyage_select+n)) .* max(amt,max(TGP_12,PV_mid)) ;	
%TV
	TV     = BP_profit .* m2m(TV,py);
	TV_pre = BP_profit .* m2m(TV_pre,py);
	TV_pos = BP_profit .* m2m(TV_pos,py);
	P1P2_V = BP_profit .* m2m(P1P2_V,py);
	Coupon = BP_profit .* m2m(Coupon,py);
	
	% y_extend_m = py + (ultra_age+1) * (0:(length(keyage_select)-1)); %size(TV) = [112,9],so ultra_age must plus 1 to form series matrix. 
	% TV     = BP_profit .* TV    (y_extend_m);
	% TV_pre = BP_profit .* TV_pre(y_extend_m);
	% TV_pos = BP_profit .* TV_pos(y_extend_m);
	% P1P2   = BP_profit .* P1P2  (y_extend_m);
	% Coupon = BP_profit .* Coupon(y_extend_m);

	%percentage_24
	j_12  = py_c;
	j_12c = 12 - j_12;

	UP_12  = yp_c;
	UP_12c = 24/m - 1 - 2*(UP_24-1);

	%TV interpolation
	TV_mid = ( ((TV_pre - Coupon) .* j_12c) + (TV_pos .* j_12 ) )/12 + (P1P2_V .* UP_12c /12) ;



%DR



%q
	%Loading Prob of Death
	q_v         = q(sex,ismac());   
	%Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(1,n,ultra_age);
	%Create p & q
	Temp                 = Time_M;
	Temp(Temp>ultra_age) = 0;                                      %????»é?è¶??q?·åº¦???å­?
	q_v                  = overlap(q_v,zeros(ultra_age+1,1));
	q                    = q_v(Temp+1).*(Time_M<=ultra_age);       %?¨Time_Mä¾?????ï¼???¥æ³¨???1ï¼?????matlabä¸­array?¯å?1????????
	
	%Load exp_Table
    if ismac() == 1
        exp = csvread('/Users/chentaichang/Documents/MATLAB/Pricing/02.Sources/exp.csv'); %Macå°?? 
    else
        exp = csvread('D:\Pricing\02.Sources\exp.csv'); %MSå°?? 
    end
	exp_q = exp(2:end,2);   %get actual experience percentage of q
	exp_w = exp(2:end,3);   %get actral experience percentage of withdrawl
	
	exp_q = overlap(exp_q,zeros(ultra_age+1,1)); %form [ ultra_age+1 X 1 ] matrix
	exp_w = overlap(exp_w,zeros(ultra_age+1,1)); %form [ ultra_age+1 X 1 ] matrix

	q = q(:,keyage_select+1);                    %form [ ultra_age+1 X keyage ] matrix
	q = BP_profit .* m2m(q,py);                  %filter by BP_profit

	q                 = exp_q(py) .* q;          %calculate actual experience of q
	q(age==ultra_age) = 1;                       % q of "ultra_age" must be 1.  
	
	%periodize p q w
	p_12 = (1-q) .^ (1/12);                      
	q_12 = 1-p_12;
	w    = exp_w(py);                            %extend and repeat w to form a new [ Mm X keyage ] matrix 
	w_12 = 1-(1-w).^(1/12);
	
	%Calculate Inforce
	Inforce = BP_profit .* ( cumprod(p_12) .* cumprod(1-w_12) );
		
	%Extend Inforce [Mm X keyage] --> [Mm+1 X keyage]
	Inforce        = [ ones(1,length(keyage_select)); Inforce ];
	GP_inforce     = Inforce(1:end-1,:) .* GP;
	DB_inforce     = Inforce(1:end-1,:) .* DB .* q;
	Coupon_inforce = Inforce(2:end  ,:) .* Coupon;
	F              = 1;
	CV_inforce     = Inforce(2:end  ,:) .* w .* F .* PV;
	Comm           = GP_inforce .* exp_Comm;
	OR             = GP_inforce .* (py==1) .* exp_OR;
	
	
	end