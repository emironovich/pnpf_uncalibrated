% Create combined csv files from colmap output 
%for each dataset from bench_names

% file_name_f.csv  --- f, trial, algo
% file_name_Rt.csv  --- R, t, trial, algo


res_date = '07_07';
curr_date = '07_07';
trials_num = 9;

bench_names = {'courtyard','delivery_area','electro','facade','kicker','meadow', 'office','pipes','playground','relief','relief_2','terrace','terrains'};
%bench_names = {'courtyard'};
methods = {'filter_40_140', 'no_filter'};

fin_rec = fopen(['multiple_recs_' res_date '.txt'], 'w');
fprintf(fin_rec, '#Start\n');
for ind_method = 1 : numel(methods)
    for ind_bench = 1 : numel(bench_names)

        bench_name = bench_names{ind_bench};
        method_name = methods{ind_method};
        base_name = [bench_name '_' method_name '_' curr_date];

        combined_name = ['combined_only_good_' base_name];
        comb_fin_f = fopen([combined_name '_f.csv'], 'w');
        fprintf(comb_fin_f, 'f,trial,algo\n');
        comb_fin_Rt = fopen([combined_name '_Rt.csv'], 'w');
        fprintf(comb_fin_Rt, 'R,t,trial,algo\n');
        comb_fin_succ_rec = fopen([combined_name '_succ_rec.csv'], 'w');
        fprintf(comb_fin_succ_rec, 'succ_rec,algo\n'); 
        
        input_path_base = ['data/eth3d_results_fov_' res_date '/' method_name '/' bench_name];
        input_path_gt = ['data/eth3d_gt/' bench_name];
        output_file_name = 'unnecessary'; %[base_name '_trial_' num2str(j)];
        
        succ_rec_num = zeros(3, 1); % p35p, p4p, real
        
        for j = 1 : trials_num
            % write column names
            fin_f = fopen([output_file_name '_f.csv'], 'w');
            fprintf(fin_f, 'f,algo\n');
            fin_abs = fopen([output_file_name '_Rt.csv'], 'w');
            fprintf(fin_abs, 'R,t,algo\n');
            fclose(fin_f);
            fclose(fin_abs); 

            if strcmp(method_name, 'no_filter')
                algo_names = {'p35p', 'p4p', 'real'};
            else
                algo_names = {'p35p', 'p4p'};
            end
            
            for i = 1 : numel(algo_names)
               sub_rec_num = 0;
               f_diffs = [];
               R_diffs = [];
               t_diffs = [];
               
               while true
                   exact_input_path =  [input_path_base '/' algo_names{i} '/' num2str(j) '/' num2str(sub_rec_num)];
                   
                   if ~isfile([exact_input_path '/cameras.txt'])
                       break;
                   end
                   sub_rec_num = sub_rec_num + 1;
                   [~, f_diffs_temp, R_diffs_temp, t_diffs_temp] = make_bench_abs(algo_names{i}, exact_input_path, input_path_gt, output_file_name);
                   fprintf(fin_rec, [method_name ' ' bench_name ' ' algo_names{i} ' trial num: ' num2str(j) ' sz before: ' num2str(length(f_diffs)) ' sz after: ' num2str(length(f_diffs_temp)) '\n']);
                   
%                    if length(f_diffs_temp) > length(f_diffs)
%                        f_diffs = f_diffs_temp;
%                        R_diffs = R_diffs_temp;
%                        t_diffs = t_diffs_temp;
%                    end
                   f_diffs = [f_diffs; f_diffs_temp];
                   R_diffs = [R_diffs; R_diffs_temp];
                   t_diffs = [t_diffs; t_diffs_temp];
                   
               end
               
               if sub_rec_num == 1
                   succ_rec_num(i) = succ_rec_num(i) + 1;
               
                   fprintf(comb_fin_f, ['%.10f,' num2str(j) ',' algo_names{i} '\n'], f_diffs);
                   fprintf(comb_fin_Rt, ['%.10f,%.10f,' num2str(j) ',' algo_names{i} '\n'], [R_diffs'; t_diffs']);
               end
            end
        end
        for i = 1 : numel(algo_names)
            fprintf(comb_fin_succ_rec, ['%d,' algo_names{i} '\n'], succ_rec_num(i));
        end
        fclose(comb_fin_f);
        fclose(comb_fin_Rt);
        fclose(comb_fin_succ_rec);
    end
end

fclose(fin_rec);