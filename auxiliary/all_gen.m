%script for generating mex files
%start this file from the root of the repository
eps = 1e-04;
[X, u, v] = generate_data();
cd P4Pf
codegen solve_P4Pf.m -args {X, u, v, eps} -test p4p_codegen.m -report -o 'solve_P4Pf_double_mex';
codegen -singleC solve_P4Pf.m -args {X, u, v, eps} -test p4p_codegen.m -report -o 'solve_P4Pf_single_mex';
cd ../P3.5P
codegen p35p_solver.m -args {X, u, v, eps} -test p35p_codegen.m -report -o 'p35p_solver_double_mex';
codegen -singleC p35p_solver.m -args {X, u, v, eps} -test p35p_codegen.m -report -o 'p35p_solver_single_mex';
