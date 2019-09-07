N = 10000;
e = 1e-4;

p4p = @(X, u, v, e)solve_P4Pf_double_mex(X, u, v, e);
p35p = @(X,x,y,e)p35p_solver_double_mex(X,x,y,e);

p35p_on_gen
diff_to_cvs

filename = 'stats_p35p_double_mex.csv';
arr = stats_p35p';
write_to_cvs

filename = 'stats_p4p_double_mex.csv';
arr = stats_p4p';
write_to_cvs


p4p = @(X, u, v, e)solve_P4Pf_single_mex(X, u, v, e);
p35p = @(X,x,y,e)p35p_solver_single_mex(X,x,y,e);

p35p_on_gen
diff_to_cvs

filename = 'stats_p35p_single_mex.csv';
arr = stats_p35p';
write_to_cvs

filename = 'stats_p4p_single_mex.csv';
arr = stats_p4p';
write_to_cvs

