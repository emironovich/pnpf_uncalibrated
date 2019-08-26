N = 10000;

%stats_median = zeros(4, 11);
stats = zeros(11, N);
zero_solutions = zeros(11, 1);

for d = 0:0.5:5
    valid = false(N, 1);

    p35p = @(X,x,y,e)p35p_solver(X,x,y,e);
    %uncomment for MEX-based solver
    p35p = @(X,x,y,e)p35p_solver_mex(X,x,y,e);
    %uncomment for MEX-based solver in double-precision
    %do not forget to change the name of the output file
    %p35p = @(X,x,y,e)p35p_solver_double_mex(X,x,y,e);
    eps = 1e-6;
    % uncomment for single-precision evaluation
    eps = 1e-1;

    tic
    for ind = 1:N
        [X, x, y, R_gen, C_gen, f_gen, P] = generate_data(d);
        start = tic;
        [solution_num, f_sol, R_sol, T_sol] = p35p(X, x, y, eps);
        dt = toc(start);

        min_diff = inf;
        diff_R = inf;
        diff_C = inf;
        for i = 1 : solution_num
            f = f_sol(i);
            T = T_sol(:,i);
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
            stats(2*d+1, ind) = min_diff / f_gen;
            valid(ind) = true;
        else 
            stats(2*d+1, ind) = -1;
        end
      
    end
    toc

    zero_solutions(2*d+1) = numel(find(~valid));
    %stats_median(:, 2*d s+ 1) = [median(stats, 2); zero_solutions/N]; 
end

filename = 'noisy_stats_single_mex.csv';
%uncomment for MEX-based solver in double-precision
%filename = 'noisy_stats_double_mex.csv';

% f=fopen(filename, 'wt');
% fprintf(f, 'stdev0.0,stdev0.5,stdev1.0,stdev1.5,stdev2.0,stdev2.5,stdev3.0,stdev3.5,stdev4.0,stdev4.5,stdev5.0,N\n');
% fclose(f);

dlmwrite(filename, stats');