kol = 1000;
%max_diff = -1;
sum = 0;
zero_solutions = 0;

f_diffs = zeros(1, kol);
% times = zeros(1, kol);

for ind = 1 : kol
    [X, x, y, R_gen, C_gen, f_gen, P] = generate_data();
    e = 1e-6;
    [solution_num, f_sol, R_sol, T_sol] = p35p_solver(X, x, y, e);
%     p35p_handle = @() p35p_solver(X, x, y, e);
%     times(ind) = timeit(p35p_handle);
    min_diff = 10000000000000000;
    for i = 1 : solution_num
        f = f_sol(i);
        T = T_sol(:, i);
        R = R_sol(:, 3*solution_num - 2 : 3*solution_num);
        C = (-diag([f, f, 1])*R)\T;
        diff = abs(f - f_gen);
        if diff < min_diff
            min_diff = diff;
        end
    end
    
    
%     if min_diff > e
%         disp(min_diff);
%         disp(X); disp([x, y]); disp(R_gen); disp(C_gen); disp(f_gen); disp(P);
%     end
    if solution_num ~= 0
        f_diffs(ind - zero_solutions) = diff / f_gen;
    else
        zero_solutions = zero_solutions + 1;
    end
%     if min_diff > max_diff  && solution_num ~= 0
%         max_diff = min_diff;
%     end
end

% disp(max_diff);
% disp(sum / kol);
% disp(zero_solutions);

% histogram(log10(f_diffs(1:end-zero_solutions)));