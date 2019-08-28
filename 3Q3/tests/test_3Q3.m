[x, y, z, c] = make_system();
e = 1e-4;

%% Test 1: general test

[n, xs, ys, zs] = solve_3Q3(c, e);

for i = 1 : n
    disp(abs([xs(i), ys(i), zs(i)] - [x, y, z]));
end