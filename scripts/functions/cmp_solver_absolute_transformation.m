% function evaluating sfm reconstruction by estimating a transfromation 
% between ground-thruth cordinate system and sfm cordinate system
% Input:
% cameras_gt, images_gt  -- ground truth data
% cameras_est, images_est -- estimated data
% all in format of colmap's read_model() output
%
% Output:
% f_diff, R_diff, t_diff -- relative parapeter differences
% resnorm_R_abs, resnorm_t_abs are squared 2-norms of the residuals from
% R_abs and t_abs estimation

function [f_diff, R_diff, t_diff, resnorm_R_abs, resnorm_t_abs] = cmp_solver_absolute_transformation(cameras_gt, images_gt, cameras_est, images_est)
%     assert(length(images_gt) == length(images_est));
    assert(length(images_est) == length(cameras_est));
    n = length(images_est);
    
    [R_abs, t_abs, alpha, resnorm_R_abs, resnorm_t_abs] = find_absolute_Rt(images_gt, images_est);
    
    
    f_diff = zeros(n, 1);
    R_diff = zeros(n, 1);
    t_diff = zeros(n, 1);
    
    for i = 1 : n
        for j = (i+1):n
            rel_t = norm(images_gt(i).t - images_gt(j).t);
        end
    end
    
    median_rel = median(rel_t);
    
    
    image_keys = keys(images_est);
    for ind = 1 : n
        i = image_keys{ind};
        fx_gt = cameras_gt(images_gt(i).camera_id).params(1);
        fy_gt = cameras_gt(images_gt(i).camera_id).params(2);
        fx_est = cameras_est(images_est(i).camera_id).params(1);
        fy_est = cameras_est(images_est(i).camera_id).params(2);
        
        f_diff(ind) = (abs(fx_gt - fx_est) + abs(fy_gt - fy_est)) / abs(fx_gt + fy_gt);
        
%         previous version
%         R_diff(ind) = norm(images_est(i).R - images_gt(i).R*R_abs', 'fro')/3;
%         
%         this proved to be not percise enough and returned zeros a lot
%         axang = rotm2axang((images_est(i).R)'*images_gt(i).R*R_abs');
%         R_diff(ind) = axang(4);

        R_diff(ind) = rad2deg(abs(acos((trace((images_est(i).R)'*images_gt(i).R*R_abs')-1)/2)));
        t_diff(ind) = norm(-alpha*R_abs*(images_gt(i).R)'*images_gt(i).t + t_abs + (images_est(i).R)'*images_est(i).t)/(abs(alpha)*median_rel);
    end
end