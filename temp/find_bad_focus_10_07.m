% Find all relative focal differences that are larger than one

res_date = '07_07';
curr_date = '10_07';
trials_num = 9;

bench_names = {'courtyard','delivery_area','electro','facade','kicker','meadow', 'office','pipes','playground','relief','relief_2','terrace','terrains'};
%bench_names = {'courtyard'};
methods = {'filter_40_140', 'no_filter'};

fout = fopen(['bad_focus_' curr_date '.txt'], 'w');
fprintf(fout, '#Start\n');
for ind_method = 1 : numel(methods)
    for ind_bench = 1 : numel(bench_names)

        bench_name = bench_names{ind_bench};
        method_name = methods{ind_method};
        base_name = [bench_name '_' method_name '_' curr_date];
        
        input_path_base = ['data/eth3d_results_fov_' res_date '/' method_name '/' bench_name];
        input_path_gt = ['data/eth3d_gt/' bench_name];
        output_file_name = 'unnecessary'; %[base_name '_trial_' num2str(j)];
        
        for j = 1 : trials_num

            if strcmp(method_name, 'no_filter')
                algo_names = {'p35p', 'p4p', 'real'};
            else
                algo_names = {'p35p', 'p4p'};
            end
            
            for i = 1 : numel(algo_names)
                
               sub_rec_num = 0;
               
               while true
                   exact_input_path =  [input_path_base '/' algo_names{i} '/' num2str(j) '/' num2str(sub_rec_num)];
                   
                   if ~isfile([exact_input_path '/cameras.txt'])
                       break;
                   end
                   sub_rec_num = sub_rec_num + 1;
                   
                   [cameras_eval, images_eval, ~] = read_model(exact_input_path);
                   [cameras_gt, images_gt, ~] = read_model(input_path_gt);
                   [f_gt, f_eval, ~, ~, ~, ~, m_gt, m_eval] = map_gt2eval(cameras_gt, images_gt, cameras_eval, images_eval);
                   
                   image_names = keys(m_eval);
                   bad_cam_num = 0;
                   for k = 1 : length(images_eval)                       
                        fx_gt = f_gt(k, 1);
                        fy_gt = f_gt(k, 2);
                        fx_eval = f_eval(k, 1);
                        fy_eval = f_eval(k, 2);

                        f_diff = (abs(fx_gt - fx_eval) + abs(fy_gt - fy_eval)) / abs(fx_gt + fy_gt);
                        if f_diff > 1
                           image_name = image_names{k};
                           if bad_cam_num == 0
                              fprintf(fout, [exact_input_path '\n']);
                           end
                           bad_cam_num = bad_cam_num + 1;
                           fprintf(fout, [image_name ' GT: image_id %d, camera_id %d   EVAL: image_id %d camera_id %d           ' num2str(f_diff) '\n'], m_gt(image_name).image_id, m_gt(image_name).camera_id, m_eval(image_name).image_id, m_eval(image_name).camera_id);
                        end
                   end
                   if bad_cam_num > 0
                       fprintf(fout, 'TOTAL BAD FOCUS NUM: %d / %d\n', bad_cam_num, length(images_eval));
                   end
               end
            end
        end
    end
end

fclose(fout);