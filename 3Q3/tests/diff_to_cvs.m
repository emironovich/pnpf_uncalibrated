N = 10000;

stats = zeros(N, 1);

parfor ind = 1 : N
    [x, y, z, c] = make_system();
    e = 1e-4;
    [n, xs, ys, zs] = solve_3Q3(c, e);
    
    min_diff = inf;
    for i = 1 : n
        if norm(([xs(i), ys(i), zs(i)] - [x, y, z])) < min_diff
            min_diff = norm(([xs(i), ys(i), zs(i)] - [x, y, z]));
        end
    end
    stats(ind) = min_diff / norm([x, y, z]);
end

filename = '3Q3_stats.csv';
f=fopen(filename, 'wt');
fprintf(f, 'dx\n');
fclose(f);

dlmwrite(filename, stats, '-append');