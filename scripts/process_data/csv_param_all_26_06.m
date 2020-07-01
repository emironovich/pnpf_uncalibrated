% Create combined csv files from colmap output 
%for each dataset from bench_names

% file_name_f.csv  --- f, trial, algo
% file_name_Rt.csv  --- R, t, trial, algo


res_date = '26_06';
trials_num = 16;
results_name = '40_140';

bench_names = {'courtyard','delivery_area','electro','facade','kicker','meadow', 'office','pipes','playground','relief','relief_2','terrace','terrains'};
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
            % write column names
            fin_f = fopen([output_file_name '_f.csv'], 'w');
            fprintf(fin_f, 'f,algo\n');
            fin_abs = fopen([output_file_name '_Rt.csv'], 'w');
            fprintf(fin_abs, 'R,t,algo\n');
            fclose(fin_f);
            fclose(fin_abs); 

            algo_names = {'p35p', 'p4p', 'real'};
            
            for i = 1 : numel(algo_names)
                   if ~isfile([input_path_base '/' algo_names{i} '/' num2str(j) '/cameras.txt'])
                       continue;
                   end
                   [~, f_diffs, R_diffs, t_diffs] = make_bench_abs(algo_names{i}, [input_path_base '/' algo_names{i} '/' num2str(j)], input_path_gt, output_file_name);

                   fprintf(comb_fin_f, ['%.10f,' num2str(j) ',' algo_names{i} '\n'], f_diffs);
                   fprintf(comb_fin_Rt, ['%.10f,%.10f,' num2str(j) ',' algo_names{i} '\n'], [R_diffs'; t_diffs']);
            end
        end
        fclose(comb_fin_f);
        fclose(comb_fin_Rt);
    end
end