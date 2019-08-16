kol = 1000;
max_diff = -1;

for ind = 1 : kol
    [X, x, y, R_gen, C_gen, f_gen, P] = generate_data();
    e = 1e-6;
    [solution_num, f_sol, R_sol, T_sol] = p35p_solver(X, x, y, e);
    min_diff = 10000000000000000;
    for i = 1 : solution_num
        f = f_sol(i);
        T = T_sol(:, i);
        R = R_sol(:, 3*solution_num - 2 : 3*solution_num);
        C = (-diag([f, f, 1])*R)\T;
        diff = norm([abs(f - f_gen), max(abs(C - C_gen)), max(max(abs(R - R_gen)))]);
        if diff < min_diff
            min_diff = diff;
        end
    end
    if min_diff > max_diff
        max_diff = min_diff;
    end
end

disp(max_diff);