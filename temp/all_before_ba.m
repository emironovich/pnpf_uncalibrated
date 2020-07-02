path = 'data/eth3d_results_40_140_26_06/loransac/courtyard/p35p/1';
path_gt = 'data/eth3d_gt/courtyard';
% [cameras_real, images_real, ~] = read_model([path 'real/1']);
% [cameras_p35p, images_p35p, ~] = read_model([path 'p35p/1']);
% [cameras_p4p, images_p4p, ~] = read_model([path 'p4p/1']);
% [cameras_gt, images_gt, ~] = read_model([path_gt 'gt']);
% 
% [cameras_real_before_ba, images_real_before_ba] = read_before_ba([path 'real/1/'], cameras_real, images_real);
% [cameras_p35p_before_ba, images_p35p_before_ba] = read_before_ba([path 'p35p/1/'], cameras_p35p, images_p35p);
% [cameras_p4p_before_ba, images_p4p_before_ba] = read_before_ba([path 'p4p/1/'], cameras_p4p, images_p4p);
% 
% [f_diffs, R_diffs, t_diffs] = cmp_solver_absolute_transformation(cameras_gt, images_gt, cameras_real_before_ba, images_real_before_ba);

file_name = 'unnecessary';

fin_f = fopen([output_file_name '_before_ba_f.csv'], 'w');
fprintf(fin_f, 'f,algo\n');
fin_abs = fopen([output_file_name '_before_ba_Rt_abs.csv'], 'w');
fprintf(fin_abs, 'R,t,algo\n');
fclose(fin_f);
fclose(fin_abs);

make_bench_before_ba('real', path, path_gt, file_name);
make_bench_before_ba('p35p', path, path_gt, file_name);
make_bench_before_ba('p4p', path, path_gt, file_name);


function make_bench_before_ba(solver_name, input_path, input_path_gt, output_file_name)
    [cameras_eval, images_eval, ~] = read_model([input_path '/' solver_name '/1']);
    [cameras_gt, images_gt, ~] = read_model([input_path_gt '/gt']);
    
    [cameras_before_ba, imagesl_before_ba] = read_before_ba([input_path '/' solver_name '/1'], cameras_eval, images_eval);
    
    [f_diff, R_diff, t_diff] = cmp_solver_absolute_transformation(cameras_gt, images_gt, cameras_before_ba, imagesl_before_ba);
    
    fin_f = fopen([output_file_name '_before_ba_f.csv'], 'a');
    fprintf(fin_f, ['%f,' solver_name '\n'], f_diff);
    
    fin_abs = fopen([output_file_name '_before_ba_Rt_abs.csv'], 'a');
    fprintf(fin_abs, ['%f,%f,' solver_name '\n'], [R_diff'; t_diff']);

    fclose(fin_f);
    fclose(fin_abs);    
end