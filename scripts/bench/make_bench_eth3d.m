bench_names = {'courtyard','delivery_area','electro','facade','kicker','office','pipes','playground','relief','relief_2','terrace','terrains'};
%bench_names = {'courtyard','delivery_area','facade','kicker','pipes','relief','relief_2','terrace'};
tiledlayout(3,4);
base_name = 'ransac_26_05_no_filter';

combined_name = ['combined_' base_name];
comb_fin_f = fopen([combined_name '_f.csv'], 'w');
fprintf(comb_fin_f, 'f,algo\n');
comb_fin_Rt = fopen([combined_name '_Rt.csv'], 'w');
fprintf(comb_fin_Rt, 'R,t,algo\n'); 
    
for j = 1 : numel(bench_names)
    input_path_base = ['data/eth3d_results_ransac_26_05/' bench_names{j}];
    input_path_gt = ['data/eth3d_gt/' bench_names{j}];
    output_file_name = [bench_names{j} '_' base_name];
    
    % write column names
    fin_f = fopen([output_file_name '_f.csv'], 'w');
    fprintf(fin_f, 'f,algo\n');
    fin_abs = fopen([output_file_name '_Rt.csv'], 'w');
    fprintf(fin_abs, 'R,t,algo\n');
    fclose(fin_f);
    fclose(fin_abs); 

    algo_names = {'p35p', 'p4p', 'real'};
    colors = {'r','b','g'};
    ax{j} = nexttile;
    hold on
    for i = 1 : numel(algo_names)
           [~, f_diffs, R_diffs, t_diffs] = make_bench_abs(algo_names{i}, [input_path_base '/' algo_names{i}], input_path_gt, output_file_name);
           histogram(log10(f_diffs), 'FaceColor', colors{i}, 'FaceAlpha', 0.2);
           
           fprintf(comb_fin_f, ['%.10f,' algo_names{i} '\n'], f_diffs);
           fprintf(comb_fin_Rt, ['%.10f,%.10f,' algo_names{i} '\n'], [R_diffs'; t_diffs']);
    end
    hold off
    title(bench_names{j});
end
fclose(comb_fin_f);
fclose(comb_fin_Rt);
    
linkaxes([ax{1},ax{2},ax{3},ax{4},ax{5},ax{6},ax{7},ax{8},ax{9},ax{10},ax{11},ax{12}],'x');