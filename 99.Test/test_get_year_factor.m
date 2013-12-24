
n = 6;
m = 4;
ultra_age = 111;
[Filing] = t_7i0(n,m,'m',1,75,2.25/100);

Input = Filing.Benefit.PV;

[ Factor_y,Factor_y_m,Factor_pre,Factor_pos] = get_year_factor(Input, m, n, ultra_age);

