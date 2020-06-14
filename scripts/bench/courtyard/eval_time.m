path = 'scripts/bench/courtyard/time/time_';
fin_p35p = fopen([path 'p35p.txt'], 'r');
%fin_p4p = fopen([path 'p4p.txt'], 'r');
fin_real = fopen([path 'real.txt'], 'r');

in_p35p = fscanf(fin_p35p, "%f");
%in_p4p = fscanf(fin_p4p, "%f");
in_real = fscanf(fin_real, "%f");

mean(in_p35p*1e-6)
mean(in_real*1e-6)