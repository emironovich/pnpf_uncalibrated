path = 'scripts/bench/courtyard/bin/loransac_inliers_num_';
fin_p35p = fopen([path 'p35p.txt'], 'r');
fin_p4p = fopen([path 'p4p.txt'], 'r');
fin_real = fopen([path 'real.txt'], 'r');

in_p35p = fscanf(fin_p35p, "%d %d", [2, Inf]);
in_p4p = fscanf(fin_p4p, "%d %d", [2, Inf]);
in_real = fscanf(fin_real, "%d %d", [2, Inf]);

mean(in_p35p(1, :) ./ in_p35p(2, :))
mean(in_p4p(1, :) ./ in_p4p(2, :))
mean(in_real(1, :) ./ in_real(2, :))