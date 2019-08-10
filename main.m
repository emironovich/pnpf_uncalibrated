%known data
% x = rand(1, 4); %image points
% y = rand(1, 4);
% X = rand(3, 4); %space points

e = 1e-8; %acccuracy
[X, x, y] = generate_data();

R = init_R();
F = init_F(x, y, X, R); %4x3x6
G4 = equations_for_groebner(F);
G20 = mult_for_groebner(G4);

%G20
G20_afterGJ = rref(G20);
%spy(G20_afterGJ);

%place for some groebner magic
qx = rand();
qy = rand();


[fc, fs, n] = find_f(F, qx, qy, e);

%need to deal with different number of solutions

R_eval = [1 + qx^2 - qy^2, 2*qx*qy, 2*qy;
    2*qx*qy, qy^2 - qx^2 + 1, -2*qx;
    -2*qy, 2*qx, 1 - qx^2 - qy^2];
%li = find_lamda(R, fc, fs, Xi, Xj, xi, xj) -- signature
%todo: find out if indecies of X and x matter for this (or may be I need y)
lambda1 = find_lamda(R_eval, fc, fs, X(:, 1), X(:, 2), x(1), x(2));
%T = find_translation(R, fc, fs, li, Xi, xi, yi)
T = find_translation(R_eval, fc, fs, lambda1, X(:, 1), x(1), y(1));

f = sqrt(fc^2 + fs^2);
K = [fc, -fs, 0;
     fs,  fc, 0;
       0,  0, 1];
P = [K*R_eval, T];





