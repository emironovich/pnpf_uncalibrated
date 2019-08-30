N = 10000;
e = 1e-4;
stats = zeros(N, 1);

for ind = 1 : N
    [X, u, v, R, C, f, P] = generate_data();
    [num, fs] = solve_P4Pf(X, u, v, e);
    min_diff = inf;
    for i = 1 : num
        if abs(fs(i) - f) < min_diff
            min_diff = abs(fs(i) - f);
        end
    end
    stats(ind) = min_diff/f;
end

filename = 'P4Pf_focus_stats.csv';
f=fopen(filename, 'wt');
fprintf(f, 'df\n');
fclose(f);

dlmwrite(filename, stats, '-append');