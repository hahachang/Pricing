tic
%�򥻰Ѽ�
	i                       = 2.25/100;        %�w�w�Q�v
	%[age_number sex_number] = size(Q);          
	sizes                   = 111;
	bp_max                  = 90;
	n_vector                = [6 10 15 20];
	x_max                   = [74 70 65 60];
	x_min                   = [0 0 0 0];
	n                       = 6;
	m                       = 12;
	buy_age_max             = 70;
	ultra_age               = 111;
    SA                      = 100000; 
    TSO_Percent_Filing      = 100;
    TSO_Percent_Valuation   = 100;
	Scenario                = 1;                  %�ثe�Ȯɳ]�w��1�A�N���1�աC
	n_count                 = length(n_vector);   %�p�⦳�X�Ӧ~��
%Create Timeline
	[Time_M, Time_m, xx, TT, Time_v, Time_vh] = timeline(m, n, ultra_age);
%Create Benefit Period Filter
	BP = benefitperiod(m, n, ultra_age, buy_age_max);

%Loading �~�����
%=====================================================================================	
	%���X�k�k�o�Ͳvt
		q_v         = q('m',1); %1�N��Mac�B2�N��MS
	%Ū��GP
		GP_All      = gp(1);    %Ū�iGP�ɮסA���x�}���ƭȩ|���]�~���Ӧ��ҽվ�
%=====================================================================================	    
    
%q_Revised
    %because q maybe multiply percentage   
    
%�p��CDMN
	[ C  , D  , M  , N ]   = cdmn( i, q_v  , m, n, ultra_age );
	
	
%�p��Benefit
	[TGP , GP_m]       = tgp      (GP_All,i, m, n, ultra_age, Scenario);   %��ú�O�I�O�[�p�Q��
	TGP                = BP .* TGP;
	Coupon             = BP .* coupon   ( m, n, ultra_age, SA);            %�M�O��~�׬������ͦs���B
    MB                 = BP .* zeros    (size(Time_M));                    %�M����    �������ͦs���B  
    AMT                = BP .* amt      ( m, n, ultra_age, SA);            %��~�׫O�I���B
    GP_min_Coupon      = BP .* (cumsum(GP_m)*1.03 - cumsum(Coupon));       %��ú�O�O*1.03�����w�����Coupon 
	
%�ŧiPV
	PV                 = zeros    ( size(Time_M) );                  %����ŧiPV���Ŷ��A�t�@�譱�O�]���^����j����l��   
    PV_mid             = zeros    ( size(Time_M) );                  %����ŧiPV_mid���Ŷ��A�t�@�譱�O�]���^����j����l��   
%�Ĥ@��DB
	DB                 = ( (Time_M<16).*TGP ) + ( (Time_M>=16 & Time_M<ultra_age).*max( max(GP_min_Coupon,AMT) , PV_mid ) );

%PVFB�BPVFC
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
   while any(abs(NP_Temp - Revised.NP) >=10^(-10))==1
       
	   NP_Temp = Revised.NP;
       DB                 = ( (Time_M<16).*TGP ) + ( (Time_M>=16 & Time_M<ultra_age).*max( max(GP_min_Coupon,AMT) , PV_mid ) );
       %PVFB�BPVFC
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
    count_loop
	toc
%   
% %Loading
    Loading = 1-( GP_m(1,:) ./ Revised.NP_m );
%     
%     
% 
% ex('pvfb',PVFB)
% ex('pvfc',PVFC)
% ex('npl',NP_L)
% ex('nps',NP_S)