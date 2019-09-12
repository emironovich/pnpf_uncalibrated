%this is a script that makes data for comparison of P4P and P3.5P solvers
%in single- and double-presicion
N = 10000;
e = 1e-4;


p35p_double = @(X, x, y, e)p35p_solver_double_mex(X, x, y, e);
p4p_double = @(X, u, v, e)solve_P4Pf_double_mex(X, u, v, e);
% p35p_double = @(X, x, y, e)p35p_solver(X, x, y, e);
% p4p_double = @(X, u, v, e)solve_P4Pf(X, u, v, e);

solver_on_gen(N, e, p35p_double, 'stats_p35p_double.csv');
solver_on_gen(N, e, p4p_double, 'stats_p4p_double.csv');


p35p_single = @(X, x, y, e)p35p_solver(X, x, y, e);
p4p_single = @(X, u, v, e)solve_P4Pf(X, u, v, e);
% p35p_single = @(X, x, y, e)p35p_solver_single_mex(X, x, y, e);
% p4p_single = @(X, u, v, e)solve_P4Pf_single_mex(X, u, v, e);

solver_on_gen(N, e, p35p_single, 'stats_p35p_single.csv');
solver_on_gen(N, e, p4p_single, 'stats_p4p_single.csv');

solver_on_gen_with_noise(N, e, p35p_single, 'stats_p35p_noisy.csv');
solver_on_gen_with_noise(N, e, p4p_single, 'stats_p4p_noisy.csv');
