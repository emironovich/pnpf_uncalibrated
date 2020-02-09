path = 'scripts/bench/courtyard/data_3/';
path_gt = 'scripts/bench/courtyard/data/';
[cameras_real, images_real, ~] = read_model([path 'real']);
[cameras_p35p, images_p35p, ~] = read_model([path 'p35p']);
[cameras_p4p, images_p4p, ~] = read_model([path 'p4p']);
[cameras_gt, images_gt, ~] = read_model([path_gt 'gt']);

[f_p35p, R_p35p, T_p35p] = cmp_solvers_relative(cameras_gt, images_gt, cameras_p35p, images_p35p);
[f_p4p, R_p4p, T_p4p] = cmp_solvers_relative(cameras_gt, images_gt, cameras_p4p, images_p4p);
[f_real, R_real, T_real] = cmp_solvers_relative(cameras_gt, images_gt, cameras_real, images_real);

fin_f = fopen('becnchmark_courtyard_f_fixed_loransac.csv', 'wb');
fprintf(fin_f, "f,algo\n");
fprintf(fin_f, "%f,'p35p'\n", f_p35p);
fprintf(fin_f, "%f,'p4p'\n", f_p4p);
fprintf(fin_f, "%f,'orig'\n", f_real);

fin_Rt = fopen('becnchmark_courtyard_Rt_fixed_loransac.csv', 'wb');
fprintf(fin_Rt, "R, t,algo\n");
fprintf(fin_Rt, "%f,%f,'p35p'\n", [R_p35p'; T_p35p']);
fprintf(fin_Rt, "%f,%f,'p4p'\n", [R_p4p'; T_p4p']);
fprintf(fin_Rt, "%f,%f,'orig'\n", [R_real'; T_real']);

fclose(fin_Rt);
fclose(fin_f);