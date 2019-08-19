%Tests
[X, x, y, fc, fs, qx, qy, T, P] = generate_data_with_new_parametrization();
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

%% Test 4: multiplications in mult_for_groebner
F = init_F(x, y, X, R); %4x3x6
G4 = equations_for_groebner(F); %4x28
syms p q;
sym_mons6 = [ p^6; p^5*q; p^4*q^2; p^3*q^3; p^2*q^4; p*q^5; q^6; p^5; p^4*q; p^3*q^2; p^2*q^3; p*q^4; q^5; p^4; p^3*q; p^2*q^2; p*q^3; q^4; p^3; p^2*q; p*q^2; q^3; p^2; p*q; q^2; p; q; 1];
G4_sym = G4*sym_mons6;
G20_sym = sym('g', [20, 1]);
G20_sym(1:4) = p^2*G4_sym;
G20_sym(5:8) = p*q*G4_sym;
G20_sym(9:12) = p*G4_sym;
G20_sym(13:16) = q*G4_sym;
G20_sym(17:20) = G4_sym;

G20 = mult_for_groebner(G4); %20x45
sym_mons8 = [ p^8; p^7*q; p^6*q^2; p^5*q^3; p^4*q^4; p^3*q^5; p^2*q^6; p*q^7; q^8; p^7; p^6*q; p^5*q^2; p^4*q^3; p^3*q^4; p^2*q^5; p*q^6; q^7; p^6; p^5*q; p^4*q^2; p^3*q^3; p^2*q^4; p*q^5; q^6; p^5; p^4*q; p^3*q^2; p^2*q^3; p*q^4; q^5; p^4; p^3*q; p^2*q^2; p*q^3; q^4; p^3; p^2*q; p*q^2; q^3; p^2; p*q; q^2; p; q; 1];
%disp("coeffs diff");
for i = 1 : 20
    %disp(coeffs(G20(i, :)*sym_mons8 - G20_sym(i), [p, q]));
    assert(isempty(coeffs(G20(i, :)*sym_mons8 - G20_sym(i), [p, q])));
end


%% Test 5: find_f
F = init_F(x, y, X, R); %4x3x6
[fc_new, fs_new, n] = find_f(F, qx, qy, e);
%disp(abs([fc_new - fc, fs_new - fs]));
assert(norm([fc_new - fc, fs_new - fs]) < e);

