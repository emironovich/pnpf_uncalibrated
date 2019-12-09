r_vector = rand(3, 1)-0.5;
r_vector_skew = make_skew(r_vector);
R = expm(r_vector_skew);

C = rand(3, 1)-0.5;

P = rand(3);
f = zeros(3);

eps = 1e-4;

for i = 1 : 3
    f(:, i) = R'*(P(:, i) - C);
    f(:, i) = f(:, i) / norm(f(:, i));
end

[n, R_p3p, C_p3p] = p3p_solver(f(:, 1), f(:, 2), f(:, 3), P(:, 1), P(:, 2), P(:, 3), eps);

min_diff_C = inf;
min_diff_R = inf;

for i = 1 : n
    if norm(C_p3p(:, i)- C) < eps
        min_diff_C = norm(C_p3p(:, i)- C);
        min_diff_R = norm(squeeze(R_p3p(:, :, i))- R, 'fro') / 3;
    end
end

assert(min_diff_C < eps);
assert(min_diff_R < eps);
