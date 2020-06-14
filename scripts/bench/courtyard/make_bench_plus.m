input_path_base = 'scripts/bench/courtyard/data/ransac_plus_12_02';
input_path_gt = 'scripts/bench/courtyard/data/gt';
output_file_name_base = 'courtyard_ransac_plus_12_02';
num = 2;

% MEANS

output_file_name = [output_file_name_base '_means'];

% write column names
fin_means = fopen([output_file_name '.csv'], 'w');
fprintf(fin_means, 'f,R,t,algo\n');

means = zeros(3, num); %[f; R; t]

algo_names = {'p35p', 'p4p', 'real'};

for i = 1 : numel(algo_names)
    for j = 1 : num
        means = make_bench_abs(algo_names{i}, [input_path_base '/' algo_names{i} '/' num2str(j)], input_path_gt, 'unnecessary');
        fprintf(fin_means, ['%.15f,%.15f,%.15f,' algo_names{i} '\n'], means);
    end
end

fclose(fin_means);

% BEFORE BA

output_file_name = [output_file_name_base '_before_ba'];

% write column names
fin_ba = fopen([output_file_name '.csv'], 'w');
fprintf(fin_ba, 'f,R,t,algo\n');

algo_names = {'p35p', 'p4p', 'real'};

for i = 1 : numel(algo_names)
    for j = 1 : num
        
        means = make_bench_abs(algo_names{i}, [input_path_base '/' algo_names{i} '/' num2str(j)], input_path_gt, 'unnecessary');
        fprintf(fin_means, ['%.15f,%.15f,%.15f,' algo_names{i} '\n'], means);
    end
end

fclose(fin_means);


