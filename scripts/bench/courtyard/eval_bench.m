path = 'scripts/bench/courtyard/data/';

[cameras_real, images_real, ~] = read_model([path 'real']);
[cameras_p35p, images_p35p, ~] = read_model([path 'p35p']);
[cameras_p4p, images_p4p, ~] = read_model([path 'p4p']);
[cameras_gt, images_gt, ~] = read_model([path 'gt']);

[f_p35p, R_p35p, T_p35p] = cmp_solvers(cameras_gt, images_gt, cameras_p35p, images_p35p);
[f_p4p, R_p4p, T_p4p] = cmp_solvers(cameras_gt, images_gt, cameras_p4p, images_p4p);
[f_real, R_real, T_real] = cmp_solvers(cameras_gt, images_gt, cameras_real, images_real);

fin_f = fopen('becnchmark_courtyard_f.csv', 'wb');
fprintf(fin_f, "f,algo\n");
fprintf(fin_f, "%f,'p35p'\n", f_p35p);
fprintf(fin_f, "%f,'p4p'\n", f_p4p);
fprintf(fin_f, "%f,'orig'\n", f_real);

fin_Rt = fopen('becnchmark_courtyard_Rt.csv', 'wb');
fprintf(fin_Rt, "R, t,algo\n");
fprintf(fin_Rt, "%f,%f,'p35p'\n", [R_p35p'; T_p35p']);
fprintf(fin_Rt, "%f,%f,'p4p'\n", [R_p4p'; T_p4p']);
fprintf(fin_Rt, "%f,%f,'orig'\n", [R_real'; T_real']);

fclose(fin_Rt);
fclose(fin_f);

function [f_diff, R_diff_half, T_diff_half] = cmp_solvers(cameras_gt, images_gt, cameras_est, images_est)
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
            alphas(i, j) = mean(abs(images_est(i).t - images_est(j).t) ./ abs(images_gt(i).t - images_gt(j).t));
        end
    end
    alpha = median(alphas, 'all', 'omitnan');
    
    for i = 1 : n
        for j = 1 : n
            T_diff(i, j) = norm((images_est(i).t - images_est(j).t) - alpha*(images_gt(i).t - images_gt(j).t))/(alpha*norm(images_gt(i).t - images_gt(j).t));
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