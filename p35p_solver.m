function [solution_num, f_sol, R_sol, T_sol] = p35p_solver(X, x, y, e)
    R = init_R();
    F = init_F(x, y, X, R); %4x3x6
    G4 = equations_for_groebner(F); %4x28
    G20 = mult_for_groebner(G4); %20x45
    A = [G20(:, 1:2), G20(:, 10:13), G20(:, 18:22), G20(:, 25:28), G20(:, 31:35)];
    B = G20(:, 36:45);
    C = A\B;
    M = make_mult_matrix(C);

    [W,D] = eig(M');

    solution_num = 0;
    f_sol = zeros(1, 0);
    coder.varsize('f_sol', [1 10], [0 1]);
    R_sol = zeros(3, 3, 0);
    coder.varsize('R_sol', [3 3 10], [0 0 1]);
    T_sol = zeros(3, 0);
    coder.varsize('T_sol', [3 10], [0 1]);
    
    for i = 1 : 10
        qx = D(i, i);
        qy = W(9, i) / W(10, i);

        if abs(imag(qx)) > e || abs(imag(qy)) > e
            continue;
        else
            qx = real(qx);
            qy = real(qy);
        end
        [fc_set, fs_set, f_num] = find_f(F, qx, qy, e);
        
        for j = 1 : f_num
            fc = fc_set(j);
            fs = fs_set(j);
            
            s = 1/(1 + qx^2 + qy^2);
            R_xy = [1 - 2*s*qy^2, 2*s*qx*qy,     2*s*qy; 
                      2*s*qx*qy,    1 - 2*s*qx^2, -2*s*qx;
                     -2*s*qy,       2*s*qx,        1 - 2*s*(qx^2 + qy^2)];
                 
            %li = find_lamda(R, fc, fs, Xi, Xj, xi, xj) -- signature
            lambda1 = find_lamda(R_xy, fc, fs, X(:, 1), X(:, 2), x(1), x(2));
            %T = find_translation(R, fc, fs, li, Xi, xi, yi)
            T = find_translation(R_xy, fc, fs, lambda1, X(:, 1), x(1), y(1));
            
            f = hypot(fs, fc);
            K = [fc, -fs, 0;
                 fs,  fc, 0;
                   0,  0, 1];
            P = [K*R_xy, T];

            p4 = P*[X(:, 4); 1];
            y4 = p4(2)/p4(3);
            
            if abs(y4 - y(4)) < 0.01*f
                solution_num = solution_num + 1;
                R_z = [fc/f, -fs/f, 0;
                       fs/f,  fc/f, 0;
                       0,        0, 1];
                R_curr = R_z*R_xy;
                f_sol = [f_sol, f];
                if solution_num == 1
                    R_sol = R_curr;
                else
                    R_sol = cat(3, R_sol, R_curr);
                end
                T_sol = [T_sol, T];
            end
        end
    end
end