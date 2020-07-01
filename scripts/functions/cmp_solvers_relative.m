% function evaluating sfm reconstruction by TODO
% Input:
% cameras_gt, images_gt  -- ground truth data
% cameras_est, images_est -- estimated data
% all in format of colmap's read_model() output
%
% Output:
% f_diff, R_diff_half, T_diff_half -- relative parapeter differences

function [f_diff, R_diff_half, T_diff_half] = cmp_solvers_relative(cameras_gt, images_gt, cameras_est, images_est)
    assert(length(images_gt) == length(images_est));
    assert(length(images_est) == length(cameras_est));
    n = length(images_gt);
    f_diff = zeros(n, 1);
    R_diff = zeros(n);
    alphas = zeros(n);
    T_diff = zeros(n);
    for i = 1 : n
        fx_gt = cameras_gt(images_gt(i).camera_id).params(1);
        fy_gt = cameras_gt(images_gt(i).camera_id).params(2);
        fx_est = cameras_est(images_est(i).camera_id).params(1);
        fy_est = cameras_est(images_est(i).camera_id).params(2);
        
        f_diff(i) = (abs(fx_gt - fx_est) + abs(fy_gt - fy_est)) / abs(fx_gt + fy_gt);
        
        for j = 1 : n
            R_diff(i, j) = norm((images_est(i).R)*(images_est(j).R)' - (images_gt(i).R)*(images_gt(j).R)', 'fro') / 3;
            alphas(i, j) = norm(images_est(i).t - images_est(j).t) / norm(images_gt(i).t - images_gt(j).t);
        end
    end
    alpha = median(alphas, 'all', 'omitnan');
    
    for i = 1 : n
        for j = 1 : n
            T_diff(i, j) = (norm(images_est(i).t - images_est(j).t) - alpha*norm(images_gt(i).t - images_gt(j).t))/(alpha*norm(images_gt(i).t - images_gt(j).t));
        end
    end
    T_diff_half = zeros((n^2 - n)/2, 1);
    R_diff_half = zeros((n^2 - n)/2, 1);
    ind = 0;
    for i = 1 : n
        for j = i + 1 : n
            ind = ind + 1;
            T_diff_half(ind) = T_diff(i, j);
            R_diff_half(ind) = R_diff(i, j);
        end
    end
end