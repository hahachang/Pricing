%Load Q_Table
	Q=csvread('D:\Pricing\02.Sources\12TSO.csv'); %MS專用 

%基本參數
	i                       = 2.25/100;        %預定利率
	[age_number sex_number] = size(Q);          
	sizes                   = 111;
	bp_max                  = 90;
	n_vector                = [6 10 15 20];
	x_max                   = [74 70 65 60];
	x_min                   = [0 0 0 0];
	n                       = 6;
	m                       = 12;
	x_max                   = 110;
	ultra_age               = age_number;
    SA                      = 100000; 
	Scenario = 1;
%Create Timeline
	[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m, n, ultra_age);
	
%計算有幾個年期
	n_count = length(n_vector);

%取出男女發生率t
	q_male_v   = Q(:,2);
	q_female_v = Q(:,3);

%計算CDMN
	[ C_male  , D_male  , M_male  , N_male ]   = cdmn( i, q_male_v  , m, n, ultra_age );
	[ C_female, D_female, M_female, N_female ] = cdmn( i, q_female_v, m, n, ultra_age );
	
	
%計算DB
	[TGP , GP_m]       = tgp    (i, m, n, ultra_age, Scenario);
	Coupon             = coupon   ( m, n, ultra_age, SA);
	AMT                = amt      ( m, n, ultra_age, SA);
	PV                 = zeros    ( size(Time_M) );
    GP_m_Coupon        = cumsum(GP_m)*1.03 - cumsum(Coupon); 
	DB                 = ( (Time_M<16).*TGP ) + ( (Time_M>=16 & Time_M<ultra_age).*max( max(GP_m_Coupon,AMT) , PV ) );

%PVFB、PVFC
	PVFB   = sum( DB .* C_male )   ./ D_male;
	PVFC   = sum( Coupon .*D_male) ./ D_male;
	NP_L   = PVFB(1,:) ./ ( N_male(1,:) - N_male(n*m+1,:) );
	NP_S   = PVFC(1,:) ./ ( N_male(1,:) - N_male(n*m+1,:) );

ex('pvfb',PVFB)
ex('pvfc',PVFC)
ex('npl',NP_L)
ex('nps',NP_S)