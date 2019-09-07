%this is a script that makes data for comparison of P4P and P3.5P solvers
%in single- and double-presicion
N = 10000;
e = 1e-4;

% p4p = @(X, u, v, e)solve_P4Pf_double_mex(X, u, v, e);
% p35p = @(X,x,y,e)p35p_solver_double_mex(X,x,y,e);
p4p = @(X, u, v, e)solve_P4Pf_mex(X, u, v, e);
p35p = @(X,x,y,e)p35p_solver_mex(X,x,y,e);

p35p_on_gen
diff_to_cvs


filename = 'stats_p35p_double.csv';
arr = stats_p35p';
write_to_cvs(filename, arr, 'dF,dR,dC,dt,N');

filename = 'stats_p4p_double.csv';
arr = stats_p4p';
write_to_cvs(filename, arr, 'dF,dR,dC,dt,N');


p4p = @(X, u, v, e)solver_P4Pf_single_mex(X, u, v, e);
p35p = @(X,x,y,e)p35p_solver_single_mex(X,x,y,e);

p35p_on_gen
diff_to_cvs

filename = 'stats_p35p_single.csv';
arr = stats_p35p';
write_to_cvs(filename, arr, 'dF,dR,dC,dt,N');

filename = 'stats_p4p_single.csv';
arr = stats_p4p';
write_to_cvs(filename, arr, 'dF,dR,dC,dt,N');

write_noisy_stats(N, e, p4p, 'stats_p4p_noisy.csv');
write_noisy_stats(N, e, p35p, 'stats_p35p_noisy.csv');
