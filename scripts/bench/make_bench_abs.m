% function for benchmark composition
%
% INPUT:
% folders input_path_eval and input_path_gt should contain standard
% colmap files (cameras.txt, images.txt, points3D.txt) representing 
% estimated and ground-truth sfm models respectively
%
% OUPUT:
% means of f_diffs, R_diffs, t_diffs in a column vector
% 
% data is comapred using absolute transformation estimation
% and is written TO THE END of output_file_name + "_f.csv" and "_Rt.csv"
% respectively where columns are supposed: f,algo, and R,t,algo


function [means, f_diffs, R_diffs, t_diffs] = make_bench_abs(solver_name, input_path_eval, input_path_gt, output_file_name)
    [cameras_eval, images_eval, ~] = read_model(input_path_eval);
    [cameras_gt, images_gt, ~] = read_model(input_path_gt);
    
    [f_diffs, R_diffs, t_diffs] = cmp_solver_absolute_transformation(cameras_gt, images_gt, cameras_eval, images_eval);
        
    means = [mean(f_diffs); mean(R_diffs); mean(t_diffs)];
    
%     ind_f = f_diffs < 1;
%     ind_t = t_diffs < 70;
%     ind_inliers = ind_f & ind_t;
    
%     f_diffs = f_diffs(ind_inliers);
%     R_diffs = R_diffs(ind_inliers);
%     t_diffs = t_diffs(ind_inliers);
    
    if length(f_diffs) >= 5
        fin_f = fopen([output_file_name '_f.csv'], 'a');
        fprintf(fin_f, ['%f,' solver_name '\n'], f_diffs);

        fin_rt = fopen([output_file_name '_Rt.csv'], 'a');
        fprintf(fin_rt, ['%f,%f,' solver_name '\n'], [R_diffs'; t_diffs']);

        fclose(fin_f);
        fclose(fin_rt);  
    end
end