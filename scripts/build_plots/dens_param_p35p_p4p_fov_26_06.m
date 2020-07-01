% Build plots of probability density for P3.5Pf and P4Pf with LO-RANSAC 
% with different fov restrictions for each dataset from bench_names

% 2 x 4 

res_date = '26_06';
param_name = 'f';
trials_num = 16;

% bench_names = {'courtyard','delivery_area','electro','facade','kicker','meadow','office','pipes','playground','relief','relief_2','terrace','terrains'};
%bench_names = {'courtyard','delivery_area','electro','facade','kicker','office', 'pipes','playground','relief','relief_2','terrace','terrains'}; %'facade','kicker'
bench_names = {'courtyard'}; %
methods = {'loransac'};

if param_name == 't'
    param_num = 2;
else %f or R
    param_num = 1;
end



for ind_bench = 1 : numel(bench_names)    
    for ind_method = 1 : numel(methods)
        
        bench_name = bench_names{ind_bench};
        fig = figure('Name', bench_name, 'WindowState', 'maximized');
        t = tiledlayout(2, 4);
        
        method_name = methods{ind_method};
        base_name = [bench_name '_' method_name '_' res_date];
        combined_name_30_150  = ['combined_30_150_' base_name];
        combined_name_40_140 = ['combined_40_140_' base_name];
        combined_name_50_130 = ['combined_50_130_' base_name];
        combined_name_no_check = ['comparison_results/combined_' bench_name '_' method_name '_15_06'];
        
        % find main parameter
        if param_name == 'f'
            [p35p_30_150 , p4p_30_150 , ~ ] = read_algo_csv([combined_name_30_150  '_f.csv']);
        else
            [p35p_30_150 , p4p_30_150 , ~ ] = read_algo_csv([combined_name_30_150  '_Rt.csv']);
        end
        
        if param_name == 'f'
            [p35p_40_140, p4p_40_140, ~] = read_algo_csv([combined_name_40_140 '_f.csv']);
        else
            [p35p_40_140, p4p_40_140, ~] = read_algo_csv([combined_name_40_140 '_Rt.csv']);
        end
        
        if param_name == 'f'
            [p35p_50_130, p4p_50_130, ~] = read_algo_csv([combined_name_50_130 '_f.csv']);
        else
            [p35p_50_130, p4p_50_130, ~] = read_algo_csv([combined_name_50_130 '_Rt.csv']);
        end
        
        if param_name == 'f'
            [p35p_no_check, p4p_no_check, ~] = read_algo_csv([combined_name_no_check '_f.csv']);
        else
            [p35p_no_check, p4p_no_check, ~] = read_algo_csv([combined_name_no_check '_Rt.csv']);
        end
        
        a_30_150  = min([min(log10(p35p_30_150 (:,param_num))) min(log10(p4p_30_150 (:,param_num)))]) - 0.5;
        b_30_150  = max([max(log10(p35p_30_150 (:,param_num))) max(log10(p4p_30_150 (:,param_num)))]) + 0.5;
        
        a_40_140 = min([min(log10(p35p_40_140(:,param_num))) min(log10(p4p_40_140(:,param_num)))]) - 0.5;
        b_40_140 = max([max(log10(p35p_40_140(:,param_num))) max(log10(p4p_40_140(:,param_num)))]) + 0.5;
        
        a_50_130 = min([min(log10(p35p_50_130(:,param_num))) min(log10(p4p_50_130(:,param_num)))]) - 0.5;
        b_50_130 = max([max(log10(p35p_50_130(:,param_num))) max(log10(p4p_50_130(:,param_num)))]) + 0.5;
        
        a_no_check = min([min(log10(p35p_no_check(:,param_num))) min(log10(p4p_no_check(:,param_num)))]) - 0.5;
        b_no_check = max([max(log10(p35p_no_check(:,param_num))) max(log10(p4p_no_check(:,param_num)))]) + 0.5;
        
        a = min([a_30_150  a_40_140 a_50_130 a_no_check]);
        b = max([b_30_150  b_40_140 a_50_130 b_no_check]);
        
        x_values = a:0.1:b;
        
        r = 0;
        ax{1 + r} = nexttile;
        make_one_tile(p35p_no_check , 'p35p', 'no fov check', x_values, 9, param_num);
        ax{2 + r} = nexttile;        
        make_one_tile(p35p_30_150 , 'p35p', '[30; 150]', x_values, trials_num, param_num);
        ax{3 + r} = nexttile;
        make_one_tile(p35p_40_140, 'p35p', '[40; 140]', x_values, trials_num, param_num);
        ax{4 + r} = nexttile;
        make_one_tile(p35p_50_130, 'p35p', '[50; 130]', x_values, trials_num, param_num);
        
        
        r = 4;
        ax{1 + r} = nexttile;
        make_one_tile(p4p_no_check , 'p4p', 'no fov check', x_values, 9, param_num);
        ax{2 + r} = nexttile;        
        make_one_tile(p4p_30_150 , 'p4p', '[30; 150]', x_values, trials_num, param_num);
        ax{3 + r} = nexttile;
        make_one_tile(p4p_40_140, 'p4p', '[40; 140]', x_values, trials_num, param_num);
        ax{4 + r} = nexttile;
        make_one_tile(p4p_50_130, 'p4p', '[50; 130]', x_values, trials_num, param_num);

        
   linkaxes([ax{1},ax{2},ax{3},ax{4},ax{5},ax{6},ax{7},ax{8}],'xy');
   if param_name == 'f'
        title(t, ['log_{10} относительной ошибки фокусного расстояния в результате работы на датасете ' bench_name ' из eth3d']);
   elseif param_name == 'R'
        title(t, ['log_{10} ошибки во вращении (в градусах) в результате работы на датасете ' bench_name ' из eth3d']);
   else
        title(t, ['log_{10} относительные ошибки в смещении в результате работы на датасете ' bench_name ' из eth3d']);
   end
   %saveas(fig, ['fov_' method_name '_' bench_name '_' res_date '_' param_name '.png']);
  % print(fig, ['fov_' method_name '_' bench_name '_' res_date '_' param_name], '-depsc');
    end
end
close all;

function camera_nums = build_graphs(data, line_type, x_values, trials_num, param_num)
    hold on
    camera_nums = zeros(1, trials_num);
    for i = 1:trials_num
        curr = data(data(:,end) == i, param_num);
        camera_nums(i) = length(curr);
        if isempty(curr)
            continue;
        end
        pd = fitdist(log10(curr),'Kernel');
        y = pdf(pd,x_values);
        plot(x_values,y, line_type, 'LineWidth',2)
    end
    hold off 
end

function make_one_tile(data, algo_name, filter_name, x_values, trials_num, param_num)
        build_graphs(data, '-', x_values, trials_num, param_num);
%         str = find_iter_num_xlabel(algo_name, trials_num, res_date, method_name, bench_name, cameras_num, filter_name);
%         xlabel(str);
        if strcmp(algo_name, 'real')
            algo_name = 'colmap';
        end
        title([ upper(algo_name) ' + ' filter_name]);

end



