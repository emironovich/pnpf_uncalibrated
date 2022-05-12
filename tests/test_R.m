%test R
syms qx qy
R_sym = [1 + qx^2 - qy^2, 2*qx*qy, 2*qy;
    2*qx*qy, qy^2 - qx^2 + 1, -2*qx;
    -2*qy, 2*qx, 1 - qx^2 - qy^2];

x = sym('x', [1, 4]); %image points
y = sym('y', [1, 4]);
X = sym('X', [3, 4]); %space points

%%Test 1: R

for i = 1 : 3
    for j = 1 : 3
        [c, t] = coeffs(R_sym(i, j), [qx, qy]);
        assert(isequal(squeeze(R(i, j, :)),reorganize_from_coeff(c, t, 2, qx, qy)));
    end
end

%%Test 2: F

