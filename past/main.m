tic
i         =  [2.25, 2.25, 2.25, 2.25]/100; 
i_v       =  [2.25, 2.25, 2.25, 2.25]/100; 
n         =  [6, 10, 15, 20];
m         =  [1, 2, 4, 12];
sex       =  ['m','f'];
scenario = 1:length(n)*length(sex);
buy_age_max = [70, 65, 60, 55];
bp_max      = 90;

n_vec           = ( repmat (n,length(m),length(sex)) );
m_vec     		= ( repmat (m',1,length(n)*length(sex)) );
sex_vec         = ( reshape( repmat(sex,length(m)*length(n),1) , length(m),length(n)*length(sex) ) );
buy_age_max_vec = ( repmat (buy_age_max,length(m),length(sex)) );
scenario_vec    = ( repmat (scenario,length(m),1) );
i_vec           = ( repmat (i       ,length(m),length(sex)));

Parameter.n               = n_vec;
Parameter.m               = m_vec;
Parameter.sex             = sex_vec;
Parameter.buy_age_max     = buy_age_max_vec;
Parameter.scenario        = scenario_vec;
Parameter.i               = i_vec;
% %pp = {n_vec,m_vec,sex_vec,buy_age_max_vec,scenario_vec,i_vec};


n_c           = num2cell( repmat (n,length(m),length(sex)) );
m_c           = num2cell( repmat (m',1,length(n)*length(sex)) );
sex_c         = num2cell( reshape( repmat(sex,length(m)*length(n),1) , length(m),length(n)*length(sex) ) );
buy_age_max_c = num2cell( repmat (buy_age_max,length(m),length(sex)) );
scenario_c    = num2cell( repmat (scenario,length(m),1) );
i_c           = num2cell( repmat (i       ,length(m),length(sex)));

Result = cellfun(@(n,m,sex,scenario,buy_age_max,i) q116(n,m,sex,scenario,buy_age_max,i) , ...
                   n_c,m_c,sex_c,scenario_c,buy_age_max_c,i_c,'UniformOutput',false);
toc