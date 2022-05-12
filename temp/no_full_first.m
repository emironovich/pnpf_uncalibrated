% compare filter/ no filter + ransac/loransac
% numbers of camera/trials
% first found or found/not found number list

% bench_names = {'courtyard','delivery_area','electro','facade','kicker','office','pipes','playground','relief','relief_2','terrace','terrains'};
%bench_names = {'courtyard','delivery_area','facade','kicker','pipes','relief','relief_2','terrace'};

res_date = '26_06';
param_name = 'f';
trials_num = 5;

bench_names = {'courtyard','delivery_area','electro','facade','kicker','office', 'meadow', 'pipes','playground','relief','relief_2','terrace','terrains'}; %'facade','kicker'
%bench_names = {'courtyard'}; %,'delivery_area','electro','facade','kicker','office', 'meadow'}; %'facade','kicker'
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
        t = tiledlayout(3, 3);
        
        method_name = methods{ind_method};
        base_name = [bench_name '_' method_name '_' res_date];
        combined_name_full = ['combined_30_150_' base_name];
        combined_name_no = ['combined_40_140_' base_name];
        combined_name_first = ['combined_50_130_' base_name];
        
        % find main parameter
        if param_name == 'f'
            [p35p_full, p4p_full, real_full] = read_algo_csv([combined_name_full '_f.csv']);
        else
            [p35p_full, p4p_full, real_full] = read_algo_csv([combined_name_full '_Rt.csv']);
        end
        
        if param_name == 'f'
            [p35p_no, p4p_no, real_no] = read_algo_csv([combined_name_no '_f.csv']);
        else
            [p35p_no, p4p_no, real_no] = read_algo_csv([combined_name_no '_Rt.csv']);
        end
        
        if param_name == 'f'
            [p35p_first, p4p_first, real_first] = read_algo_csv([combined_name_first '_f.csv']);
        else
            [p35p_first, p4p_first, real_first] = read_algo_csv([combined_name_first '_Rt.csv']);
        end
        
        a_full = min([min(log10(p35p_full(:,param_num))) min(log10(p4p_full(:,param_num))) min(log10(real_full(:,param_num)))]) - 0.5;
        b_full = max([max(log10(p35p_full(:,param_num))) max(log10(p4p_full(:,param_num))) max(log10(real_full(:,param_num)))]) + 0.5;
        
        a_no = min([min(log10(p35p_no(:,param_num))) min(log10(p4p_no(:,param_num))) min(log10(real_no(:,param_num)))]) - 0.5;
        b_no = max([max(log10(p35p_no(:,param_num))) max(log10(p4p_no(:,param_num))) max(log10(real_no(:,param_num)))]) + 0.5;
        
        a_first = min([min(log10(p35p_first(:,param_num))) min(log10(p4p_first(:,param_num))) min(log10(real_first(:,param_num)))]) - 0.5;
        b_first = max([max(log10(p35p_first(:,param_num))) max(log10(p4p_first(:,param_num))) max(log10(real_first(:,param_num)))]) + 0.5;
        
        a = min([a_full a_no a_first]);
        b = max([b_full b_no a_first]);
        
        x_values = a:0.1:b;
        
        r = 0;
        ax{1 + r} = nexttile;
        make_one_tile(p35p_full, 'p35p', '[30; 150]', x_values, trials_num, param_num)
        ax{2 + r} = nexttile;
        make_one_tile(p4p_full, 'p4p', '[30; 150]', x_values, trials_num, param_num)
        ax{3 + r} = nexttile;
        make_one_tile(real_full, 'real', '[30; 150]', x_values, trials_num, param_num)
        
        r = 3;
        ax{1 + r} = nexttile;
        make_one_tile(p35p_no, 'p35p', '[40; 140]', x_values, trials_num, param_num)
        ax{2 + r} = nexttile;
        make_one_tile(p4p_no, 'p4p', '[40; 140]', x_values, trials_num, param_num)
        ax{3 + r} = nexttile;
        make_one_tile(real_no, 'real', '[40; 140]', x_values, trials_num, param_num)
        
        r = 6;
        ax{1 + r} = nexttile;
        make_one_tile(p35p_first, 'p35p', '[50; 130]', x_values, trials_num, param_num)
        ax{2 + r} = nexttile;
        make_one_tile(p4p_first, 'p4p', '[50; 130]', x_values, trials_num, param_num)
        ax{3 + r} = nexttile;
        make_one_tile(real_first, 'real', '[50; 130]', x_values, trials_num, param_num)
        
   linkaxes([ax{1},ax{2},ax{3},ax{4},ax{5},ax{6},ax{7},ax{8},ax{9}],'xy');
   if param_name == 'f'
        title(t, ['log_{10} относительной ошибки фокусного расстояния в результате работы на датасете ' bench_name ' из eth3d']);
   elseif param_name == 'R'
        title(t, ['log_{10} ошибки во вращении (в градусах) в результате работы на датасете ' bench_name ' из eth3d']);
   else
        title(t, ['log_{10} относительные ошибки в смещении в результате работы на датасете ' bench_name ' из eth3d']);
   end
   saveas(fig, ['fov_' method_name '_' bench_name '_' res_date '_' param_name '.png']);
        %print(fig, ['combined_' bench_name '_' res_date '_' param_name], '-depsc');
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

function str = find_iter_num_xlabel(algo_name, trials_num, res_date, method_name, bench_name, cameras_num, filter_name)
        iter_num_m = zeros(trials_num, 1);
        nums_full = [];
        cams_full = [];
        for i = 1 : trials_num
            if strcmp(filter_name, 'full')
                iter_num_m(i) = get_trials_num(['data/eth3d_results_fov_full_filter_' res_date '/' method_name '/' bench_name '/' algo_name '/' num2str(i)]);
            elseif strcmp(filter_name, 'no')
                iter_num_m(i) = get_trials_num(['data/eth3d_results_fov_no_filter_' res_date '/' method_name '/' bench_name '/' algo_name '/' num2str(i)]);
            elseif strcmp(filter_name, 'first')
                iter_num_m(i) = get_trials_num(['data/eth3d_results_fov_filter_but_first_' res_date '/' method_name '/' bench_name '/' algo_name '/' num2str(i)]);
            end
            nums_full = [nums_full ' ' num2str(iter_num_m(i))];
            cams_full = [cams_full ' ' num2str(cameras_num(i))];
        end
        str = ['iter num: ' nums_full '  cam num: ' cams_full];
%         iter_num_full = mean(iter_num_m_full);
%         iter_num_no = mean(iter_num_m_no);
%         str = {['Iter num full filter : ' num2str(iter_num_full)], ['Iter num no filter : ' num2str(iter_num_no)]};
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



