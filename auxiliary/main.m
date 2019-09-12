%known data
% x = rand(1, 4); %image points
% y = rand(1, 4);
% X = rand(3, 4); %space points

e = 1e-8; %acccuracy
%[X, x, y] = generate_data();
[X, x, y, genfc, genfs, genqx, genqy, genT, genP] = generate_data_with_new_parametrization();

R = init_R();
F = init_F(x, y, X, R); %4x3x6
G4 = equations_for_groebner(F); %4x28
G20 = mult_for_groebner(G4); %20x45
% newG20 = [G20(:, 1:2), G20(:, 10:13), G20(:, 18:22), G20(:, 25:28), G20(:, 31:end)];
% 
% %G20
% G20_afterGJ = rref(G20);
% newG20_afterGJ = rref(newG20);
% spy(G20_afterGJ);

%place for some groebner magic
A = [G20(:, 1:2), G20(:, 10:13), G20(:, 18:22), G20(:, 25:28), G20(:, 31:35)];
B = G20(:, 36:45);

C = A\B;
M = make_mult_matrix(C);

[~, D ,W] = eig(M);

for i = 1 : 10
    
    qx = D(i, i);
    qy = W(9, i) / W(10, i);
    
    if abs(imag(qx)) > e || abs(imag(qy)) > e
        continue;
    else
        qx = real(qx);
        qy = real(qy);
    end
    [fc, fs, n] = find_f(F, qx, qy, e);

    %need to deal with different number of solutions
     %R_eval = quat_to_rot([1, qx, qy, 0]);
     
     s = 1/(1 + qx^2 + qy^2);
     R_eval = [1 - 2*s*qy^2, 2*s*qx*qy, 2*s*qy; 
        2*s*qx*qy, 1 - 2*s*qx^2, -2*s*qx;
        -2*s*qy, 2*s*qx, 1 - 2*s*(qx^2 + qy^2)];
    
%     R_eval = [1 + qx^2 - qy^2, 2*qx*qy, 2*qy;
%         2*qx*qy, qy^2 - qx^2 + 1, -2*qx;
%         -2*qy, 2*qx, 1 - qx^2 - qy^2];
    
    %li = find_lamda(R, fc, fs, Xi, Xj, xi, xj) -- signature
    lambda1 = find_lamda(R_eval, fc, fs, X(:, 1), X(:, 2), x(1), x(2));
    %T = find_translation(R, fc, fs, li, Xi, xi, yi)
    T = find_translation(R_eval, fc, fs, lambda1, X(:, 1), x(1), y(1));
    f = sqrt(fc^2 + fs^2);
    K = [fc, -fs, 0;
         fs,  fc, 0;
           0,  0, 1];
    P = [K*R_eval, T];
    
    p4 = P*[X(:, 4); 1];
    y4 = p4(2)/p4(3);
    
    disp(abs(y4 - y(4)));
    
    if abs(qx-genqx) < e && abs(qy - genqy) < e
        disp("qx    qy:");
        disp([qx, qy]);
        disp([genqx, genqy]);

        disp("fc    fs:");
        disp([fc, fs]);
        disp([genfc, genfs]);

        disp("T:");
        disp(T');
        disp(genT');
    end
end




