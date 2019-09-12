% N = 10000;
% e = 1e-4;
stats_p4p = zeros(5, N);

%p4p = @(X, u, v, e)solve_P4Pf(X, u, v, e);
% uncomment for MEX-based solver
%p4p = @(X, u, v, e)solve_P4Pf_mex(X, u, v, e);

tic
parfor ind = 1 : N
    [X, u, v, f_gen, R_gen, C_gen, P] = generate_data();
    T_gen = -R_gen*C_gen;
    start = tic;
    [num, fs, Rs, Ts] = p4p(X, u, v, e);
    dt = toc(start);
    
    min_diff = inf;
    T = zeros(3, 1);
    R = zeros(3);
    f = 0;
    for i = 1 : num
        if abs(fs(i) - f_gen) < min_diff
            min_diff = abs(fs(i) - f_gen);
            f = fs(i);
            T = Ts(:, i);
            R = Rs(:, 3*i - 2: 3*i);
        end
    end
    d = det(R);
    mult = sign(d)*abs(d)^(1/3);
    R = R / mult;
    T = T / mult;
    
    diff_R = norm(R-R_gen)/3;
    diff_T = norm(T - T_gen)/norm(T_gen);
    
    stats_p4p(:, ind) = [min_diff / f_gen; diff_R; diff_T; dt; num];
%     R
%     min_R
%     T
%     min_T
end
toc

% filename = 'P4Pf_focus_stats.csv';
% f=fopen(filename, 'wt');
% fprintf(f, 'df\n');
% fclose(f);
% 
% dlmwrite(filename, stats, '-append');