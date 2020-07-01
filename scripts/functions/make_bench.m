% function for benchmark composition
% INPUT:
% folders input_path/solver_name and input_path/gt should contain standard
% colmap files (cameras.txt, images.txt, points3D.txt) representing 
% estimated and ground-truth sfm models respectively
%
% OUPUT:
% means of respective values
% 
% data is comapered using relative and absolute transformation estimations
% and written TO THE END of output_file_name + "_f.csv" (since f is found
% the same way) and + output_file_name + "_Rt_rel.csv" (and "..._abs.csv")


function [mean_f, mean_rel, mean_abs] = make_bench(solver_name, input_path, output_file_name)
    [cameras_eval, images_eval, ~] = read_model([input_path '/' solver_name]);
    [cameras_gt, images_gt, ~] = read_model([input_path '/gt']);
    
    [f_rel, R_rel, t_rel] = cmp_solvers_relative(cameras_gt, images_gt, cameras_eval, images_eval);
    [~, R_abs, t_abs] = cmp_solver_absolute_transformation(cameras_gt, images_gt, cameras_eval, images_eval);
    
    fin_f = fopen([output_file_name '_f.csv'], 'a');
    fprintf(fin_f, ['%f,' solver_name '\n'], f_rel);
    
    fin_rel = fopen([output_file_name '_Rt_rel.csv'], 'a');
    fprintf(fin_rel, ['%f,%f,' solver_name '\n'], [R_rel'; t_rel']);
    
    fin_abs = fopen([output_file_name '_Rt_abs.csv'], 'a');
    fprintf(fin_abs, ['%f,%f,' solver_name '\n'], [R_abs'; t_abs']);
    
    mean_f = mean(f_rel);
    mean_rel = [mean(R_rel); mean(t_rel)];
    mean_abs = [mean(R_abs); mean(t_abs)];

    fclose(fin_f);
    fclose(fin_rel);
    fclose(fin_abs);    
end