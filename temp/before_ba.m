path = 'scripts/bench/courtyard/bin/before_ba_';
fin_p35p = fopen([path 'p35p.txt'], 'r');
fin_p4p = fopen([path 'p4p.txt'], 'r');
fin_real = fopen([path 'real.txt'], 'r');

in_p35p = fscanf(fin_p35p, "%f");
in_p4p = fscanf(fin_p4p, "%f");
in_real = fscanf(fin_real, "%f");

[Rs_p35p, ts_p35p] = get_Rt(in_p35p);
[Rs_p4p, ts_p4p] = get_Rt(in_p4p);
[Rs_real, ts_real] = get_Rt(in_real);

function [Rs, ts] = get_Rt(in_pnp)
    n = length(in_pnp); 
    Rs = zeros(3, 3, n);
    ts = zeros(3, n);
    ind = 1;
    for i = 1:7:n
        Rs(:, :, ind) = quat2rotmat(in_pnp(i:(i+3)));
        ts(:, ind) = in_pnp(i+4:i+6)';
        ind = ind + 1;
    end
end