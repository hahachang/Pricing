
%tic
i         =  [2.25, 2,25, 2,25, 2,25]/100; 
i_v       =  [2.25, 2,25, 2,25, 2,25]/100; 
n         =  [6, 10, 15, 20];
m         =  [1, 2];
sex       =  ['m'];
scenario = 1:length(n)*length(sex);
buy_age_max = [70, 65, 60, 55];
bp_max      = 90;

n_vec           = ( repmat (n,length(m),length(sex)) )
m_vec     		= ( repmat (m',1,length(n)*length(sex)) )
sex_vec         = ( reshape( repmat(sex,length(m)*length(n),1) , length(m),length(n)*length(sex) ) )
buy_age_max_vec = ( repmat (buy_age_max,length(m),length(sex)) )
scenario_vec    = ( repmat (scenario,length(m),1) )



n_vec           = num2cell( repmat (n,length(m),length(sex)) );
m_vec     		= num2cell( repmat (m',1,length(n)*length(sex)) );
sex_vec         = num2cell( reshape( repmat(sex,length(m)*length(n),1) , length(m),length(n)*length(sex) ) );
buy_age_max_vec = num2cell( repmat (buy_age_max,length(m),length(sex)) );
scenario_vec    = num2cell( repmat (scenario,length(m),1) );


Result = cellfun(@(n,m,sex,scenario,buy_age_max) q116(n,m,sex,scenario,buy_age_max) , ...
                   n_vec,m_vec,sex_vec,scenario_vec,buy_age_max_vec,'UniformOutput',false);

%toc
