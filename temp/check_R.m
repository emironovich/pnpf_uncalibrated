[X, x, y, f_gen, R_gen, C_gen] = generate_data();
start = tic;
[solution_num, f_sol, R_sol, T_sol] = solve_P4Pf(X, x, y, 1e-04);
dt = toc(start);

min_diff = inf;
diff_R = inf;
diff_C = inf;
for i = 1 : solution_num
    f = f_sol(i);
    T = T_sol(:, i);
    R = squeeze(R_sol(:,:,i));
    C = (-diag([f, f, 1])*R)\T;
    
    [T, A, b] = find_T(X, x, y, R_gen, 1/f_gen);
    C = (-diag([f, f, 1])*R)\T;
    
    
    diff = abs(f - f_gen);

    diffR = norm(R-R_gen)/3;
    diffC = norm(C - C_gen)/norm(C_gen);

    if diff < min_diff
        min_diff = diff;    
         diff_R = diffR;
         diff_C = diffC;
    elseif diff == min_diff && diffR < diff_R
           diff_R = diffR;
           diff_C = diffC;
    end
end
min_diff
diff_R
diff_C