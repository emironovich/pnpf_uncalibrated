%Testing p4p_solver()

[X, u, v, f, R, C, P] = generate_data();
w = 1 / f;
T = -R*C;
e = 1e-8;
[num, fs, Rs, Ts, A, N, D, eqs] = p4p_solver(X, u, v, 1e-4);

X = [X; ones(1, 4)];
%% Test 1: A
V = [P(1, :), P(2, :)]';
% disp(A*V);
assert(norm(A*V) < e);

%% Test 2: N
%disp(A*N);
assert(norm(A*N) < e);

%% Test 3: D
V = [P(1, :), P(2, :)]';
gamma = N\V;
% disp((P(3, :))' -D*gamma);
assert(norm((P(3, :))' -D*gamma) < e);

%% Test 4: find_eqs
V = [P(1, :), P(2, :)]';
gamma = N\V;
gamma = gamma / gamma(4);

x = gamma(1);
y = gamma(2);
z = gamma(3);

mons = [x^2, y^2, z^2, x*y, x*z, y*z, x, y, z, 1];
mons = mons';

%disp(eqs*mons);
assert(norm(eqs*mons) < e);

%% Test 5: f
min_diff = inf;
for i = 1 : num
    if abs(fs(i) - f) < min_diff
        min_diff = abs(fs(i) - f);
    end
end
% disp(min_diff/f);
assert(abs(min_diff/f) < e);

