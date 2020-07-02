% function evaluating sfm reconstruction by estimating a transfromation 
% between ground-thruth cordinate system and sfm cordinate system
% Input:
% cameras_gt, images_gt  -- ground truth data
% cameras_eval, images_eval -- evaluated data
% all in format of colmap's read_model() output
%
% Output:
% f_diff, R_diff, t_diff -- relative parameter differences
% resnorm_R_abs, resnorm_t_abs are squared 2-norms of the residuals from
% R_abs and t_abs estimation

function [f_diff, R_diff, t_diff, resnorm_R_abs, resnorm_t_abs] = cmp_solver_absolute_transformation(cameras_gt, images_gt, cameras_eval, images_eval)

    n = length(images_eval);

    [f_gt, f_eval, R_gt, R_eval, t_gt, t_eval] = map_gt2eval(cameras_gt, images_gt, cameras_eval, images_eval);

    [R_abs, t_abs, alpha, resnorm_R_abs, resnorm_t_abs] = find_absolute_Rt(R_gt, R_eval, t_gt, t_eval);
    
    
    f_diff = zeros(n, 1);
    R_diff = zeros(n, 1);
    t_diff = zeros(n, 1);
    
    for i = 1 : n
        for j = (i+1):n
            rel_t = norm(t_gt(:, i) - t_gt(:, j));
        end
    end
    
    median_rel = median(rel_t);
    
    for ind = 1 : n
        fx_gt = f_gt(ind, 1);
        fy_gt = f_gt(ind, 2);
        fx_eval = f_eval(ind, 1);
        fy_eval = f_eval(ind, 2);

        f_diff(ind) = (abs(fx_gt - fx_eval) + abs(fy_gt - fy_eval)) / abs(fx_gt + fy_gt);

        curr_R_eval = squeeze(R_eval(:,:,ind));
        curr_t_eval = t_eval(:, ind);
        curr_R_gt = squeeze(R_gt(:,:,ind));
        curr_t_gt = t_gt(:, ind);
        
        R_diff(ind) = rad2deg(abs(acos((trace(curr_R_eval'*curr_R_gt*R_abs')-1)/2)));
        t_diff(ind) = norm(-alpha*R_abs*curr_R_gt'*curr_t_gt + t_abs + curr_R_eval'*curr_t_eval)/(abs(alpha)*median_rel);
    end
end