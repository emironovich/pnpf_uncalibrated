bench_names = {'courtyard','delivery_area','electro','facade','kicker','meadow', 'office','pipes','playground','relief','relief_2','terrace','terrains'};
fin = fopen('fov_check_09_07.txt', 'w');
for ind_bench = 1 : numel(bench_names)

    bench_name = bench_names{ind_bench};
    input_path_gt = ['data/eth3d_gt/' bench_name];
    [cameras, ~, ~] = read_model(input_path_gt);
    cameras_keys = keys(cameras);
    for i = 1 : length(cameras_keys)
        k = cameras_keys{i};
        params = cameras(k).params;
        fx = params(1);
        fy = params(2);
        cx = params(3);
        cy = params(4);
        w = cameras(k).width;
        h = cameras(k).height;
        half_diag = norm([cx, cy]);
        fov_x = 2 * atan(half_diag / fx) * 180 / pi;
        fov_y = 2 * atan(half_diag / fy) * 180 / pi;
        if fov_x < 40 || fov_x > 140 || fov_y < 40 || fov_y > 140
            fprintf(fin, ['cxcy:' bench_name ' ' num2str(k) ' fov: ' num2str(fov_x) ' ' num2str(fov_y) '\n']);
        end
         fprintf(fin, ['cxcy:' bench_name ' ' num2str(k) ' fov: ' num2str(fov_x) ' ' num2str(fov_y) '\n']);
        half_diag = norm([h, w])/2;
        fov_x = 2 * atan(half_diag / fx) * 180 / pi;
        fov_y = 2 * atan(half_diag / fy) * 180 / pi;
        if fov_x < 40 || fov_x > 140 || fov_y < 40 || fov_y > 140
            fprintf(fin, ['wh:' bench_name ' ' num2str(k) ' fov: ' num2str(fov_x) ' ' num2str(fov_y)  '\n']);
        end
        fprintf(fin, ['wh:' bench_name ' ' num2str(k) ' fov: ' num2str(fov_x) ' ' num2str(fov_y)  '\n']);
    end
    
end
fclose(fin);