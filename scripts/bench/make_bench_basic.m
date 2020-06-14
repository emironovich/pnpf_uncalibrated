% FIX: intitialize varibles
% input_path_base = 'path/to/data';
% input_path_gt = 'path/to/gt';
% output_file_name = 'base_file_name';

% write column names
fin_f = fopen([output_file_name '_f.csv'], 'w');
fprintf(fin_f, 'f,algo\n');
fin_abs = fopen([output_file_name '_Rt.csv'], 'w');
fprintf(fin_abs, 'R,t,algo\n');
fclose(fin_f);
fclose(fin_abs); 

algo_names = {'p35p', 'p4p', 'real'};

for i = 1 : numel(algo_names)
       make_bench_abs(algo_names{i}, [input_path_base '/' algo_names{i}], input_path_gt, output_file_name);
end