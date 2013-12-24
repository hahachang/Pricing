function [ C ] = parameter2cell( Parameter )
% [ C ] = parameter2cell( Parameter )
% 將最基本的輸入參數轉成矩陣型式
P = Parameter;

PP.n             = ( repmat (P.n             ,length(P.m),length(P.sex)) );
PP.m     	     = ( repmat (P.m'            ,1          ,length(P.n)*length(P.sex)) );
PP.buy_age_max   = ( repmat (P.buy_age_max   ,length(P.m),length(P.sex)) );
PP.buy_age_min   = ( repmat (P.buy_age_min   ,length(P.m),length(P.sex)) );
PP.i             = ( repmat (P.i             ,length(P.m),length(P.sex)));
PP.i_v           = ( repmat (P.i_v           ,length(P.m),length(P.sex)));
PP.gp_scenario   = ( repmat (P.gp_scenario   ,length(P.m),1) );
PP.bp_max        = ( repmat (P.bp_max        ,length(P.m),length(P.n)*length(P.sex)) );
PP.sex           = ( reshape(repmat(P.sex    ,length(P.m)*length(P.n),1) , length(P.m),length(P.n)*length(P.sex) ) );
PP.SA            = ( repmat (P.SA            ,length(P.m),length(P.n)*length(P.sex)));
PP.tso_filing    = ( repmat (P.tso_filing    ,length(P.m),length(P.n)*length(P.sex)));
PP.tso_valuation = ( repmat (P.tso_valuation ,length(P.m),length(P.n)*length(P.sex)));


C = structfun(@(x) num2cell(x),PP,'UniformOutput',false);



end

