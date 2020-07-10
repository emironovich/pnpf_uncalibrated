% Create combined csv files from colmap output 
%for each dataset from bench_names

% file_name_f.csv  --- f, trial, algo
% file_name_Rt.csv  --- R, t, trial, algo


res_date = '26_06';
trials_num = 16;
results_name = '40_140';

%bench_names = {'courtyard','delivery_area','electro','facade','kicker','meadow', 'office','pipes','playground','relief','relief_2','terrace','terrains'};
bench_names = {'courtyard'};
methods = {'loransac'};

for ind_method = 1 : numel(methods)
    for ind_bench = 1 : numel(bench_names)

        bench_name = bench_names{ind_bench};
        method_name = methods{ind_method};
        base_name = [results_name '_' bench_name '_' method_name '_' res_date];

        combined_name = ['combined_' base_name];
        comb_fin_f = fopen([combined_name '_f.csv'], 'w');
        fprintf(comb_fin_f, 'f,trial,algo\n');
        comb_fin_Rt = fopen([combined_name '_Rt.csv'], 'w');
        fprintf(comb_fin_Rt, 'R,t,trial,algo\n'); 
        
        input_path_base = ['data/eth3d_results_' results_name '_' res_date '/' method_name '/' bench_name];
        input_path_gt = ['data/eth3d_gt/' bench_name];
        output_file_name = 'unnecessary'; %[base_name '_trial_' num2str(j)];

        for j = 1 : trials_num
            algo_names = {'p35p', 'p4p', 'real'};
            
            for i = 1 : numel(algo_names)
                   if ~isfile([input_path_base '/' algo_names{i} '/' num2str(j) '/cameras.txt'])
                       continue;
                   end
                   
                    [cameras_eval, images_eval, ~] = read_model([input_path_base '/' algo_names{i} '/' num2str(j)]);
                    [cameras_gt, images_gt, ~] = read_model(input_path_gt);
                    
                    [f_gt, f_eval, R_gt, R_eval, t_gt, t_eval] = map_gt2eval(cameras_gt, images_gt, cameras_eval, images_eval);
                    
%                     image_keys = keys(images_eval);
%                     for ind_k = 1 : length(image_keys)
%                         k = image_keys{ind_k};
%                         eval_name = images_eval(k).name;
%                         gt_name = images_gt(k).name;
%                         % remove 'dslr_images_undistorted/' prefix
%                         gt_name = gt_name(25:end);
%                         msg = 'Path: %s,   Key: %d';
%                         assert(strcmp(eval_name, gt_name), msg, [input_path_base '/' algo_names{i} '/' num2str(j)], k);   
%                     end
            end
        end
    end
end