[x, y, z, c] = make_system();
e = 1e-4;
[n, xs, ys, zs, A, P, P_prime, M, pol] = solve_3Q3(c, e);

%% Test 1: test A and P
P_eval = zeros(3);
mons = [x^2, x, 1];
for i = 1 : 3
    for j = 1 : 3
        for k = 1 : 3
            P_eval(i, j) = P_eval(i, j) + P(i, j, k)*mons(k);
        end
    end
end

assert(max(abs(A*[y^2; z^2; y*z] - P_eval*[y; z; 1])) < e);


%% Test 2: test P_prime

P_prime_eval = zeros(3);
mons = [x^2, x, 1];
for i = 1 : 3
    for j = 1 : 3
        for k = 1 : 3
            P_prime_eval(i, j) = P_prime_eval(i, j) + P_prime(i, j, k)*mons(k);
        end
    end
end

assert(max(abs([y^2; z^2; y*z] - P_prime_eval*[y; z; 1])) < e);

%% Test 3: test M

M_eval = zeros(3);
mons = [x^4, x^3, x^2, x, 1];
for i = 1 : 3
    for j = 1 : 3
        M_eval(i, j) = mons * M(:, i, j);
    end
end
assert(max(abs(M_eval*[y; z; 1])) < e);

%% Test 4: find_det

assert(abs(polyval(pol, x)) < e);

%% Test 5: general test

min_diff = inf;

for i = 1 : n
    if norm(([xs(i), ys(i), zs(i)] - [x, y, z])) < min_diff
        min_diff = norm(([xs(i), ys(i), zs(i)] - [x, y, z]));
    end
end

disp(min_diff);
assert(min_diff < e);
