classdef time1
   
    
    properties
    M = [];  
    xx= [];
    TT=[];
    v = [];
    vh=[];
    
    end


    methods
        function obj = time1(m,n,x_max,final_age)
            A = 0:n-1;
            B = ones(1,m);
            C = B'*A;
            D = reshape(C,m*n,1);
            F = n:final_age;
            Timeline = [D' F]';

            x = 0:x_max;
            [obj.xx obj.TT] = meshgrid(x,Timeline);

            obj.v = cumsum((obj.TT<n)/m+(obj.TT>=n));
            BB = obj.v-(obj.TT<n)/(2*m);
   
            obj.M = xx+TT;
            obj.vh = BB -(TT>=n)/2;

        end
    end
end