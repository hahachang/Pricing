function [ Revised ] = revised_fix (PVFB, PVFC, PVMB, i, q_vec, m, n, ultra_age,bp_max,GP_m,discount_max,gp_scenario)


		%Create Timeline
			[Time_M,Time_m,xx,TT,Time_v,Time_vh] = timeline(m, n, ultra_age);
			Matrix_Size = size(Time_M,1);

		%Create 1 year m period model of CDMN 
			[ C    , D    , M    , N   ]   = cdmn( i, q_vec  , m, n, ultra_age );

		%Create 1 year          model of CDMN 
			[ C_1  , D_1  , M_1  , N_1 ]   = cdmn( i, q_vec  , 1, n, ultra_age );
			
		%Create Revised spaces
		%================================================================    
			MM                    = zeros(1,Matrix_Size);   %Mx-Mx+u
			h                     = zeros(1,Matrix_Size);   %h 
			a_due_0_n             = zeros(1,Matrix_Size);   %:ax:n
			a_0_nm1               = zeros(1,Matrix_Size);   % ax:n-1
			a_due_0p1_nm1         = zeros(1,Matrix_Size);   %:ax+1:n-1
			a_due_0_1             = zeros(1,Matrix_Size);   %:ax:1
			NP_L_m                = zeros(1,Matrix_Size);   %NP_L(period)
			NP_L                  = zeros(1,Matrix_Size);   %NP_L(Year)
			Px_20                 = zeros(1,Matrix_Size);   %20Px(Year) 
			DeathCost_1           = zeros(1,Matrix_Size);   %1st Year of Death Cost
			NP_S_m                = zeros(1,Matrix_Size);   %NP_S(period)
			NP_S                  = zeros(1,Matrix_Size);   %NP_S(Year)
			NP_m                  = zeros(1,Matrix_Size);   %NP  (Period)
			NP                    = zeros(1,Matrix_Size);   %NP  (Year)
			NPvsh20Px             = zeros(1,Matrix_Size);   %NP-h*20Px
			P1_FPT                = zeros(1,Matrix_Size);   %P1_FPT  
			P2_FPT                = zeros(1,Matrix_Size);   %P2_FPT
			P1_20PL               = zeros(1,Matrix_Size);   %P1_20PL 
			P2_20PL               = zeros(1,Matrix_Size);   %P2_20PL 
			P1                    = zeros(1,Matrix_Size);   %P1
			P2                    = zeros(1,Matrix_Size);   %P2
		%================================================================    
			MM                    = M(1,:)- sum( M.*(Time_M == min(ultra_age,bp_max)) );
			h                     = PVFB(1,:)./MM;
			a_due_0_n             = ( N(1,:)     - N(n*m+1,:)     ) ./ D(1,:);
			a_0_nm1               = ( N(m*1+1,:) - N(n*m+1,:)     ) ./ D(1,:);
			a_due_0p1_nm1         = ( N(m*1+1,:) - N(n*m+1,:) ) ./ D(m+1,:);  
			a_due_0_1             = ( N(1,:)     - N(m*1+1,:)     ) ./ D(1,:);
			NP_L_m                = ( PVFB(1,:) + PVMB(1,:) ) ./ ( N(1,:) - N(n*m+1,:) );
			NP_L                  = m * NP_L_m;
			NP_S_m                = PVFC(1,:) ./ ( N(1,:) - N(n*m+1,:) );
			NP_S          		  = m * NP_S_m;
			NP_m         		  = NP_L_m + NP_S_m;
			NP                    = m * NP_m;        
			Px_20(1,1:size(M_1,1))= M_1(1,:) ./ ( N_1(1,:)-N_1(20+1,:) );                                    %Taiwan Insurance Company Special doing
			DeathCost_1           = PVFB(1,:) - PVFB(m+1,:) .* D(m+1,:);
			NPvsh20Px             = (NP_L_m.*a_due_0_1 - h .* Px_20);
			
			% P1_FPT                = m * ( DeathCost_1 ./ a_due_0_1)                                        ; %需先排除NP_S，因為這是死亡成本的修正制   
			% P2_FPT                = m * ( NP_L_m.*a_due_0_n - DeathCost_1 ) ./ a_0_nm1                     ; %需先排除NP_S，因為這是死亡成本的修正制  
			% P1_20PL               = m * ( NP_L_m - h.*Px_20./a_due_0_1  + DeathCost_1./a_due_0_1 )         ; %需先排除NP_S，因為這是死亡成本的修正制    
			% P2_20PL               = m * ( NP_L_m.*a_due_0_n - P1_20PL/m.*a_due_0_1 ) ./ a_0_nm1            ; %需先排除NP_S，因為這是死亡成本的修正制
			% P1                    = ( (NPvsh20Px>=0) .* P1_20PL + (~(NPvsh20Px>=0)).*P1_FPT ) + NP_S;                  
			% P2                    = ( (NPvsh20Px>=0) .* P2_20PL + (~(NPvsh20Px>=0)).*P2_FPT ) + NP_S;   

			%Loading "Percentage of dicounted GP" to fixed P1
			Fixed_P1_percentage   = fixed_p1(ismac()); 
			Fixed_P1_percentage   = overlap(Fixed_P1_percentage(:,gp_scenario)',zeros(1,Matrix_Size));	      %select and resized "Fixed_P1_percentage"	
			P1                    = m * ( GP_m(1,:)  .* (1-discount_max) .* (1-Fixed_P1_percentage ) );
			P2                    = m * ( (NP_m .* a_due_0_n - P1/m.*a_due_0_1) ./ a_0_nm1 );
			
		%================================================================
		%Create Revised Structure
			Revised.MM            = MM; 
			Revised.h             = h;
			Revised.a_due_0_n     = a_due_0_n; 
			Revised.a_0_nm1       = a_0_nm1;
			Revised.a_due_0p1_nm1 = a_due_0p1_nm1;
			Revised.a_due_0_1     = a_due_0_1;
			Revised.NP_L_m        = NP_L_m;
			Revised.NP_L          = NP_L;
			Revised.Px_20         = Px_20;
			Revised.DeathCost_1   = DeathCost_1;
			Revised.NP_S_m        = NP_S_m;
			Revised.NP_S          = NP_S;
			Revised.NP_m          = NP_m;
			Revised.NP            = NP;
			Revised.NPvsh20Px     = NPvsh20Px;
			Revised.P1_FPT        = P1_FPT; 
			Revised.P2_FPT        = P2_FPT;
			Revised.P1_20PL       = P1_20PL;
			Revised.P2_20PL       = P2_20PL;
			Revised.P1            = P1;
			Revised.P2            = P2;

			

end

