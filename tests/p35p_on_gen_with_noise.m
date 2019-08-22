N = 10000;

stats_median = zeros(4, 11);

for d = 0:0.5:5
    stats = zeros(3, N);
    valid = false(N, 1);

    p35p = @(X,x,y,e)p35p_solver(X,x,y,e);
    %uncomment for MEX-based solver
    p35p = @(X,x,y,e)p35p_solver_mex(X,x,y,e);
    eps = 1e-6;
    % uncomment for single-precision evaluation
    eps = 1e-1;

    tic
    parfor ind = 1:N
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
            stats(:, ind) = [min_diff / f_gen; diff_R; diff_C];
            valid(ind) = true;    
        end
    end
    toc

    zero_solutions = numel(find(~valid));

    stats = stats(:, valid);
    stats_median(:, 2*d + 1) = [median(stats, 2); zero_solutions/N]; 
end

ff = figure('Name', 'Focal diff to deviation');
p = plot(0:0.5:5, stats_median(1, :), 'Marker', 'o', 'Color', 'r');

fr = figure('Name', 'Rotation diff to deviation');
plot(0:0.5:5, stats_median(2, :), 'Marker', 'o', 'Color', 'm');

fc = figure('Name', 'Center diff to deviation');
plot(0:0.5:5, stats_median(3, :), 'Marker', 'o', 'Color', 'b');

fz = figure('Name', 'Zero solution ration to deviation');
plot(0:0.5:5, stats_median(4, :), 'Marker', 'o', 'Color', 'k');