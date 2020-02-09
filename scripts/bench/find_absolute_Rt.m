% function for evaluating absolute rotation and absolute translation from  
% gt cootdinate system to sfm coordinate system
% Input:
% images_gt  -- ground truth data
% images_eval -- evaluated data
% all in format of colmap's read_model() output
%
% Output:
% R, t, alpha trnasform gt cootdinate system in sfm coordinate system as
% x_sfm = alpha*R*x_gt + t
% resnorm_R, resnorm_t are squared 2-norms of the residuals at R and
% [alpha;t] respectively


function [R, t, alpha, resnorm_R, resnorm_t] = find_absolute_Rt(images_gt, images_eval)
    assert(length(images_gt) == length(images_eval));
    n = length(images_gt);
    R_gt = zeros(3,3,n);
    R_eval = zeros(3,3,n);
    t_gt = zeros(3,n);
    t_eval = zeros(3,n);
    for i = 1 : n
        R_gt(:,:,i) = (images_gt(i).R)';
        R_eval(:,:,i) = (images_eval(i).R)';
        t_gt(:,i) = -(images_gt(i).R)'*images_gt(i).t;
        t_eval(:,i) = -(images_eval(i).R)'*images_eval(i).t;
    end
    
    % find first estimation value by solving R_eval(i) = R0 * R_gt(i) system
    R_eval_stacked = zeros(3*n,3);
    R_gt_stacked = zeros(3*n,3);
    ind = 1;
    for i = 1 : n
        R_eval_stacked(ind:(ind+2), :) = R_eval(:,:,i)';
        R_gt_stacked(ind:(ind+2), :) = R_gt(:,:,i)';
        ind = ind + 3;
    end
    R0 = (R_gt_stacked\R_eval_stacked)';
    [U, ~, V] = svd(R0);
    R0 = (U*V');
    R0 = sign(det(R0))*R0;
    
    [R_vec, resnorm_R] = lsqnonlin(@(R_vec) logRRR(R_vec, R_gt, R_eval), unskew(logm(R0))); % todo check constraints
    R = expm(make_skew(R_vec));
    
    t_eval_stacked = zeros(3*n, 1);
    Rt_gt_m = zeros(3*n, 4);
    ind = 1;
    for i = 1 : n
        t_eval_stacked(ind : (ind + 2)) = t_eval(:, i);
        Rt_gt_m(ind : (ind + 2), :) = [R*t_gt(:, i), eye(3)];
        ind = ind + 3;
    end
    
    res = Rt_gt_m\t_eval_stacked;
    alpha = res(1);
    t = res(2:end);
    resnorm_t = norm(Rt_gt_m*res - t_eval_stacked)^2;
    
end

%auxiliary function in nonlinear optimization for R
function F = logRRR(t, R_gt, R_eval)
    R = expm(make_skew(t));
    len = length(R_gt);
    F = zeros(len, 1);
    for i = 1 : len
        F(i) = norm(logm((R*squeeze(R_gt(:,:,i)))'*squeeze(R_eval(:,:,i))));
    end
end

function v = unskew(A)
    v = zeros(3, 1);
    v(1) = A(3, 2);
    v(2) = A(1, 3);
    v(3) = A(2, 1);
end

