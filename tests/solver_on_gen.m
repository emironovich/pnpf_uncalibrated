%function that prints df,dR,dC,dt(time),N(sol.num.)on noise-free syn. data
%of solver with 'solver_handle' into csv_filename
%solver_type is either 'p3.5p' or 'p4p'

function stats = solver_on_gen(N, eps, solver_handle, solver_type, csv_filename)
    stats = zeros(5, N);
    valid = false(N, 1);

    % p35p = @(X,x,y,e)p35p_solver(X,x,y,e);
    % % uncomment for MEX-based solver
    % p35p = @(X,x,y,e)p35p_solver_mex(X,x,y,e);
    % eps = 1e-6;
    % uncomment for single-precision evaluation
    %eps = 1e-1;

    tic
    for ind = 1:N
        [X, x, y, f_gen, R_gen, C_gen] = generate_data();
        start = tic;
        [solution_num, f_sol, R_sol, T_sol] = solver_handle(X, x, y, eps);
        dt = toc(start);

        min_diff = inf;
        diff_R = inf;
        diff_C = inf;
        for i = 1 : solution_num
            f = f_sol(i);
            T = T_sol(:, i);
            R = squeeze(R_sol(:,:,i));
            if strcmp(solver_type, 'p3.5p')
                C = (-diag([f, f, 1])*R)\T;
            elseif strcmp(solver_type, 'p4p')
                C = -R\T;
            else
                error('Wrong solver_type. Must be "p3.5p" or "p4p"');
            end

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


        if solution_num ~= 0
            stats(:, ind) = [min_diff / f_gen; diff_R; diff_C; dt; solution_num];
            valid(ind) = true;
        end
    end
    toc

    %zero_solutions = numel(find(~valid));
    
    stats = stats(:, valid);
    %filename = 'stats_double_mex.csv';
    write_to_cvs(csv_filename, stats', 'dF,dR,dC,dt,N')
end