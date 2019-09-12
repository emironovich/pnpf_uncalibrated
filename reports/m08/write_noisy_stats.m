function write_noisy_stats(N, eps, solver, filename)
    stats = zeros(11, N);
    zero_solutions = zeros(11, 1);

    for d = 0:0.5:5
        valid = false(N, 1);
        tic
        for ind = 1:N
            [X, x, y, f_gen] = generate_data(d);
            start = tic;
            [solution_num, f_sol] = solver(X, x, y, eps);
            dt = toc(start);

            min_diff = inf;
            for i = 1 : solution_num
                f = f_sol(i);
                diff = abs(f - f_gen);

                if diff < min_diff
                    min_diff = diff;
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
        stats = stats(:, valid);
        %stats_median(:, 2*d s+ 1) = [median(stats, 2); zero_solutions/N]; 
    end
    write_to_cvs(filename, stats', "")
end