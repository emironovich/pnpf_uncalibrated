N = 10000;
e = 1e-4;

p4p = @(X, u, v, e)p4p_solver(X, u, v, e);

solver_on_gen(N, e, p4p, 'unnecessary.csv');