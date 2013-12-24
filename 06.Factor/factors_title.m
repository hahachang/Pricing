function [ Title ] = factors_title (m,n,sex,buy_age_max)


	%Title_PlanName
		Title_PlanName     = n .* ones(buy_age_max+1,1);
	%Title Non-effect 
		Title_Print        = 1 .* ones(buy_age_max+1,1);
	%Title the kind of Factors
		Title_Factor_Names =  zeros(buy_age_max+1,1);
	%Title Sex
		if sex == 'm'
			Title_sex      = 1 .* ones(buy_age_max+1,1);
		else
			Title_sex      = 2 .* ones(buy_age_max+1,1);
		end
	%Title Buy_Age
		Title_Buy_Age      = ( 0 : buy_age_max )';
	%Title Blank
		Title_Blank        = zeros(buy_age_max+1,1);
	%Title m
		Title_m            = 12/m .* ones(buy_age_max+1,1);


	%Factor
		Title = [ Title_PlanName      , ...
				  Title_Print	      , ...
				  Title_Factor_Names  , ...
				  Title_sex           , ...
				  Title_Buy_Age       , ...
				  Title_Blank         , ...
				  Title_Blank         , ...
				  Title_m             , ...
				  Title_Blank         , ... 
				];







endfunction
