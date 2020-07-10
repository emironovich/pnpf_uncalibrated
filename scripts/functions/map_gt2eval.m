% INPUT: cameras_*, images_* -- output from read_model()
%        gt -- ground-truth data, eval -- evaluated data
%    !!REMOVES 'dslr_images_undistorted/' PREFIX FROM GT IMAGES NAMES!!
%
% OUTPUT: f_*    n x 2       (fx fy)
%         R_*    3 x 3 x n
%         t_*    3 x n
% parameters with the same index correspond to the same camera/image
% (i.e. R_gt(:,:,5) <-> R_eval(:,:,5)

function [f_gt, f_eval, R_gt, R_eval, t_gt, t_eval, m_eval_keys] = map_gt2eval(cameras_gt, images_gt, cameras_eval, images_eval)
    image_gt_keys = keys(images_gt);
    % remove 'dslr_images_undistorted/' prefix
    for i = 1 : length(image_gt_keys)
        k = image_gt_keys{i};
        image_copy = images_gt(k);
        gt_name = images_gt(k).name;
        if length(gt_name) >= 25 && strcmp(gt_name(1:24), 'dslr_images_undistorted/')
            image_copy.name = gt_name(25:end);
            images_gt(k) = image_copy;
        end
    end
    
    m_gt = model_data2joint_map(cameras_gt, images_gt);
    m_eval = model_data2joint_map(cameras_eval, images_eval);
    
    n = length(m_eval);
    f_gt = zeros(n, 2);
    R_gt = zeros(3, 3, n);
    t_gt = zeros(3, n);
    
    f_eval = zeros(n, 2);
    R_eval = zeros(3, 3, n);
    t_eval = zeros(3, n);
    
    m_eval_keys = keys(m_eval);
    for i = 1 : n
        k = m_eval_keys{i};
        f_gt(i, 1) = m_gt(k).params(1);
        f_gt(i, 2) = m_gt(k).params(2);
        R_gt(:,:,i) = m_gt(k).R;
        t_gt(:,i) = m_gt(k).t;
        
        f_eval(i, 1) = m_eval(k).params(1);
        f_eval(i, 2) = m_eval(k).params(2);
        R_eval(:,:,i) = m_eval(k).R;
        t_eval(:,i) = m_eval(k).t;
    end
end

% INPUT: cameras, images --output from read_model()
% OUTPUT: map with keys as image NAME and values as structs with params, R, t
% fields for respective images
function m = model_data2joint_map(cameras, images)
    n = length(images);
    image_keys = keys(images);
    
    m_keys = cell(1, n);
    m_values = cell(1, n);
    for i = 1 : n
        k = image_keys{i};
        m_keys{i} = images(k).name;
        res_struct.R = images(k).R;
        res_struct.t = images(k).t;
        res_struct.params = cameras(images(k).camera_id).params;
        m_values{i} = res_struct;
    end
    
    m = containers.Map(m_keys, m_values);
end