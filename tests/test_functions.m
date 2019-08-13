%Tests
[X, x, y, fc, fs, qx, qy, T] = generate_data_with_new_parametrization();
e = 1e-6;
R = init_R();



%% Test 1: init_F

F_coeffs = init_F(x, y, X, R); %4x3x6
mons = [qx^2, qx*qy, qy^2, qx, qy, 1];
F = zeros(4, 3);
for i = 1 : 4
    for j = 1 : 3
        for k = 1 : 6
            F(i, j) = F(i, j) + F_coeffs(i, j, k)*mons(k);
        end
    end
end
disp(F*[fc; fs; 1]);
assert(norm(F*[fc; fs; 1]) < e);

%% Test 2: equations_for_groebner
F = init_F(x, y, X, R); %4x3x6
G4 = equations_for_groebner(F);
mons = [qx^6, qx^5*qy, qx^4*qy^2, qx^3*qy^3, qx^2*qy^4, qx*qy^5, qy^6, qx^5, qx^4*qy, qx^3*qy^2, qx^2*qy^3, qx*qy^4, qy^5, qx^4, qx^3*qy, qx^2*qy^2, qx*qy^3, qy^4, qx^3, qx^2*qy, qx*qy^2, qy^3, qx^2, qx*qy, qy^2, qx, qy, 1];
disp(G4*mons');
assert(norm(G4*mons') < e);

%% Test 3: mult_for_groebner
F = init_F(x, y, X, R); %4x3x6
G4 = equations_for_groebner(F); %4x28
G20 = mult_for_groebner(G4); %20x45
mons = [qx^8, qx^7*qy, qx^6*qy^2, qx^5*qy^3, qx^4*qy^4, qx^3*qy^5, qx^2*qy^6, qx*qy^7, qy^8, qx^7, qx^6*qy, qx^5*qy^2, qx^4*qy^3, qx^3*qy^4, qx^2*qy^5, qx*qy^6, qy^7, qx^6, qx^5*qy, qx^4*qy^2, qx^3*qy^3, qx^2*qy^4, qx*qy^5, qy^6, qx^5, qx^4*qy, qx^3*qy^2, qx^2*qy^3, qx*qy^4, qy^5, qx^4, qx^3*qy, qx^2*qy^2, qx*qy^3, qy^4, qx^3, qx^2*qy, qx*qy^2, qy^3, qx^2, qx*qy, qy^2, qx, qy, 1];
disp(G20*mons');
assert(norm(G20*mons') < e);

%% Test 4:
F = init_F(x, y, X, R); %4x3x6
[fc_new, fs_new, n] = find_f(F, qx, qy, e);
%disp(abs([fc_new - fc, fs_new - fs]));
assert(norm([fc_new - fc, fs_new - fs]) < e);


