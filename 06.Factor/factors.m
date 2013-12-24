function [ CUR,CSV,YUR,SBN,DDR ] = factors (Result)
% [CUR ] = factors(Result)

[ row , column ] = size(Result);
	for j = 1:column
		for i = 1:row,
			%Loading Data
			n   		  = Result{i,j}.Filing.Par.n;
			m   		  = Result{i,j}.Filing.Par.m;
			sex      	  = Result{i,j}.Filing.Par.sex;
			ultra_age  	  = Result{i,j}.Filing.Par.ultra_age;
			buy_age_max   = Result{i,j}.Filing.Par.buy_age_max;
			NP            = Result{i,j}.Filing.GNL.NP;
			Filing_P1     = Result{i,j}.Filing.Revised.P1;
			Filing_P2     = Result{i,j}.Filing.Revised.P2;
			Valuation_P1  = Result{i,j}.Valuation.Revised.P1;
			Valuation_P2  = Result{i,j}.Valuation.Revised.P2;


			%SA            = Result{i,j}.Filing.Par.SA;
			
			CUR_temp = Result{i,j}.Filing.PV.PV;
			CSV_temp = Result{i,j}.Filing.CV.CV;
			YUR_temp = Result{i,j}.Valuation.TV.TV;
			SBN_temp = Result{i,j}.Filing.Benefit.Coupon + Result{i,j}.Filing.Benefit.MB;
			DDR_temp = Result{i,j}.Filing.DR.DR;


			[ Title ] = factors_title (m,n,sex,buy_age_max);
				%NP P1 P2
					Title_NP           = zeros(buy_age_max+1,1);
					Title_P1           = zeros(buy_age_max+1,1);
					Title_P2           = zeros(buy_age_max+1,1);
					Title_NP_Zone      = [ Title_NP, Title_P1, Title_P2 ];				

				%CUR_NP P1 P2
					Title_CUR_NP           = NP(1,1:buy_age_max+1)';
					Title_CUR_P1           = Filing_P1(1,1:buy_age_max+1)';
					Title_CUR_P2           = Filing_P2(1,1:buy_age_max+1)';
					Title_CUR_NP_Zone      = [ Title_CUR_NP, Title_CUR_P1, Title_CUR_P2 ];		
				
				%YUR_NP P1 P2
					Title_YUR_NP           = NP(1,1:buy_age_max+1)';
					Title_YUR_P1           = Valuation_P1(1,1:buy_age_max+1)';
					Title_YUR_P2           = Valuation_P2(1,1:buy_age_max+1)';
					Title_YUR_NP_Zone      = [ Title_YUR_NP, Title_YUR_P1, Title_YUR_P2 ];							
						
			CUR_temp = get_year_factor(CUR_temp, m, n, ultra_age)';
			CUR{j,i} = [ Title , 10000*Title_CUR_NP_Zone , 10000*CUR_temp(1:buy_age_max+1,2:end) ];

			CSV_temp = get_year_factor(CSV_temp, m, n, ultra_age)';
			CSV{j,i} = [ Title , Title_NP_Zone , 10000*CSV_temp(1:buy_age_max+1,2:end) ];

			YUR_temp = get_year_factor(YUR_temp, m, n, ultra_age)';
			YUR{j,i} = [ Title , 10000*Title_YUR_NP_Zone , 10000*YUR_temp(1:buy_age_max+1,2:end) ];

			SBN_temp = get_year_factor(SBN_temp, m, n, ultra_age)';
			SBN{j,i} = [ Title , Title_NP_Zone , 10000*SBN_temp(1:buy_age_max+1,2:end) ];

			DDR_temp = get_year_factor(DDR_temp, m, n, ultra_age)';
			DDR{j,i} = [ Title , Title_NP_Zone , 10000*DDR_temp(1:buy_age_max+1,1:end-1) ]; %DR0 must be considered

		end
	end
CUR =reshape(CUR , prod(size(Result)) , 1 );
CSV =reshape(CSV , prod(size(Result)) , 1 );
YUR =reshape(YUR , prod(size(Result)) , 1 );
SBN =reshape(SBN , prod(size(Result)) , 1 );
DDR =reshape(DDR , prod(size(Result)) , 1 );

csvwrite('CUR.csv', cell2mat(CUR));
csvwrite('CSV.csv', cell2mat(CSV));
csvwrite('YUR.csv', cell2mat(YUR));
csvwrite('SBN.csv', cell2mat(SBN));
csvwrite('DDR.csv', cell2mat(DDR));

end
