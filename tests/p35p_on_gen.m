% N = 10000;

stats_p35p = zeros(5, N);
valid = false(N, 1);

% p35p = @(X,x,y,e)p35p_solver(X,x,y,e);
% % uncomment for MEX-based solver
% p35p = @(X,x,y,e)p35p_solver_mex(X,x,y,e);
% eps = 1e-6;
% uncomment for single-precision evaluation
%eps = 1e-1;

tic
parfor ind = 1:N
    [X, x, y, R_gen, C_gen, f_gen, P] = generate_data();
    start = tic;
    [solution_num, f_sol, R_sol, T_sol] = p35p(X, x, y, eps);
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
        stats_p35p(:, ind) = [min_diff / f_gen; diff_R; diff_C; dt; solution_num];
        valid(ind) = true;
    end
end
toc

zero_solutions = numel(find(~valid));

stats_p35p = stats_p35p(:, valid);
filename = 'stats_double_mex.csv';
f=fopen(filename, 'wt');
fprintf(f, 'dF,dR,dC,dt,N\n');
fclose(f);
dlmwrite(filename, stats_p35p', '-append');