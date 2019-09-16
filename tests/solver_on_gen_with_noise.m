%function that prints focus error on syn. data with noise
%of solver with 'solver_handle' into csv_filename 

function stats = solver_on_gen_with_noise(N, eps, solver_handle, csv_filename)
    stats = zeros(N, 11);

    for d = 0:0.5:5
        curr_stats = zeros(N, 1);

%         p35p = @(X,x,y,e)p35p_solver(X,x,y,e);
%         %uncomment for MEX-based solver
%         p35p = @(X,x,y,e)p35p_solver_mex(X,x,y,e);
%         eps = 1e-6;
%         % uncomment for single-precision evaluation
%         eps = 1e-1;

        tic
        parfor ind = 1:N
            [X, x, y, f_gen] = generate_data(d);
            %start = tic;
            [solution_num, f_sol] = solver_handle(X, x, y, eps);
            %dt = toc(start);

            min_diff = inf;
%             diff_R = inf;
%             diff_C = inf;
            for i = 1 : solution_num
                f = f_sol(i);
%                 T = T_sol(:,i);
%                 R = squeeze(R_sol(:,:,i));
%                 C = (-diag([f, f, 1])*R)\T;

                diff = abs(f - f_gen);

%                 diffR = norm(R-R_gen)/3;
%                 diffC = norm(C - C_gen)/norm(C_gen);

                if diff < min_diff
                    min_diff = diff;    
%                      diff_R = diffR;
%                      diff_C = diffC;
%                 elseif diff == min_diff && diffR < diffR
%                        diff_R = diffR;
%                        diff_C = diffC;
                end
            end

            if solution_num ~= 0
%                 stats(:, ind) = [min_diff / f_gen; diff_R; diff_C];
                curr_stats(ind) = min_diff / f_gen;  
            else
                curr_stats(ind) = -1;  
            end
        end
        toc
        stats(:, 2*d + 1) = curr_stats;
    end
    headers = 'std0.0,std0.5,std1.0,std1.5,std2.0,std2.5,std3.0,std3.5,std4.0,std4.5,std5.0';
    write_to_cvs(csv_filename, stats, headers);
end