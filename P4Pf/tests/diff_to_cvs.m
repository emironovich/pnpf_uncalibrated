N = 10000;
e = 1e-4;
stats = zeros(N, 1);

for ind = 1 : N
    [X, u, v, R, C, f, P] = generate_data();
    T = -R*C;
    [num, fs, Rs, Ts] = solve_P4Pf(X, u, v, e);
    min_diff = inf;
    min_T = zeros(3, 1);
    min_R = zeros(3);
    min_f = 0;
    for i = 1 : num
        if abs(fs(i) - f) < min_diff
            min_diff = abs(fs(i) - f);
            min_f = fs(i);
            min_T = Ts(:, i);
            min_R = Rs(:, 3*i - 2: 3*i);
        end
    end
    stats(ind) = min_diff/f;
    d = det(min_R);
    mult = sign(d)*abs(d)^(1/3);
    min_R = min_R / mult;
    min_T = min_T / mult;
%     R
%     min_R
%     T
%     min_T
end

filename = 'P4Pf_focus_stats.csv';
f=fopen(filename, 'wt');
fprintf(f, 'df\n');
fclose(f);

dlmwrite(filename, stats, '-append');