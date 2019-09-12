% small script for auto-inference of var sizes and testing of generated
% code
N = 100;

stats = zeros(4, N);
valid = false(N, 1);

tic
for ind = 1 : N
    [X, x, y, f_gen, R_gen, C_gen, P] = generate_data();
    e = 1e-6;
    start = tic;
    [solution_num, f_sol, R_sol, T_sol] = p35p_solver(X, x, y, e);
    dt = toc(start);
    
    min_diff = inf;
    diff_R = inf;
    diff_C = inf;
    for i = 1 : solution_num
        f = f_sol(i);
        T = T_sol(:, i);
        R = squeeze(R_sol(:,:,i));
        C = (-diag([f, f, 1])*R)\T;
        
        diff = abs(f - f_gen);
        
        diffR = norm(R-R_gen)/3;
        diffC = norm(C - C_gen)/norm(C_gen);
        
        if diff < min_diff
            min_diff = diff;    
             diff_R = diffR;
             diff_C = diffC;
        elseif diff == min_diff && diffR < diffR
               diff_R = diffR;
               diff_C = diffC;
        end
    end
    
    
    if solution_num ~= 0
        stats(:, ind) = [min_diff / f_gen; diff_R; diff_C; dt];
        valid(ind) = true;
    end
end
toc

zero_solutions = numel(find(~valid));

stats = stats(:, valid);
