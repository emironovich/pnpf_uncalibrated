input_path = 'scripts/bench/courtyard/ransac_11_02';
output_file_name = 'courtyard_ransac_11_02';

% write column names
fin_f = fopen([output_file_name '_f.csv'], 'w');
fprintf(fin_f, 'f,algo\n');
fin_rel = fopen([output_file_name '_Rt_rel.csv'], 'w');
fprintf(fin_rel, 'R,t,algo\n');
fin_abs = fopen([output_file_name '_Rt_abs.csv'], 'w');
fprintf(fin_abs, 'R,t,algo\n');
fclose(fin_f);
fclose(fin_rel);
fclose(fin_abs); 

make_bench('real', input_path, output_file_name);
%make_bench('p35p', input_path, output_file_name);
make_bench('p4p', input_path, output_file_name);